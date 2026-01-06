import 'package:daily_dose_of_happiness/model/wish/wish_comment_model.dart';
import 'package:daily_dose_of_happiness/model/wish/wish_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WishRepository {
  final SupabaseClient _db;
  WishRepository(this._db);

  String _requireUid() {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) {
      throw Exception('WishRepository: User not authenticated');
    }
    return uid;
  }

  // ------------------------------------------------------------
  // Wishes
  // ------------------------------------------------------------

  Future<List<WishModel>> loadWishes() async {
    try {
      final rows = await _db
          .from('idea_public_vw')
          .select('*')
          .order('score', ascending: false)
          .order('created_at', ascending: false);

      final wishes = (rows as List)
          .map((e) => WishModel.fromJson(e as Map<String, dynamic>?))
          .toList();

      final wishIds =
          wishes.map((w) => w.id).where((id) => id.isNotEmpty).toList();
      final myVotes = await loadMyVotesForWishIds(wishIds);

      return wishes.map((w) => w.copyWith(myVote: myVotes[w.id])).toList();
    } catch (e, stacktrace) {
      throw Exception(
        'WishRepository.loadWishes failed: $e\n$stacktrace',
      );
    }
  }

  Future<Map<String, int>> loadMyVotesForWishIds(List<String> wishIds) async {
    try {
      if (wishIds.isEmpty) return {};
      _requireUid();

      final rows = await _db
          .from('idea_votes')
          .select('idea_id,value')
          .inFilter('idea_id', wishIds);

      final map = <String, int>{};
      for (final r in (rows as List)) {
        final m = r as Map<String, dynamic>?;
        final ideaId = m?['idea_id']?.toString();
        final value = m?['value'];

        if (ideaId != null && value is num) {
          map[ideaId] = value.toInt();
        }
      }
      return map;
    } catch (e, stacktrace) {
      throw Exception(
        'WishRepository.loadMyVotesForWishIds failed: $e\n$stacktrace',
      );
    }
  }

  Future<WishModel> createWish(String body) async {
    try {
      final uid = _requireUid();

      await _db.from('ideas').insert({
        'body': body,
        'author_uid': uid,
      });

      // Immer über View neu laden (Base-Table-Select ist revoked)
      final latest = await _db
          .from('idea_public_vw')
          .select('*')
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      return WishModel.fromJson(latest as Map<String, dynamic>?);
    } catch (e, stacktrace) {
      throw Exception(
        'WishRepository.createWish failed: $e\n$stacktrace',
      );
    }
  }

  Future<void> updateOwnWish({
    required String wishId,
    required String body,
  }) async {
    try {
      _requireUid();
      await _db.from('ideas').update({'body': body}).eq('id', wishId);
    } catch (e, stacktrace) {
      throw Exception(
        'WishRepository.updateOwnWish failed: $e\n$stacktrace',
      );
    }
  }

  // ------------------------------------------------------------
  // Voting
  // ------------------------------------------------------------

  Future<void> voteOnWish(
    String wishId,
    int value,
  ) async {
    try {
      final uid = _requireUid();
      if (value != 1 && value != -1) {
        throw ArgumentError('Vote value must be +1 or -1');
      }

      await _db.from('idea_votes').upsert(
        {
          'idea_id': wishId,
          'voter_uid': uid,
          'value': value,
        },
        onConflict: 'idea_id,voter_uid',
      );
    } catch (e, stacktrace) {
      throw Exception(
        'WishRepository.vote failed: $e\n$stacktrace',
      );
    }
  }

  Future<void> clearVote({required String wishId}) async {
    try {
      final uid = _requireUid();
      await _db
          .from('idea_votes')
          .delete()
          .eq('idea_id', wishId)
          .eq('voter_uid', uid);
    } catch (e, stacktrace) {
      throw Exception(
        'WishRepository.clearVote failed: $e\n$stacktrace',
      );
    }
  }

  // ------------------------------------------------------------
  // Comments
  // ------------------------------------------------------------

  Future<List<WishCommentModel>> loadComments(String wishId) async {
    try {
      final rows = await _db
          .from('idea_comment_public_vw')
          .select('*')
          .eq('idea_id', wishId)
          .order('created_at', ascending: true);

      return (rows as List)
          .map((e) => WishCommentModel.fromJson(e as Map<String, dynamic>?))
          .toList();
    } catch (e, stacktrace) {
      throw Exception(
        'WishRepository.loadComments failed: $e\n$stacktrace',
      );
    }
  }

  Future<void> addComment({
    required String wishId,
    required String body,
  }) async {
    try {
      final uid = _requireUid();
      await _db.from('idea_comments').insert({
        'idea_id': wishId,
        'commenter_uid': uid,
        'body': body,
      });
    } catch (e, stacktrace) {
      throw Exception(
        'WishRepository.addComment failed: $e\n$stacktrace',
      );
    }
  }

  Future<void> updateOwnComment({
    required String commentId,
    required String body,
  }) async {
    try {
      _requireUid();
      await _db
          .from('idea_comments')
          .update({'body': body}).eq('id', commentId);
    } catch (e, stacktrace) {
      throw Exception(
        'WishRepository.updateOwnComment failed: $e\n$stacktrace',
      );
    }
  }
}
