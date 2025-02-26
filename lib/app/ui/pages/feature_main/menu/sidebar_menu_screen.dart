import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasender/app/core/models/perangkat_saya/perangkat_saya.dart';
import 'package:wasender/app/core/services/preferences.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/menu/feature_inbox/inbox_screen.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/pengaturan/feature_paket/paket_screen.dart';
import '../../../../core/services/auth.dart';
import '../../../../core/services/navigation/navigation.dart';
import '../../../../core/services/perangkat_saya/perangkat_saya.dart';
import '../../../../utils/lang/images.dart';
import '../../../shared/widgets/custom_list_tiles.dart';
import '../feature_pages/menu/feature_perangkat_saya/perangkat_saya_screen.dart';
import '../feature_pages/menu/feature_profile/profile_screen.dart';
import '../feature_pages/menu/feature_inbox/chat/chat_home_screen.dart';
import '../feature_pages/pengaturan/feature_bantuan/bantuan_screen.dart';

class SideBarMenuScreen extends StatefulWidget {
  final PageController pageController;

  const SideBarMenuScreen({
    super.key,
    required this.pageController,
  }); // Accept controller

  @override
  State<SideBarMenuScreen> createState() => _SideBarMenuScreenState();
}

class _SideBarMenuScreenState extends State<SideBarMenuScreen> {
  String userRole = ''; // Declare the userRole variable
  String bearerToken = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScaffoldMessengerState? scaffoldMessenger;
  List<PerangkatSayaDataList> perangkatDevices = [];

  @override
  void initState() {
    super.initState();
    getDeviceList();
    _getCredentialsFromPrefs(); // Fetch the role from SharedPreferences
    _checkDevices(); // Check if there are any devices available
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
      setState(() {
        perangkatDevices = devices.perangkatSayaDataList;
      });

      debugPrint("Device list updated: $perangkatDevices items");
    }
  }

  // Fetch userRole from LocalPrefs (SharedPreferences)
  Future<void> _getCredentialsFromPrefs() async {
    final prefs = await LocalPrefs.getUserRole();
    final token = await LocalPrefs.getBearerToken();

    setState(() {
      userRole = prefs!;
      bearerToken = token!;
      debugPrint("User Role: $userRole");
      debugPrint("Bearer Token: $bearerToken");
    });
  }

  void _checkDevices() async {}

  void _onTileTap(int index) {
    NavService.pop();
    NavService.jumpToPage(0);
    widget.pageController.jumpToPage(index);
    _scaffoldKey.currentState?.closeDrawer();
    // Close the drawer after selecting a tile
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);

    return Drawer(
      key: _scaffoldKey,
      child: Container(
        color: Colors.grey.shade300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Image.asset(
                CustomImages.imageWaSenderLogo,
                height: 180,
                width: MediaQuery.of(context).size.width / 2.25,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "MENU",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Visibility(
                    visible: userRole.toUpperCase() == 'ADMIN' || userRole.toUpperCase() == 'OWNER',
                    child: Column(
                      children: [
                        SMListTiles(
                          image: CustomIcons.iconMainDashboard,
                          title: 'Dashboard',
                          onTap: () => _onTileTap(0),
                        ),
                        SMListTiles(
                          image: CustomIcons.iconPerangkatSaya,
                          title: 'Perangkat Saya',
                          onTap: () //=> _onTileTap(1),
                              {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PerangkatSayaScreen(),
                              ),
                            );
                          },
                        ),
                        SMListTiles(
                          image: CustomIcons.iconInbox,
                          title: 'Inbox',
                          onTap: () {
                            if (perangkatDevices.isNotEmpty) {
                              if (perangkatDevices.length == 1) {
                                String singlePKey = perangkatDevices.first.pKey;
                                debugPrint("Single device detected: $singlePKey");

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatHomeScreen(
                                      pKey: singlePKey,
                                      ifFromInbox: false,
                                    ),
                                  ),
                                );
                              } else {
                                debugPrint("Multiple devices detected: ${perangkatDevices.length}");

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => InboxScreen(),
                                  ),
                                );
                              }
                            } else {
                              debugPrint("No devices found.");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("No devices available")),
                              );
                            }
                          },
                        ),
                        SMListTiles(
                          image: CustomIcons.iconPesan,
                          title: 'Pesan',
                          onTap: () => _onTileTap(3),
                        ),
                        SMListTiles(
                          image: CustomIcons.iconMainDashboard,
                          title: 'Kontak',
                          onTap: () => _onTileTap(4),
                        ),
                        SMListTiles(
                          image: CustomIcons.iconPerangkatSaya,
                          title: 'Pengguna',
                          onTap: () => _onTileTap(5),
                        ),
                        SMListTiles(
                          image: CustomIcons.iconInbox,
                          title: 'Tim Agen',
                          onTap: () => _onTileTap(6),
                        ),
                        SMListTiles(
                          image: CustomIcons.iconPesan,
                          title: 'Pembayaran',
                          onTap: () => _onTileTap(7),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: userRole.toUpperCase() == 'AGENT',
                    child: Column(
                      children: [
                        SMListTiles(
                          image: CustomIcons.iconMainDashboard,
                          title: 'Dashboard',
                          onTap: () => _onTileTap(0),
                        ),
                        SMListTiles(
                          image: CustomIcons.iconViewProfile,
                          title: 'Profile',
                          onTap: () {
                            NavService.push(screen: ProfileScreen());
                          },
                        ),
                        SMListTiles(
                          image: CustomIcons.iconInbox,
                          title: 'Inbox',
                          onTap: () //=> _onTileTap(2),
                              {
                            if (perangkatDevices.isNotEmpty) {
                              if (perangkatDevices.length == 1) {
                                String singlePKey = perangkatDevices.first.pKey;
                                LocalPrefs.saveSelectedPKey(singlePKey);
                                debugPrint("Single device detected: $singlePKey");

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatHomeScreen(
                                      pKey: singlePKey,
                                      ifFromInbox: false,
                                    ),
                                  ),
                                );
                              } else {
                                debugPrint("Multiple devices detected: ${perangkatDevices.length}");

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => InboxScreen(),
                                  ),
                                );
                              }
                            } else {
                              debugPrint("No devices found.");
                              debugPrint("Devices: $perangkatDevices");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("No devices available")),
                              );
                            }
                          },
                        ),
                        SMListTiles(
                          image: CustomIcons.iconPesan,
                          title: 'Pesan',
                          onTap: () => _onTileTap(3),
                        ),
                        SMListTiles(
                          image: CustomIcons.iconKontak,
                          title: 'Kontak',
                          onTap: () => _onTileTap(4),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "PENGATURAN",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: userRole.toUpperCase() == 'ADMIN' || userRole.toUpperCase() == 'OWNER',
                        child: SMListTiles(
                          image: CustomIcons.iconProfile,
                          title: 'Paket',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PaketScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SMListTiles(
                        image: CustomIcons.iconBantuan,
                        title: 'Bantuan',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const BantuanScreen(),
                            ),
                          );
                        },
                      ),
                      SMListTiles(
                          image: CustomIcons.iconKeluar, title: 'Keluar', onTap: () => _confirmLogout(context, auth)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, Auth auth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () async {
                if (kDebugMode) {
                  print('logout pressed');
                }
                Navigator.of(context).pop();
                await auth.logout();
              },
            ),
          ],
        );
      },
    );
  }
}
