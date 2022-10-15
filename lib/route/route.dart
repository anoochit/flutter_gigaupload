import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:gigaupload/middleware/route_guard.dart';
import 'package:gigaupload/pages/add/add.dart';
import 'package:gigaupload/pages/file/view_file.dart';
import 'package:gigaupload/pages/home/home.dart';
import 'package:gigaupload/pages/signin/signin.dart';

final route = [
  GetPage(
    name: "/",
    page: () => const HomePage(),
    middlewares: [
      RouteGuard(),
    ],
    preventDuplicates: true,
  ),
  GetPage(
    name: "/file/:fileId",
    page: () => ViewFilePage(),
    middlewares: [
      RouteGuard(),
    ],
    preventDuplicates: true,
  ),
  GetPage(
    name: "/add",
    page: () => const AddFilePage(),
    middlewares: [
      RouteGuard(),
    ],
    preventDuplicates: true,
    fullscreenDialog: true,
  ),
  GetPage(
    name: "/signin",
    page: () => const SignInPage(),
    preventDuplicates: true,
  ),
];
