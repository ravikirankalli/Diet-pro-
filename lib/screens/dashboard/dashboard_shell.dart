import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../login_screen.dart';
import 'home_tab.dart';
import 'simple_tabs.dart';

/// The dashboard: the kitchen summary, a drawer for the other sections and
/// a single floating action button.
class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key, this.dietitianId = ''});

  final String dietitianId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      drawer: _MenuDrawer(dietitianId: dietitianId),
      body: const SafeArea(bottom: false, child: HomeTab()),
      floatingActionButton: const _AddButton(),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddSheet(context),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.navActive,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.navActive.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

void _showAddSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Quick add',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.headingDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Creating dishes and orders is not wired up yet.',
              style: TextStyle(fontSize: 14, color: AppColors.mutedText),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    ),
  );
}

/// Reaches the sections that used to sit in the bottom bar.
class _MenuDrawer extends StatelessWidget {
  const _MenuDrawer({required this.dietitianId});

  final String dietitianId;

  @override
  Widget build(BuildContext context) {
    void open(Widget screen) {
      Navigator.of(context)
        ..pop()
        ..push(MaterialPageRoute<void>(builder: (_) => screen));
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
              child: Image.asset(AppAssets.titleWordmark, height: 32),
            ),
            if (dietitianId.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  dietitianId,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
            const Divider(height: 20),
            _DrawerItem(
              icon: Icons.pie_chart_rounded,
              label: 'Analytics',
              onTap: () => open(const AnalyticsScreen()),
            ),
            _DrawerItem(
              icon: Icons.receipt_long_rounded,
              label: 'Orders',
              onTap: () => open(const OrdersScreen()),
            ),
            _DrawerItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              onTap: () => open(const SettingsScreen()),
            ),
            const Divider(height: 20),
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Sign out',
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accentGreen, size: 21),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.headingDark,
        ),
      ),
      onTap: onTap,
    );
  }
}
