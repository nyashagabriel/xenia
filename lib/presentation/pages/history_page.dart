// ============================================================
// history_page.dart
// ------------------------------------------------------------
// Page: History - Connection Log.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../logic/auth_provider.dart';
import '../../logic/history_provider.dart';
import '../../core/constants/x_constants.dart';
import '../../core/theme/x_colors.dart';
import '../widgets/x_glass_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId != null) {
      context.read<HistoryProvider>().fetchHistory(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    final auth = context.watch<AuthProvider>();
    final userId = auth.currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('CONNECTIONS', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
      ),
      body: history.isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.matches.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: history.matches.length,
                  itemBuilder: (context, index) {
                    final match = history.matches[index];
                    final partnerName = history.getPartnerName(match, userId);
                    final date = DateTime.tryParse(match['started_at']) ?? DateTime.now();
                    final duration = match['duration_seconds'] ?? 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: XGlassCard(
                        borderRadius: 20,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 24, backgroundColor: XColors.primaryPurple.withOpacity(0.2), child: Text(partnerName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(partnerName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'SpaceGrotesk')),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM dd, HH:mm').format(date),
                                    style: const TextStyle(fontSize: 10, color: Colors.white38),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${(duration / 60).toStringAsFixed(1)}m', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                const Text('DURATION', style: TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Opacity(opacity: 0.2, child: Icon(Icons.history_toggle_off, size: 80, color: Colors.white)),
            const SizedBox(height: 24),
            const Text('No connections yet.', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, fontFamily: 'SpaceGrotesk')),
            const SizedBox(height: 12),
            const Text(
              'The world is full of strangers waiting to meet you. Start matching to build your history.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}
