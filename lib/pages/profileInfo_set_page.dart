import 'dart:developer';
import 'dart:io';

import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_finder/providers/login_provider.dart';
import 'package:provider/provider.dart';

import '../custom_widget/appbar_with_title.dart';
import '../utilities/app_colors.dart';
import '../utilities/diaglog.dart';
import '../utilities/testStyle.dart';

class ProfileInformationSetPage extends StatelessWidget {
  const ProfileInformationSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final infoKey = GlobalKey<FormState>();
    final phoneController = PhoneNumberInputController(context);
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) => WillPopScope(
        onWillPop: () => _onWillPop(context, loginProvider, phoneController),
        child: Scaffold(
          appBar: appBarWithTitle(
              context: context, title: "Fill Your Profile Information"),
          body: Form(
            key: infoKey,
            child: ListView(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      child: loginProvider.pickImagePath == null
                          ? Icon(
                              CupertinoIcons.person_fill,
                              color: Colors.grey.shade400.withOpacity(.5),
                              size: 85,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.file(
                                File(loginProvider.pickImagePath!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Positioned(
                      left: Get.width / 2 + 30,
                      bottom: 10,
                      child: InkWell(
                        onTap: () {
                          loginProvider.pickImage();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                inputField(
                  controller: loginProvider.fullNameController,
                  hintText: "Full Name",
                  isPrefix: false,
                ),
                inputField(
                  controller: loginProvider.nickNameController,
                  hintText: "Nick Name",
                  isPrefix: false,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: PhoneNumberInput(
                    controller: phoneController,
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
                    loginProvider.getDatePicker(context);
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
                          loginProvider.dob ?? "Date Of Birth",
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Gender Selection',
                        border: OutlineInputBorder()),
                    alignment: Alignment.center,
                    value: loginProvider.selectGender,
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      loginProvider.selectGender = value!;
                    },
                    items: loginProvider.genderList
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: loginProvider.buttonDeactive
                        ? null
                        : () {
                            if (infoKey.currentState!.validate()) {
                              if (loginProvider.dob == null) {
                                showErrorToastMessage("Enter Date Of Birth");
                                return;
                              }
                              if (loginProvider.pickImagePath == null) {
                                showErrorToastMessage("Select Image");
                                return;
                              }
                              loginProvider.buttonDeactive = true;
                              loginProvider.registrationUser(loginProvider);
                            }
                            phoneController.phoneNumber = '';
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 18),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Continue',
                      style: whiteBoldText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onWillPop(BuildContext context, LoginProvider loginProvider,
      PhoneNumberInputController phoneController) {
    log("message");
    loginProvider.fullNameController.text = '';
    loginProvider.nickNameController.text = '';
    loginProvider.pickImagePath = null;
    loginProvider.dob = null;
    Get.back();
  }
}
