import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../../../../utils/lang/colors.dart';
import '../../../../../../shared/widgets/working_in_progress.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final double remainingQuota = 50; // Dynamic value
  final double successRequest = 30; // Dynamic value
  final double errorRequest = 20; // Dynamic value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Technical Support',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Spacer(),
                  _buildIconButton(Icons.wifi),
                  SizedBox(width: 8),
                  _buildIconButton(Icons.lock),
                  SizedBox(width: 8),
                  _buildIconButton(Icons.exit_to_app),
                ],
              ),
              SizedBox(height: 8),
              _buildDetailsCard(),
              SizedBox(height: 20),
              Text('Graph View', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              _buildGaugeCard('Remaining Quota Request a Day', remainingQuota),
              _buildGaugeCard('Success Request', successRequest),
              _buildGaugeCard('Error Request', errorRequest),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {Color iconColor = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor),
        onPressed: () {},
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '6281377239880 - 0SNP1FU',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
            ),
            Text('ID: c0cf90c3-bd80-40bb-a383-1cdb35680d4a', style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 10),
            _buildDetailRow('Paket', 'FREE'),
            _buildDetailRow('Kuota', '200'),
            _buildDetailRow('Tanggal Kadarluarsa', '2024-12-25 04:14:35'),
            _buildDetailRow('Status', 'Active', textColor: Colors.green),
            _buildDetailRow('Type Inbox', 'Ticket'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.primaryVariant)),
          Text(value, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }

  Widget _buildGaugeCard(String title, double value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 10),
            _buildGauge(value),
          ],
        ),
      ),
    );
  }

  Widget _buildGauge(double value) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(thickness: 10, color: Colors.grey.shade300),
          pointers: [
            RangePointer(value: value, width: 10, color: Colors.blue, cornerStyle: CornerStyle.bothCurve),
          ],
          annotations: [
            GaugeAnnotation(
              widget: Text('$value%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              positionFactor: 0.1,
            ),
          ],
        ),
      ],
    );
  }
}

//
// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Center(
// child: WidgetWorkingInProgress(
// title: 'Info Screen',
// ),
// ),
// ],
// ),
