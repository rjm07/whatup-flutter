import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasender/app/core/services/perangkat_saya/perangkat_saya.dart';
import 'package:wasender/app/ui/pages/feature_main/feature_pages/menu/feature_perangkat_saya/perangkat_saya_detail_screen.dart';
import 'package:wasender/app/ui/shared/widgets/perangkat_saya_cards.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../../core/models/perangkat_saya/device_list.dart';
import '../../../../../../core/services/navigation/navigation.dart';
import '../../../../../../core/services/preferences.dart';
import '../../../../../../utils/lang/colors.dart';
import '../../../../../../utils/lang/images.dart';
import '../../../../../../utils/snackbar/snackbar.dart';

class PerangkatSayaScreen extends StatefulWidget {
  const PerangkatSayaScreen({super.key});

  @override
  State<PerangkatSayaScreen> createState() => _PerangkatSayaScreenState();
}

class _PerangkatSayaScreenState extends State<PerangkatSayaScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController _scrollController;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDeviceList();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  Future<void> getDeviceList() async {
    final PerangkatSayaServices devices = Provider.of<PerangkatSayaServices>(context, listen: false);
    final String? tokenBearer = await LocalPrefs.getBearerToken();
    debugPrint("tokenBearer: $tokenBearer");
    if (tokenBearer != null) {
      devices.updateAllDeviceListFuture(
        tokenBearer,
        showErrorSnackbar: (String errorMessage) {
          SnackbarUtil.showErrorSnackbar(context, errorMessage);
        },
      );
    }
  }

  Future<void> loadMoreData() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      final PerangkatSayaServices devices = Provider.of<PerangkatSayaServices>(context, listen: false);

      if (devices.perangkatSayaDataList.isNotEmpty) {
        final previousPage = devices.page;
        devices.incrementPage();

        final String? tokenBearer = await LocalPrefs.getBearerToken();
        if (tokenBearer != null) {
          devices.updateAllDeviceListFuture(
            tokenBearer,
            isPagination: true,
            showErrorSnackbar: (String errorMessage) {
              SnackbarUtil.showErrorSnackbar(context, errorMessage);
            },
          ).then((_) {
            if (devices.perangkatSayaDataList.isEmpty ||
                devices.perangkatSayaDataList.length <= previousPage * devices.perPage) {
              devices.page = previousPage; // Revert the page increment if no new data
              _showNoMoreDataAlert();
            }
            setState(() {
              isLoadingMore = false;
            });
          });
        }
      }
    }
  }

  void _showNoMoreDataAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No more data"),
          content: const Text("There are no more devices to load."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Perangkat Saya',
                    style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w400)),
                Text('Daftar informasi perangkat yang terdaftar',
                    style: TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w400)),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.notifications, color: AppColors.primary),
              onPressed: () {},
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                CustomIcons.iconAddDevice,
                height: 20,
                width: 20,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            NavService.jumpToPageID('/main');
          },
        ),
        backgroundColor: AppColors.navBarColor,
        centerTitle: false,
        elevation: 1,
      ),
      body: SafeArea(
        child: Consumer<PerangkatSayaServices>(
          builder: (context, devices, child) {
            if (devices.isLoading && devices.perangkatSayaDataList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (devices.perangkatSayaDataList.isEmpty) {
              return const Center(
                  child: Text("No devices connected at the moment",
                      style: TextStyle(fontSize: 14, color: Colors.black38)));
            } else {
              return ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
                children: [
                  ...devices.perangkatSayaTerhubungDataDetails.map((Device device) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Slidable(
                        endActionPane: ActionPane(
                          extentRatio: 0.3,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              spacing: 2,
                              onPressed: (context) => {},
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PerangkatSayaDetailScreen(
                                  whatsappNumber: device.whatsappNumber,
                                ),
                              ),
                            );
                          },
                          child: PerangkatSayaCard(
                            color: Colors.white,
                            title: 'title',
                            role: "Technical Support",
                            isActive: device.isActive,
                            category: device.inboxType,
                            deviceID: device.id,
                            dueDate: DateTime.now().toString(),
                            devicePkey: device.pkey,
                            devicePhoneNumber: device.whatsappNumber,
                            isInbox: false,
                          ),
                        ),
                      ),
                    );
                  }),
                  if (isLoadingMore) const Center(child: CircularProgressIndicator()),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
