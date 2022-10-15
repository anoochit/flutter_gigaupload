import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigaupload/const.dart';

class RouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return (auth.currentUser != null) ? null : const RouteSettings(name: "/signin");
  }
}
