import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_application_1/screens/movements/map/menu_pages/widgets/chat_message_tile.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import '../../widgets/app_bar_2.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key, required this.onSendMessage});
  final void Function(String message) onSendMessage;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final _inputCnt = TextEditingController();
  final _scrollController = ScrollController();

  // Dummy data to replace backend data
  final String currentUserID = "currentUser123";
  final List<ChatMessage> chatMessages = [];

  void _onSend(String message) {
    if (message.isEmpty) return;

    setState(() {
      chatMessages.add(
        ChatMessage(
          user: User(
            id: currentUserID,
            imgUrl: "https://via.placeholder.com/150",
            username: "CurrentUser",
            joinedAt: DateTime.now(),
          ),
          message: message,
          sentAt: DateTime.now(),
          seen: false,
        ),
      );
    });

    widget.onSendMessage(message);
    _inputCnt.clear();
    _scrollDown();
  }

  void _scrollDown() {
    if (chatMessages.isEmpty || !_scrollController.hasClients) {
      return;
    }

    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: primary,
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            flexibleSpace: Hero(
              tag: "appbar-hero-custom-1",
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const AnotherCustomAppBar(
                  title: "Messages",
                ),
              ),
            ),
            toolbarHeight: 100.h,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: chatMessages.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.r),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Be the first to talk to movement members.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13.sp),
                              ),
                              TextButton(
                                onPressed: () => _onSend("Hi folks!"),
                                child: const Text("Say Hi 👋"),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: chatMessages.length,
                        itemBuilder: ((context, index) {
                          //final message = chatMessages.reversed.toList()[index];
                          // return ChatMessageTile(
                          //   message: message,
                          //   isSender: message.user.id == currentUserID,
                          // );
                        }),
                      ),
              ),
              SafeArea(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: lightPrimary.withOpacity(0.3),
                        child: Icon(
                          Icons.mic,
                          size: 22.sp,
                          color: primary,
                        ),
                      ),
                      addHorizontalSpace(10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: lightPrimary.withOpacity(0.3),
                          ),
                          child: TextField(
                            controller: _inputCnt,
                            cursorColor: lightPrimary,
                            decoration: InputDecoration(
                              isDense: true,
                              hintStyle: const TextStyle(color: primary),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 10.h,
                              ),
                              hintText: "Send a message",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      addHorizontalSpace(10),
                      InkWell(
                        borderRadius: BorderRadius.circular(20.r),
                        onTap: () => _onSend(_inputCnt.text),
                        child: Ink(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: lightPrimary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                " Send",
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              addHorizontalSpace(7),
                              Icon(
                                Icons.send,
                                size: 20.sp,
                                color: primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final User user;
  final String message;
  final DateTime sentAt;
  final bool seen;

  ChatMessage({
    required this.user,
    required this.message,
    required this.sentAt,
    required this.seen,
  });
}

class User {
  final String id;
  final String username;
  final String imgUrl;
  final DateTime joinedAt;

  User({
    required this.id,
    required this.username,
    required this.imgUrl,
    required this.joinedAt,
  });
}
