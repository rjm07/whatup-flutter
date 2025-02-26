import 'package:flutter/material.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/menu/feature_perangkat_saya/settings_page/agent_screen.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/menu/feature_perangkat_saya/settings_page/info_screen.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/menu/feature_perangkat_saya/settings_page/pengaturan_inbox_ticket_screen.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/menu/feature_perangkat_saya/settings_page/perangkat_info_screen.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/menu/feature_profile/my_profile/tabs/security.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/menu/feature_profile/my_profile/tabs/view_profile.dart';

import '../../../../../../core/services/navigation/navigation.dart';
import '../../../../../../utils/lang/colors.dart';

class InformasiPerangkatScreen extends StatefulWidget {
  final int initialTabIndex;

  const InformasiPerangkatScreen({
    super.key,
    this.initialTabIndex = 0,
  }); // Default to tab 0

  @override
  State<InformasiPerangkatScreen> createState() => _InformasiPerangkatScreenState();
}

class _InformasiPerangkatScreenState extends State<InformasiPerangkatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: widget.initialTabIndex);
    _pageController = PageController(initialPage: widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onPageChanged(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            NavService.pop(pages: 2);
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text('Perangkat Saya', style: TextStyle(color: Colors.white, fontSize: 20)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black38,
          indicatorWeight: 0.75,
          dividerColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontSize: 12),
          onTap: _onTabTapped, // Handle tab tap to switch page
          tabs: const [
            Tab(icon: Icon(Icons.phone_iphone_rounded), text: 'Info'),
            Tab(icon: Icon(Icons.edit_note_outlined), text: 'Perangkat'),
            Tab(icon: Icon(Icons.settings), text: 'Pengaturan'),
            Tab(icon: Icon(Icons.headphones), text: 'Agent'),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged, // Handle page swipe to switch tab
        children: [
          const InfoScreen(),
          const PerangkatInfoScreen(),
          const PengaturanInboxTicketScreen(),
          const AgentScreen(),
        ],
      ),
    );
  }
}
