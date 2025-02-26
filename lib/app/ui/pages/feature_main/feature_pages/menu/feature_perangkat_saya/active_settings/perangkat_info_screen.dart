import 'package:flutter/material.dart';

import '../../../../../../shared/widgets/custom_textfield.dart';

class PerangkatInfoScreen extends StatefulWidget {
  const PerangkatInfoScreen({super.key});

  @override
  State<PerangkatInfoScreen> createState() => _PerangkatInfoScreenState();
}

class _PerangkatInfoScreenState extends State<PerangkatInfoScreen> {
  final TextEditingController idController = TextEditingController(text: 'Z04B80');
  final TextEditingController nameController = TextEditingController(text: 'Technical Support');
  final TextEditingController whatsappController = TextEditingController(text: '+6281377239880');

  String selectedInboxType = 'Live Chat';
  final List<String> inboxTypes = ['Live Chat', 'Email', 'Phone Support'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildLabel('ID Perangkat', 'Informasi ID Perangkat.', idController),
            SizedBox(height: 15),
            _buildDropdown(
              'Jenis Inbox',
              'Pengaturan jenis inbox.',
            ),
            SizedBox(height: 15),
            _buildLabel('Nama Perangkat', 'Informasi nama perangkat.', nameController),
            // _buildTextField(nameController),
            SizedBox(height: 15),
            _buildLabel('Nomor Whatsapp', 'Informasi nomor whatsapp.', whatsappController),
            // _buildTextField(whatsappController),
            Spacer(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String title, String subtitle, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              subtitle,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.black38),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        WidgetWithOutlineTextField(
            label: '',
            controller: controller,
            textInputType: TextInputType.number,
            prefixColor: Colors.black38,
            suffixColor: Colors.red,
            textAlign: TextAlign.start),
      ],
    );
  }

  Widget _buildDropdown(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              subtitle,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.black38),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        DropdownButtonFormField<String>(
          value: selectedInboxType,
          items: inboxTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedInboxType = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
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
}
