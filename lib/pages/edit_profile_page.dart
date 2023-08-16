import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_finder/custom_widget/appbar_with_title.dart';
import 'package:parking_finder/model/user_model.dart';
import 'package:parking_finder/providers/user_provider.dart';
import 'package:parking_finder/utilities/helper_function.dart';
import 'package:parking_finder/utilities/testStyle.dart';
import 'package:provider/provider.dart';

import '../api/authenticate_service.dart';
import '../utilities/app_colors.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("EditProfilePage");
    EasyLoading.dismiss();
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: appBarWithTitle(
            context: context,
            title: "Edit Profile",
          ),
          body: Form(
            key: userProvider.profileEditFormKey,
            child: Center(
              child: ListView(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: userProvider.pickImagePath == null
                                  ? CachedNetworkImage(
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          "${userProvider.userModel!.userinfo![0].profileImage}",
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              SpinKitSpinningLines(
                                        color: AppColors.primaryColor,
                                        size: 50.0,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        userProvider.cropImage(
                                            userProvider.pickImagePath, true);
                                      },
                                      child: Image.file(
                                        File(userProvider.pickImagePath!),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          RichText(
                            text: TextSpan(
                              text: 'Joined ',
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: getJoinTimeFormattedDate(
                                      userProvider.userModel!.createdAt!),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 40,
                        right: 0,
                        left: 100,
                        child: CircleAvatar(
                          radius: 18,
                          child: IconButton(
                            splashColor: AppColors.primaryColor,
                            onPressed: () {
                              userProvider.pickImage(isSaveProfile: true);
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: userProvider.fullNameController,
                          autofocus: false,
                          focusNode: userProvider.fullNameFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: const TextStyle(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 14),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,

                            //
                          ),
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Input Valid Name Minimum Six(6) digit';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: userProvider.emailController,
                          autofocus: false,
                          focusNode: userProvider.emailNameFocusNode,
                          enabled: userProvider.userModel!.email!.isNotEmpty
                              ? false
                              : true,
                          //  focusNode: loginProvider.passFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: const TextStyle(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 14),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            //
                          ),
                          validator: (value) {
                            if (value!.length < 6 || !value.contains("@")) {
                              return 'Input Valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PhoneNumberInput(
                          controller: userProvider.phoneController,
                          errorText: "Enter Phone Number",
                          initialCountry: 'BD',
                          locale: 'en',
                          pickContactIcon: const Icon(Icons.phone),
                          countryListMode: CountryListMode.dialog,
                          contactsPickerPosition: ContactsPickerPosition.suffix,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hint: "Phone Number",
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          userProvider.emailNameFocusNode.unfocus();
                          userProvider.fullNameFocusNode.unfocus();
                          userProvider.addressFocusNode.unfocus();
                          userProvider.nidFocusNode.unfocus();
                          userProvider.getDatePicker(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 60,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userProvider.dob ?? "Date Of Birth",
                                style: grayTextStyle,
                              ),
                              const Icon(
                                Icons.date_range,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: DropdownButtonFormField<String>(
                          onTap: () {
                            userProvider.emailNameFocusNode.unfocus();
                            userProvider.fullNameFocusNode.unfocus();
                            userProvider.addressFocusNode.unfocus();
                            userProvider.nidFocusNode.unfocus();
                          },
                          decoration: const InputDecoration(
                              labelText: 'Gender Selection',
                              border: OutlineInputBorder()),
                          alignment: Alignment.center,
                          value: userProvider.selectGender,
                          icon: const Icon(Icons.arrow_drop_down_sharp),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          onChanged: (String? value) {
                            userProvider.selectGender = value!;
                          },
                          items: userProvider.genderList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: continueBlackTextStyle,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: userProvider.addressController,
                          autofocus: false,
                          focusNode: userProvider.addressFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Address/Location',
                            labelStyle: const TextStyle(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 14),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            //
                          ),
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Input Valid Address Minimum Six(6) digit';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: userProvider.nidController,
                          autofocus: false,
                          focusNode: userProvider.nidFocusNode,
                          decoration: InputDecoration(
                            labelText: 'NID Number',
                            labelStyle: const TextStyle(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 14),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            //
                          ),
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Input Valid nid Minimum Six(6) digit';
                            }
                            return null;
                          },
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        elevation: 5,
                        shadowColor: AppColors.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  border: Border.all(
                                    color:
                                        userProvider.userLicenceImgUrl == null
                                            ? Colors.red
                                            : Colors.green,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Select A Original Image Of NID/Driving Licence",
                                  style: TextStyle(
                                    color:
                                        userProvider.userLicenceImgUrl == null
                                            ? Colors.red
                                            : Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Card(
                                child: userProvider.userLicenceImgUrl == null
                                    ? const Icon(
                                        Icons.photo,
                                        size: 100,
                                      )
                                    : InkWell(
                                        onTap: () {
                                          userProvider.cropImage(
                                              userProvider.userLicenceImgUrl,
                                              false);
                                        },
                                        child: Image.file(
                                          File(userProvider.userLicenceImgUrl!),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      userProvider.pickImage(
                                          isSaveProfile: false,
                                          imageSource: ImageSource.camera);
                                    },
                                    icon: const Icon(Icons.camera),
                                    label: const Text('Open Camera'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      userProvider.pickImage(
                                          isSaveProfile: false,
                                          imageSource: ImageSource.gallery);
                                    },
                                    icon: const Icon(Icons.photo_album),
                                    label: const Text('Open Gallery'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  )
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CupertinoButton.filled(
                onPressed: () {
                  userProvider.emailNameFocusNode.unfocus();
                  userProvider.fullNameFocusNode.unfocus();
                  userProvider.addressFocusNode.unfocus();
                  userProvider.nidFocusNode.unfocus();
                  if (userProvider.profileEditFormKey.currentState!
                      .validate()) {
                    var userInfo = Userinfo(
                      username: userProvider.fullNameController.text,
                      contNo: userProvider.phoneController.phoneNumber,
                      dob: userProvider.dob ??
                          userProvider.userModel!.userinfo![0].dob,
                      gender: userProvider.selectGender ??
                          userProvider.userModel!.userinfo![0].gender,
                      profileImage: userProvider.pickImagePath ??
                          userProvider.userModel!.userinfo![0].profileImage,
                      licenceImage: userProvider.userLicenceImgUrl ??
                          userProvider.userModel!.userinfo![0].licenceImage,
                      nidImage: userProvider.nidController.text,
                    );
                    AuthenticateService.updateUser(
                      userInfo,
                      userProvider,
                      userProvider.userModel!.email!,
                    );
                  }
                },
                child: Text(
                  "Update",
                  style: whiteBoldText,
                )),
          ),
        );
      },
    );
  }
}
