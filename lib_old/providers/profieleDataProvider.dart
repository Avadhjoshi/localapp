import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localapp/APIs/logInAPi.dart';
import 'package:localapp/CategoryScreen.dart';
import 'package:localapp/component/logiin%20dailog.dart';
import 'package:localapp/component/show%20coustomMesage.dart';
import 'package:localapp/models/userModel.dart';
import 'package:localapp/providers/phoneNumberPerovider.dart';
import 'package:logger/logger.dart';
import 'package:platform_device_id/platform_device_id.dart';

final profileProvider =
    StateNotifierProvider<ProfileProviderState, User?>((ref) {
  return ProfileProviderState(null, ref: ref);
});

class ProfileProviderState extends StateNotifier<User?> {
  Ref ref;
  ProfileProviderState(super.state, {required this.ref});
  final logInApi = LogApis();
  final _log = Logger();
  bool _loading = true;
  bool _sunmitted = false;

  bool get submitted => _sunmitted;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();

  Future<void> getUser(BuildContext context) async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    var resp = await logInApi.getUser(deviceId ?? "");

    Logger().w(jsonDecode(resp.body));

    if (resp.statusCode == 200) {
      var decode = jsonDecode(resp.body);
      GetUserApiResponce data = GetUserApiResponce.fromJson(decode);
      _loading = false;
      state = data.data;

      if (state == null ||
          state?.name == null ||
          state?.name==""||
          state?.mobileNumber1==""||
          state?.mobileNumber1 == null) {
        _log.e("Waiting");
       // await openLogInDialog(context);
        await   showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomDialog(),
        );
         updateLocation(context);
      }
    } else {
      state = null;
      Logger().e("${resp.statusCode}\n${resp.body}");
    }
  }

  Future<void> updateLocation(BuildContext context) async {
    Position location = await Geolocator.getCurrentPosition();
    String? PN = ref.read(phoneNumberProvider);
    if (PN == null || PN.isEmpty) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
        await ref.read(phoneNumberProvider.notifier).getSimNumber(context);
        PN = ref.read(phoneNumberProvider);
      });
    }

    if (kDebugMode) {
      showMessage(context, "${ref.read(phoneNumberProvider)}");
    }
    var st = await logInApi.updateMobNumberAndLocation(
        postById: state?.deviceId ?? "", location: location, mobileNumber2: PN);
    if (st.statusCode == 200) {
      Logger().i("Location Upad Update\n($PN) \n${st.body}");
      getUser(context);
    } else {
      showMessage(context, "Somthing went wrong");
    }
  }

  Future<void> updateProfile({
    required BuildContext context,
  }) async {
    _log.e(
        "Update ${phoneNumController.text.trim().length} ${nameController.text} jhghjg");

    if (phoneNumController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty) {
      showMessage(context, "Please Enter Your Name And Mobile Number");
      return;
    } else if (phoneNumController.text.length != 10) {
      _log.e("Please Enter Valid Mobile Number");
      showMessage(context, "Please Enter Valid Mobile Number");
      return;
    }

    String? deviceId = await PlatformDeviceId.getDeviceId;
    var resp = await logInApi.updateProfile(
        name: nameController.text.trim(),
        mobileNumber1: phoneNumController.text.trim(),
        postById: deviceId);
    if (resp.statusCode == 200) {
      // var fd = state;

      _sunmitted = true;
      state = null;
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
        phoneNumController.clear();
        nameController.clear();

        _sunmitted = false;
        // state = fd;
      });

      getUser(context);
    } else {
      showMessage(context, "${resp.statusCode}");
    }
  }

  update() {
    var d = state;
    state = null;
    state = d;
  }
}
