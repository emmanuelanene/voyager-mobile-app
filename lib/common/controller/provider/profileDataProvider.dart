import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../../../constant/constants.dart';
import '../../model/profileDataModel.dart';
import '../services/profileDataCRUDServices.dart';

class ProfileDataProvider extends ChangeNotifier {
  ProfileDataModel? profileData;

  getProfileData() async {
    profileData = await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
        auth.currentUser!.phoneNumber!
    );

    log(profileData!.toMap().toString());

    notifyListeners();
  }
}
