// ============================================================
// profile_page.dart
// ------------------------------------------------------------
// Page: 07. Profile - Reputation & Standing.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../logic/auth_provider.dart';
import '../../logic/profile_provider.dart';
import '../../core/constants/x_constants.dart';
import '../../core/theme/x_colors.dart';
import '../widgets/x_glass_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId != null) {
      context.read<ProfileProvider>().fetchFullProfile(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profile = context.watch<ProfileProvider>();
    final user = auth.userProfile;

    if (profile.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final reputation = (user?['reputation_score'] as num? ?? 100).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // User Identifier & Reputation Badge
            XGlassCard(
              borderRadius: 32,
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  CircleAvatar(radius: 48, backgroundColor: XColors.primaryPurple, child: Text(user?['display_name']?[0] ?? 'X', style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 16),
                  Text(user?['display_name'] ?? 'Anonymous', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'SpaceGrotesk')),
                  const SizedBox(height: 8),
                  
                  // Reputation Shield
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: reputation > 80 ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(100), border: Border.all(color: reputation > 80 ? Colors.green : Colors.amber, width: 1)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user, size: 16, color: reputation > 80 ? Colors.green : Colors.amber),
                        const SizedBox(width: 8),
                        Text('REPUTATION: ${reputation.toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: reputation > 80 ? Colors.green : Colors.amber)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Statistics Row
            Row(
              children: [
                Expanded(child: _buildStatCard('ENGAGEMENT', '${(profile.totalMatchDuration / 60).toStringAsFixed(1)}m', Icons.timer)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('CONNECTIONS', '${profile.profile?['match_count'] ?? 0}', Icons.people)),
              ],
            ),

            const SizedBox(height: 24),

            // Navigation Options
            _buildNavTile('Connection Log', Icons.history, () => context.push(XRoutes.history)),
            _buildNavTile('Premium / Boosts', Icons.star_border, () => context.push(XRoutes.premium)),
            _buildNavTile('Hospitality Code', Icons.assignment_outlined, () => context.push(XRoutes.legal)),
            
            const SizedBox(height: 24),
            
            TextButton(
               onPressed: () {
                  auth.signOut();
                  context.go(XRoutes.splash);
               },
               child: const Text('SIGN OUT', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return XGlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: XColors.primaryPurpleLight),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'SpaceGrotesk')),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNavTile(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: XGlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(8),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: Colors.white70),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        ),
      ),
    );
  }
}
