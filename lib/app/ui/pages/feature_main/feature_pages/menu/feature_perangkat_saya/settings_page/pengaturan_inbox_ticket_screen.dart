import 'package:flutter/material.dart';
import 'package:wasender/app/utils/lang/images.dart';

import '../../../../../../shared/widgets/custom_textfield.dart';
import '../../../../../../shared/widgets/working_in_progress.dart';

class PengaturanInboxTicketScreen extends StatefulWidget {
  const PengaturanInboxTicketScreen({super.key});

  @override
  State<PengaturanInboxTicketScreen> createState() => _PengaturanInboxTicketScreenState();
}

class _PengaturanInboxTicketScreenState extends State<PengaturanInboxTicketScreen> {
  String inboxType = "Ticket";
  bool adminTicket = true;
  bool customerNotification = true;
  bool contactMasking = true;
  bool autoGreeting = true;
  String selectedDelay = "15 Detik";
  int broadcastSpeed = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.0),
              WidgetBuildLabel(
                title: "Inbox Type",
                subtitle: "Informasi jenis kotak masuk kotak obrolan",
                value: "Ticket",
                controller: TextEditingController(text: inboxType),
                onChanged: (val) {
                  setState(() => inboxType = val);
                },
                keyboardType: TextInputType.text, // Do something with the value
              ),
              Column(
                children: [
                  WidgetBuildSwitch(
                      title: "Admin Ticket",
                      subtitle: "Admin juga dapat berperan sebagai agen untuk membuat tiket percakapan.",
                      value: adminTicket,
                      onChanged: (val) {
                        setState(() => adminTicket = val);
                      }),
                  SizedBox(height: 16),
                  WidgetBuildSwitch(
                      title: "Notifikasi Percakapan Customer",
                      subtitle: "Admin mendapatkan notifikasi percakapan dari customer yang di handle oleh agent.",
                      value: customerNotification,
                      onChanged: (val) {
                        setState(() => customerNotification = val);
                      }),
                  SizedBox(height: 16),
                  WidgetBuildSwitch(
                      title: "Kontak Masking",
                      subtitle:
                          "Tujuan dari penyembunyian informasi kontak adalah untuk melindungi privasi individu dan bisnis dengan menyembunyikan nomor telepon mereka.",
                      value: contactMasking,
                      onChanged: (val) {
                        setState(() => contactMasking = val);
                      }),
                  SizedBox(height: 16),
                  WidgetBuildSwitch(
                      title: "Salam Otomatis Pelanggan",
                      subtitle: "Kirim salam secara otomatis ketika ada pesan masuk dari pelanggan Anda.",
                      value: autoGreeting,
                      onChanged: (val) {
                        setState(() => autoGreeting = val);
                      }),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                style: TextStyle(fontSize: 14),
                maxLines: 7,
                decoration: InputDecoration(
                  hintText:
                      "(Ini adalah pesan otomatis) Halo, mohon menunggu Customer Support kami akan segera membantu Anda. Terima Kasih",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Grey outline
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Grey when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5), // Darker grey when focused
                  ),
                  hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
                ),
              ),
              SizedBox(height: 24),
              Image.asset(
                CustomImages.imageIphone, // Path to your image in assets
                height: MediaQuery.of(context).size.height / 2, // Optional: Adjust the height
                width: double.infinity, // Optional: Make it full width
                fit: BoxFit.fitHeight, // Optional: Adjust how the image fits
              ),
              SizedBox(height: 48),
              Text("Kecepatan Pesan Broadcast", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              DropdownButtonFormField(
                value: selectedDelay,
                items: ["15 Detik", "30 Detik", "45 Detik", "60 Detik"].map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() => selectedDelay = newValue as String);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Grey outline
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Grey when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5), // Darker grey when focused
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding for better spacing
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Kecepatan Pesan Broadcast", style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (broadcastSpeed > 1) broadcastSpeed--;
                          });
                        },
                      ),
                      Text("$broadcastSpeed", style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() => broadcastSpeed++);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSaveButton() {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(
        Icons.save,
        color: Colors.white,
      ),
      label: Text('Simpan'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
