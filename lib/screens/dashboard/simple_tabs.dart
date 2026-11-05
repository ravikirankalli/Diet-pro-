import 'package:flutter/material.dart';

import '../../models/dashboard_data.dart';
import '../../theme/app_colors.dart';
import 'home_tab.dart';

/// Shared frame for the sections reached from the drawer.
class _SectionScaffold extends StatelessWidget {
  const _SectionScaffold({
    required this.title,
    required this.icon,
    required this.note,
    this.child,
  });

  final String title;
  final IconData icon;
  final String note;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.pageBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.headingDark,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.headingDark,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Text(
            note,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 20),
          if (child != null) child! else _EmptyPanel(icon: icon, title: title),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 54),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder2),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.livePillBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 30, color: AppColors.accentGreen),
          ),
          const SizedBox(height: 16),
          Text(
            '$title coming soon',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.headingDark,
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionScaffold(
      title: 'Analytics',
      icon: Icons.pie_chart_rounded,
      note: 'Sales, popular dishes and kitchen performance.',
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              label: 'Orders today',
              value: '$kTotalOrders',
              icon: Icons.receipt_long_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatTile(
              label: 'Categories',
              value: '${kCategories.length}',
              icon: Icons.grid_view_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.accentGreen),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.headingDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.mutedText),
          ),
        ],
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionScaffold(
      title: 'Orders',
      icon: Icons.receipt_long_rounded,
      note: 'Every order placed today, newest first.',
      child: Column(
        children: [
          for (final order in kOrders) ...[
            OrderCard(order: order),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SectionScaffold(
      title: 'Settings',
      icon: Icons.settings_rounded,
      note: 'Kitchen profile, staff and notification preferences.',
    );
  }
}
