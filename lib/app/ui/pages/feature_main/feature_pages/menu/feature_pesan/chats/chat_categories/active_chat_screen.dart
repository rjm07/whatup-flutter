import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:provider/provider.dart';
import '../../../../../../../../core/models/pesan/pesan.dart';
import '../../../../../../../../core/services/pesan/pesan.dart';
import '../../../../../../../../core/services/preferences.dart';
import '../../../../../../../../core/services/socket_io/socket.dart';
import '../../../../../../../../utils/snackbar/snackbar.dart';
import '../../../../../../../shared/widgets/custom_list_tiles.dart';
import '../chat_screen.dart';

class ActiveChatScreen extends StatefulWidget {
  const ActiveChatScreen({
    super.key,
  });

  @override
  State<ActiveChatScreen> createState() => _ActiveChatScreenState();
}

class _ActiveChatScreenState extends State<ActiveChatScreen> {
  final logger = Logger();
  late socket_io.Socket? socket;
  final SocketService socketService = SocketService();
  late String pKey = 'pKey';
  List<ChatBoxDataList> userChatBox = [];

  @override
  void initState() {
    super.initState();

    // socket = socketService.initializeSocket();
    // socket?.onConnect((_) {
    //   listenToIncomingMessages();
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getChatBoxList();
    });
  }

  Future<void> getChatBoxList() async {
    final PesanServices devices = Provider.of<PesanServices>(context, listen: false);
    final String? tokenBearer = await LocalPrefs.getBearerToken();
    final String? deviceKey = await LocalPrefs.getDeviceKey();
    debugPrint("tokenBearer: $tokenBearer");
    debugPrint("deviceKey: $deviceKey");
    pKey = deviceKey ?? '';

    if (tokenBearer != null) {
      try {
        // Update the chat box list
        await devices.updateChatBoxListFuture(
          'active',
          tokenBearer,
          deviceKey ?? '',
          showErrorSnackbar: (String errorMessage) {
            // Ensure the widget is still active
            SnackbarUtil.showErrorSnackbar(context, errorMessage);
          },
        );

        // Assign the fetched data to userChatBox

        setState(() {
          userChatBox = devices.chatBoxDataDetails;
        });
      } catch (e) {
        debugPrint("Error in getChatBoxList: $e");
      }
    }
  }

  // void listenToIncomingMessages() async {
  //   final String? deviceKey = await LocalPrefs.getDeviceKey();
  //   final String? fkUserID = await LocalPrefs.getFKUserID();
  //
  //   if (deviceKey == null || fkUserID == null) {
  //     throw Exception("DeviceKey or FKUserID is null");
  //   }
  //
  //   if (socket == null) {
  //     throw Exception("Socket is not initialized");
  //   }
  //
  //   socket!.onConnect((_) {
  //     debugPrint('Connection Established');
  //     final channel = "popup:${fkUserID}_$deviceKey";
  //     socket!.on(channel, (msg) {
  //       logger.i("Socket: Listening on $channel");
  //       debugPrint(channel);
  //       handleIncomingMessage(msg);
  //     });
  //   });
  // }

  // void handleIncomingMessage(dynamic data) {
  //   // Parse the incoming data
  //   final Map<String, dynamic> response = Map<String, dynamic>.from(data);
  //
  //   final String senderName = response['sender_name'] ?? '';
  //   final String messageText = response['message']['text'] ?? '';
  //   final String timestamp = response['messageTimestamp_str'] ?? '';
  //
  //   debugPrint('Message from $senderName: $messageText at $timestamp');
  //   // getChatBoxList();
  // }

  @override
  Widget build(BuildContext context) {
    final PesanServices devices = Provider.of<PesanServices>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 24.0),
        child: Column(
          children: [
            Expanded(
              child: devices.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : userChatBox.isEmpty
                      ? Center(
                          child: Text(
                            "No current messages",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: userChatBox.length,
                          itemBuilder: (context, index) {
                            final chatData = userChatBox[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: ChatUserListTile(
                                title: chatData.messages.senderName,
                                fullName: chatData.messages.senderName.isEmpty
                                    ? chatData.messages.senderNumber
                                    : chatData.messages.senderName,
                                description: chatData.messages.message.text ?? '',
                                time: chatData.messages.messageTimestampStr,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        roomChat: chatData.roomChat,
                                        senderNumber: chatData.messages.senderNumber,
                                        fullName: chatData.messages.senderName,
                                        timestamp: chatData.messages.messageTimestampStr,
                                        statusIsOpen: false,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}