// ============================================================
// premium_page.dart
// ------------------------------------------------------------
// Page: 11. Paywall - Premium Boost & Unlimited.
// ============================================================

import 'package:flutter/material.dart';
import '../../core/theme/x_colors.dart';
import '../widgets/x_glass_card.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PREMIUM', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unleash the\nCatalyst.',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                fontFamily: 'SpaceGrotesk',
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Supercharge your connections and skip the limits.',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 40),

            // Tier 1: Unlimited Matches
            _buildPremiumCard(
              title: 'UNLIMITED',
              description: 'Match as much as you want. 24/7 access to the community.',
              price: r'$9.99/mo',
              icon: Icons.all_inclusive,
              color: XColors.primaryPurple,
            ),

            const SizedBox(height: 24),

            // Tier 2: The Boost
            _buildPremiumCard(
              title: 'THE BOOST',
              description: 'Jump to the front of the queue for 1 hour. Get seen first.',
              price: r'$2.99',
              icon: Icons.bolt,
              isSingle: true,
              color: XColors.accentWarning,
            ),

            const SizedBox(height: 40),

            // Comparison Table
            _buildComparisonRow('Daily Matches', '20', 'UNLIMITED'),
            _buildComparisonRow('Queue Priority', 'Standard', 'PRIORITY'),
            _buildComparisonRow('Global Access', '✓', '✓'),

            const SizedBox(height: 64),
            
            Center(
              child: Text(
                'Coming soon to your territory.',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard({required String title, required String description, required String price, required IconData icon, required Color color, bool isSingle = false}) {
    return XGlassCard(
      borderRadius: 32,
      padding: const EdgeInsets.all(32),
      border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 32),
              Text(price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'SpaceGrotesk')),
            ],
          ),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1, fontFamily: 'SpaceGrotesk')),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(color: Colors.white60, fontSize: 14)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {}, // Future In-App Purchase
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: Text(isSingle ? 'BUY ONCE' : 'GET PRO'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String feature, String freeVal, String proVal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(feature, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12)),
          Row(
            children: [
              Text(freeVal, style: const TextStyle(color: Colors.white24, fontSize: 12)),
              const SizedBox(width: 16),
              Text(proVal, style: const TextStyle(color: XColors.primaryPurpleLight, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
