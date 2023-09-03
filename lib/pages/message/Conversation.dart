import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:parking_finder/model/message_model.dart';
import 'package:parking_finder/model/user_model.dart';
import 'package:parking_finder/services/Auth_service.dart';

import '../../database/dbhelper.dart';
import '../../utilities/app_colors.dart';

class ConversationPage extends StatefulWidget {
  final UserModel userModel;

  const ConversationPage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    getMessage();
    _user = types.User(id: widget.userModel.uid!);
    super.initState();
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  List<types.Message> _messages = [];
  late types.User _user;

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  getMessage() {
    DbHelper.getUserMessages(widget.userModel.uid!).listen((event) {
      _messages = [];
      List.generate(event.docs.length, (index) {
        _messages.insert(
            index,
            types.TextMessage(
              author: types.User(
                  id: event.docs[index].data()['senderId'],
                  imageUrl: widget.userModel.profileUrl),
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: randomString(),
              text: event.docs[index].data()['message'],
            ));
      });
      setState(() {});
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
    MessageModel messageModel = MessageModel(
      mId: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: AuthService.currentUser!.uid,
      revivedId: widget.userModel.uid!,
      message: message.text,
      sentTime: Timestamp.now(),
    );
    await DbHelper.sentMessage(messageModel: messageModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.userModel.name!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
            )),
      ),
      body: Chat(
        inputOptions: InputOptions(
          autocorrect: true,
        ),
        typingIndicatorOptions: TypingIndicatorOptions(),
        imageGalleryOptions: ImageGalleryOptions(),
        theme: DefaultChatTheme(
            inputBackgroundColor: AppColors.primaryColor,
            primaryColor: AppColors.primaryColor),
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}
