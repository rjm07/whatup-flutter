import 'package:flutter/material.dart';
import 'package:wasender/app/utils/lang/colors.dart';

import '../../../../../../shared/widgets/working_in_progress.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  List<User> users = [
    User(name: "Destiya Febrianti", email: "ay.andrianto@gmail.com"),
    User(name: "Fadhil", email: "fadil.tenten53@gmail.com"),
    User(name: "Fernando", email: "fernando.yunus@gmail.com"),
    User(name: "Jack", email: "rjm.ideas@gmail.com"),
    User(name: "Jack", email: "rjm.ideas@gmail.com"),
  ];

  Set<int> selectedUsers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.black38,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search_outlined),
                  filled: true, // Enable background color
                  fillColor: Colors.white, // Set background to white
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey, // Default border color
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey, // Border color when not focused
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey, // Border color when focused
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.green,
                    side: BorderSide(color: Colors.grey, width: 2),
                    value: selectedUsers.contains(index),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedUsers.add(index);
                        } else {
                          selectedUsers.remove(index);
                        }
                      });
                    },
                  ),
                  title: Text(
                    users[index].name,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  subtitle: Text(users[index].email, style: TextStyle(fontSize: 14, color: Colors.black54)),
                  trailing: Text(
                    "OS1NP1FU",
                    style: TextStyle(fontSize: 14, color: AppColors.primaryVariant),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSaveButton(),
          ),
          SizedBox(height: 20),
        ],
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

class User {
  final String name;
  final String email;
  User({required this.name, required this.email});
}
