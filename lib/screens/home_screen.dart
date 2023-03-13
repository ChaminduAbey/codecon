import 'package:client_app/main.dart';
import 'package:client_app/models/project.dart';
import 'package:client_app/screens/splash_screen.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/services/user_service.dart';
import 'package:client_app/theme.dart';
import 'package:client_app/view_state_mixin.dart';
import 'package:client_app/views/busy_error_child_view.dart';
import 'package:client_app/views/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/projects_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ViewStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final projects = await getIt<ProjectService>().getProjectsNearBy();

      getIt<ProjectService>().setProjects(projects);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
        builder: (context, UserService userService, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryBGColor,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: primaryColor),
          title: Text(
            "Home",
            style: primaryTitleTxtStyle,
          ),
          centerTitle: true,
          actions: [
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: 8.0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: ImageWidget(
                  imageUrl: userService.user.photo!.url,
                  blurhash: userService.user.photo!.blurhash),
            )
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Logout"),
                onTap: () async {
                  await getIt<AuthService>().logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: const BoxDecoration(
                  color: primaryBGColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                        tag: "primary-logo",
                        child: Image.asset("assets/graphics/logo.png")),
                  ],
                ),
              ),
              BusyErrorChildView(
                  viewState: viewState, builder: () => Text("hi there"))
            ],
          ),
        ),
      );
    });
  }
}
