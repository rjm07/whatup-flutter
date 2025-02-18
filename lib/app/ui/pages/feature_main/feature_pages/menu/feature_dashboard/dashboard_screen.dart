import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/menu/feature_profile/profile_screen.dart';
import 'package:wasender/app/ui/shared/widgets/dashboard_cards.dart';

import '../../../../../../core/models/dashboard/dashboard_response.dart';
import '../../../../../../core/services/fcm.dart';
import '../../../../../../core/services/perangkat_saya/perangkat_saya.dart';
import '../../../../../../core/services/preferences.dart';
import '../../../../../../core/services/socket_io/socket.dart';
import '../../../../../../utils/lang/images.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
  ScaffoldMessengerState? scaffoldMessenger;
  String name = "Blipcom Indonesia";
  String description = "Informasi Perangkat whatsapp yang terhubung!";
  final SocketService socketService = SocketService();
  late Future<Map<String, dynamic>?> _dashboardFuture;
  late String fullName = "";
  late String image = "";
  late String role = "";
  late String fcmToken = "";

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    super.initState();

    getUserInfo();
    _dashboardFuture = getDashboardData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getDeviceList();
      getAllDevices();
    });
    WidgetsBinding.instance.addObserver(this);
    socketService.initializeSocket();
  }

  Future<void> getDeviceList() async {
    final PerangkatSayaServices devices = Provider.of<PerangkatSayaServices>(context, listen: false);
    final String? tokenBearer = await LocalPrefs.getBearerToken();
    debugPrint("tokenBearer: $tokenBearer");
    if (tokenBearer != null) {
      await devices.updateDeviceListFuture(tokenBearer, showErrorSnackbar: (String errorMessage) {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            errorMessage.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
        scaffoldMessenger?.showSnackBar(snackBar);
      });
    }
    sendFCMToken();
  }

  Future<void> getAllDevices() async {
    final PerangkatSayaServices devices = Provider.of<PerangkatSayaServices>(context, listen: false);
    final String? tokenBearer = await LocalPrefs.getBearerToken();
    debugPrint("tokenBearer: $tokenBearer");
    debugPrint("Getting all devices");
    if (tokenBearer != null) {
      await devices.updateAllDeviceListFuture(tokenBearer, showErrorSnackbar: (String errorMessage) {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            errorMessage.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
        scaffoldMessenger?.showSnackBar(snackBar);
      });
    }
  }

  static Future<void> sendFCMToken() async {
    final SendFCMTokenResponse fcmToken = await FCMServices().sendFCMToken();
    debugPrint("FCM Token: $fcmToken");
  }

  Future<Map<String, dynamic>?> getDashboardData() async {
    final PerangkatSayaServices devices = Provider.of<PerangkatSayaServices>(context, listen: false);
    final String? tokenBearer = await LocalPrefs.getBearerToken();
    debugPrint("tokenBearer: $tokenBearer");
    if (tokenBearer != null) {
      try {
        final data = await devices.getDashboardData(tokenBearer);
        return data; // Return the data
      } catch (error) {
        debugPrint("Error fetching dashboard data: $error");
        return null; // Handle errors
      }
    }
    return null; // Return null if tokenBearer is null
  }

  Future<void> getUserInfo() async {
    fullName = (await LocalPrefs.getFullName()) ?? "Guest";
    image = (await LocalPrefs.getImage()) ?? CustomIcons.iconProfilePicture;
    fcmToken = (await LocalPrefs.getFCMToken()) ?? "Dummy FCM";
    if (kDebugMode) {
      print('image: $image');
      print('fcm: $fcmToken');
    }
    role = (await LocalPrefs.getUserRole()) ?? "User";
// Trigger rebuild to update UI with fetched data
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    socketService.dispose(); // Clean up socket resources if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 4,
              child: const Center(
                child: CircularProgressIndicator(),
              ));
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final data = snapshot.data?['data'];
          int? totalPerangkat = data?['total_perangkat'];
          int? perangkatAktif = data?['perangkat_aktif'];
          int? perangkatNonAktif = data?['perangkat_non_aktif'];

          final List<dynamic>? perangkatTerhubung = data?['perangkat_terhubung'];

          return Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 24.0, right: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Hai!",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.black54),
                              ),
                              Text(
                                fullName,
                                style:
                                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: Colors.black87),
                              ),
                              Text(
                                role,
                                style:
                                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              // Add your tap handling logic here
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                            borderRadius:
                                BorderRadius.circular(50), // Matches the Container's borderRadius for ripple effect
                            child: Container(
                              height: 90, // Match the height of the image
                              width: 90, // Match the width of the image
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle, // Circular shape
                                color: Colors.white, // White background for the border
                              ),
                              child: ClipOval(
                                // Ensures the image is clipped to a circular shape
                                child: Image.network(
                                  image,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                  // Adjust image fit as needed
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    if (error.toString().contains('404') ||
                                        error.toString().contains('HTTP request failed')) {
                                      return Image.asset(
                                        CustomIcons.iconProfilePicture, // Use the custom icon for the profile
                                        height: 90,
                                        width: 90,
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.error, // Show a generic error icon for other errors
                                        color: Colors.red,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ringkasan",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          const QuotaCard(),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Informasi Perangkat",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black54),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'See All',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              DeviceInfoCard(
                                color: Colors.lightBlue.shade100,
                                image: CustomIcons.iconWhatsAppGeneric,
                                title: 'Total Perangkat',
                                count: totalPerangkat ?? 0,
                                deviceTypeIcon: Icons.phone_iphone,
                              ),
                              const SizedBox(height: 16),
                              DeviceInfoCard(
                                color: Colors.lightGreen.shade100,
                                image: CustomIcons.iconWhatsAppGeneric,
                                title: 'Perangkat Aktif',
                                count: perangkatAktif ?? 0,
                                deviceTypeIcon: Icons.phone_iphone,
                              ),
                              const SizedBox(height: 16),
                              DeviceInfoCard(
                                color: Colors.amber.shade100,
                                image: CustomIcons.iconWhatsAppGeneric,
                                title: 'Perangkat Non Aktif',
                                count: perangkatNonAktif ?? 0,
                                deviceTypeIcon: Icons.phone_iphone,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Perangkat Terhubung",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black54),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  '+ Tumbah',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: perangkatTerhubung?.length,
                            itemBuilder: (context, index) {
                              final device = perangkatTerhubung?[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: PerangkatTerhubungCard(
                                  color: Colors.lightBlue.shade100,
                                  image: CustomIcons.iconWhatsAppGeneric2,
                                  name: device['id'] ?? 'Unknown',
                                  number: device['whatsapp_number'] ?? 'N/A',
                                  status: device['status'] ?? 'Active',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ); // Display the data
        } else {
          return Text("No data available");
        }
      },
    );
  }
}
//
//   void _confirmLogout(BuildContext context, Auth auth) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return PopScope(
//           canPop: false, // Disable the back button
//           child: AlertDialog(
//             title: const Text("Session expired"),
//             content: const Text("Please log in again."),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text("Okay"),
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                   auth.logout(); // Call the logout method
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
