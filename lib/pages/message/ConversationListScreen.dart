import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_finder/model/message_model.dart';
import 'package:parking_finder/services/Auth_service.dart';

import '../../database/dbhelper.dart';
import '../../model/user_model.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/helper_function.dart';
import 'Conversation.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({Key? key}) : super(key: key);

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  // getMe

  // List<String> friendMesUerIds = [];
  List<MessageModel> messages = [];
  var seen = <String>{};
  getMessage() {
    DbHelper.getUserMessages(AuthService.currentUser!.uid).listen((event) {
      messages = List.generate(event.docs.length, (index) {
        return MessageModel.fromMap(event.docs[index].data()!);
      });

      for (MessageModel message in messages) {
        seen.add(message.revivedId);
        seen.add(message.senderId);
      }
      seen.remove(AuthService.currentUser!.uid);
      setState(() {});
    });
  }

  @override
  void initState() {
    getMessage();
    super.initState();
  }

  @override
  build(BuildContext context) {
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
          "Conversation",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: SearchBar(
                  elevation: const MaterialStatePropertyAll(0),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(color: Colors.grey.shade200))),
                  hintText: "Search Garage Owner or Admin",
                  hintStyle: MaterialStatePropertyAll(GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  )),
                ))
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemCount: seen.toList().length,
              itemBuilder: (context, index) {
                String id = seen.toList()[index];
                return FutureBuilder(
                    future: DbHelper.getUserInfoMap(id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error = ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CupertinoActivityIndicator(
                          radius: 30,
                          color: AppColors.primaryColor,
                        );
                      }
                      final user = UserModel.fromMap(snapshot.data!.data()!);
                      return Card(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          onTap: () {
                            Get.to(ConversationPage(userModel: user),
                                transition: Transition.downToUp);
                          },
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: AppColors.primaryColor, width: .5),
                              borderRadius: BorderRadius.circular(6)),
                          leading: CachedNetworkImage(
                            width: 60,
                            fit: BoxFit.cover,
                            imageUrl: "${user.profileUrl}",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    SpinKitSpinningLines(
                              color: AppColors.primaryColor,
                              size: 50.0,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          title: Text(user.name ?? ""),
                          subtitle: Text(user.phoneNumber ?? user.email ?? ''),
                          trailing: Text(getMessageTimeFormat(
                              DateTime.fromMillisecondsSinceEpoch(num.parse(
                                      messages
                                          .firstWhereOrNull((element) =>
                                              element.revivedId == user.uid)!
                                          .mId)
                                  .toInt()))),
                        ),
                      );
                    });
              },
            )),
          ],
        ),
      ),
    );
  }
}
