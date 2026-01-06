import 'package:daily_dose_of_happiness/model/wish/wish_comment_model.dart';
import 'package:daily_dose_of_happiness/model/wish/wish_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WishRepository {
  final SupabaseClient _db;
  WishRepository(this._db);

  String _requireUid() {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw Exception('Not authenticated');
    return uid;
  }

  Future<List<WishModel>> loadWishes() async {
    // Sortierung: score desc, created_at desc
    final rows = await _db
        .from('idea_public_vw')
        .select('*')
        .order('score', ascending: false)
        .order('created_at', ascending: false);

    final wishes = (rows as List)
        .map((e) => WishModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Optional: myVote für alle in einem Rutsch laden und mergen
    final wishIds = wishes.map((w) => w.id).toList();
    final myVotes = await loadMyVotesForWishIds(wishIds);

    return wishes.map((w) => w.copyWith(myVote: myVotes[w.id])).toList();
  }

  Future<Map<String, int>> loadMyVotesForWishIds(List<String> wishIds) async {
    if (wishIds.isEmpty) return {};
    _requireUid();

    // Policy lässt nur eigene Votes zu -> select ist safe
    final rows = await _db
        .from('idea_votes')
        .select('idea_id,value')
        .inFilter('idea_id', wishIds);

    final map = <String, int>{};
    for (final r in (rows as List)) {
      final m = r as Map<String, dynamic>;
      map[m['idea_id'] as String] = (m['value'] as num).toInt();
    }
    return map;
  }

  Future<WishModel> createWish({required String body}) async {
    final uid = _requireUid();

    final row = await _db
        .from('ideas')
        .insert({
          'body': body,
          'author_uid': uid,
        })
        .select(
            'id, body, status, score, created_at, updated_at') // Base table select ist revoked -> kann scheitern
        .maybeSingle();

    // Da du Select auf ideas revoked hast, ist es sauberer, anschließend über View zu lesen:
    if (row == null) {
      // Fallback: neueste eigene Idee über View holen
      final latest = await _db
          .from('idea_public_vw')
          .select('*')
          .order('created_at', ascending: false)
          .limit(1)
          .single();
      return WishModel.fromJson(latest);
    }

    // Wenn du insert-return nutzen willst, müsstest du SELECT auf ideas erlauben,
    // was wir eigentlich vermeiden möchten.
    // Daher: standardmäßig immer über View reloaden.
    final latest = await _db
        .from('idea_public_vw')
        .select('*')
        .order('created_at', ascending: false)
        .limit(1)
        .single();

    return WishModel.fromJson(latest);
  }

  Future<void> updateOwnWish({
    required String wishId,
    required String body,
  }) async {
    _requireUid();
    await _db.from('ideas').update({'body': body}).eq('id', wishId);
  }

  Future<void> vote({
    required String wishId,
    required int value, // +1 oder -1
  }) async {
    final uid = _requireUid();
    if (value != 1 && value != -1) throw ArgumentError('Vote must be 1 or -1');

    await _db.from('idea_votes').upsert(
      {
        'idea_id': wishId,
        'voter_uid': uid,
        'value': value,
      },
      onConflict: 'idea_id,voter_uid',
    );
    // score wird via Trigger neu berechnet
  }

  Future<void> clearVote({required String wishId}) async {
    final uid = _requireUid();
    await _db
        .from('idea_votes')
        .delete()
        .eq('idea_id', wishId)
        .eq('voter_uid', uid);
  }

  Future<List<WishCommentModel>> loadComments(String wishId) async {
    final rows = await _db
        .from('idea_comment_public_vw')
        .select('*')
        .eq('idea_id', wishId)
        .order('created_at', ascending: true);

    return (rows as List)
        .map((e) => WishCommentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addComment({
    required String wishId,
    required String body,
  }) async {
    final uid = _requireUid();
    await _db.from('idea_comments').insert({
      'idea_id': wishId,
      'commenter_uid': uid,
      'body': body,
    });
  }

  Future<void> updateOwnComment({
    required String commentId,
    required String body,
  }) async {
    _requireUid();
    await _db.from('idea_comments').update({'body': body}).eq('id', commentId);
  }
}
