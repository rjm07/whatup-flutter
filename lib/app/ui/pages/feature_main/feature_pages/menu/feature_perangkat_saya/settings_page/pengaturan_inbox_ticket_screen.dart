import 'package:flutter/material.dart';

import '../../../../../../shared/widgets/working_in_progress.dart';

class PengaturanInboxTicketScreen extends StatefulWidget {
  const PengaturanInboxTicketScreen({super.key});

  @override
  State<PengaturanInboxTicketScreen> createState() => _PengaturanInboxTicketScreenState();
}

class _PengaturanInboxTicketScreenState extends State<PengaturanInboxTicketScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: WidgetWorkingInProgress(
              title: 'Pengaturan Inbox Ticket Screen',
            ),
          ),
        ],
      ),
    );
  }
}
