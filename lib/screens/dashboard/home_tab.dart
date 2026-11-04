import 'package:flutter/material.dart';

import '../../models/dashboard_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/icon_art.dart';
import 'categories_screen.dart';

/// The dashboard's Home tab: greeting, category strip and today's orders.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashboardTopBar(),
        Expanded(
          child: ListView(
            key: const PageStorageKey<String>('home-scroll'),
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
            children: [
              _Greeting(greeting: greetingForHour(DateTime.now().hour)),
              const SizedBox(height: 22),
              _SectionHeader(
                title: 'CATEGORIES',
                action: 'View All',
                onAction: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CategoriesScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 132,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.zero,
                  itemCount: kCategories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => CategoryCard(
                    category: kCategories[index],
                    selected: index == _selectedCategory,
                    onTap: () => setState(() => _selectedCategory = index),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              _TodaysOrdersHeader(total: kTotalOrders),
              const SizedBox(height: 14),
              for (final order in kOrders) ...[
                OrderCard(order: order),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Menu button, the Diet Pro wordmark and the wallet button.
class DashboardTopBar extends StatelessWidget {
  const DashboardTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          _SquareButton(
            asset: 'assets/icons/menu.png',
            background: AppColors.chipGrey,
            tooltip: 'Menu',
            onTap: () => Scaffold.of(context).openDrawer(),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.titleWordmark, height: 28),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.navActive,
                ),
              ),
            ],
          ),
          const Spacer(),
          _SquareButton(
            asset: 'assets/icons/wallet.svg',
            background: AppColors.livePillBg,
            tooltip: 'Wallet',
            badge: true,
            onTap: () => _notReady(context, 'Wallet'),
          ),
        ],
      ),
    );
  }
}

void _notReady(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$what is not available yet.')));
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.asset,
    required this.background,
    required this.tooltip,
    required this.onTap,
    this.badge = false,
  });

  final String asset;
  final Color background;
  final String tooltip;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconArt(asset),
            ),
            if (badge)
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.greeting});

  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: AppColors.greetingGrey,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kitchen\nSummary',
                style: TextStyle(
                  fontSize: 27,
                  height: 1.18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.headingDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const _LiveOrdersPill(),
      ],
    );
  }
}

class _LiveOrdersPill extends StatelessWidget {
  const _LiveOrdersPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.livePillBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.navActive,
            ),
          ),
          const SizedBox(width: 11),
          const Text(
            'Live Orders',
            style: TextStyle(
              fontSize: 20,
              height: 2,
              fontWeight: FontWeight.w600,
              color: AppColors.headingGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onAction,
  });

  final String title;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: AppColors.headingDark,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          behavior: HitTestBehavior.opaque,
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.accentGreen,
            ),
          ),
        ),
      ],
    );
  }
}

/// A category tile. The selected one inverts to the brand green.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
    this.width = 104,
  });

  final FoodCategory category;
  final bool selected;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: width,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.brandGreen : AppColors.cardBorder2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: selected ? 0.12 : 0.04),
              blurRadius: selected ? 14 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          // Expand, or the column shrinks to its label and the icon sits
          // left of centre on cards with short names.
          fit: StackFit.expand,
          children: [
            // Count pinned to the corner so the icon can sit centred.
            Positioned(
              top: 0,
              right: 0,
              child: Text(
                '${category.count}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.headingDark,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.14)
                        : category.tint,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(9),
                  child: IconArt(category.icon),
                ),
                const Spacer(),
                Text(
                  category.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.headingDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodaysOrdersHeader extends StatelessWidget {
  const _TodaysOrdersHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.livePillBg,
            borderRadius: BorderRadius.circular(9),
          ),
          padding: const EdgeInsets.all(6),
          child: const IconArt('assets/icons/orders_cloche.png'),
        ),
        const SizedBox(width: 10),
        const Text(
          "Today's Orders",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.headingDark,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.chipGrey,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '$total total',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedText,
            ),
          ),
        ),
      ],
    );
  }
}

/// One dish in today's order list.
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _notReady(context, order.name),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder2),
          ),
          child: Row(
            children: [
              _Thumbnail(order: order),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.groups_rounded,
                          size: 15,
                          color: AppColors.accentGreen,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${order.orders} Orders',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.headingDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      order.description,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.chipGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  size: 19,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stand-in for the dish photo, with the price tag tucked into its corner.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              order.image,
              width: 68,
              height: 68,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: -2,
            bottom: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.brandGreen,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                '₹${order.price}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
