import 'package:flutter/material.dart';

class StatusPillWidget extends StatelessWidget {
  final String status;
  const StatusPillWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = (status.isEmpty ? 'open' : status).toLowerCase();

    String label;
    switch (normalized) {
      case 'planned':
        label = 'Geplant';
        break;
      case 'in_progress':
        label = 'In Arbeit';
        break;
      case 'done':
        label = 'Erledigt';
        break;
      case 'rejected':
        label = 'Abgelehnt';
        break;
      case 'open':
      default:
        label = 'Offen';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(36),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black.withAlpha(185),
        ),
      ),
    );
  }
}
