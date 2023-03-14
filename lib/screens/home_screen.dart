import 'dart:developer';

import 'package:client_app/main.dart';
import 'package:client_app/models/project.dart';
import 'package:client_app/screens/splash_screen.dart';
import 'package:client_app/screens/view_project_screen.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/services/user_service.dart';
import 'package:client_app/theme.dart';
import 'package:client_app/utils/hero_unique_id.dart';
import 'package:client_app/view_state_mixin.dart';
import 'package:client_app/views/busy_error_child_view.dart';
import 'package:client_app/views/image_widget.dart';
import 'package:client_app/views/staggered_animation_child.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../services/projects_service.dart';
import '../views/project_card_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ViewStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        setBusy();

        final projects = await getIt<ProjectService>().getProjectsNearBy();

        getIt<ProjectService>().setProjects(projects);

        setIdle();
      } catch (e) {
        log("Error in HomeScreen Init", error: e);
        setError();
        rethrow;
      }
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
          child: SafeArea(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                        height: 120,
                        width: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: ImageWidget.fromCdn(userService.user.photo!)),
                    const SizedBox(height: 16.0),
                    Text(
                      "${userService.user.firstName} ${userService.user.lastName}",
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userService.user.email,
                      style: const TextStyle(
                        color: greyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ListTile(
                      title: Text("Logout",
                          style: primaryTitleTxtStyle.copyWith(fontSize: 16)),
                      trailing: const Icon(Icons.logout, color: primaryColor),
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
                  ),
                ),
              ],
            ),
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
                  viewState: viewState,
                  builder: () => Consumer<ProjectService>(
                        builder: (_, projectService, child) {
                          return AnimationLimiter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 24,
                                ),
                                StaggerAnimationChild(
                                  index: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      "Projects Near You",
                                      style: primaryTitleTxtStyle,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  height: 335,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: projectService.projects.length,
                                      itemBuilder: ((context, index) {
                                        final Project project =
                                            projectService.projects[index];
                                        final String heroTag =
                                            HeroUniqueId.get();
                                        return StaggerAnimationChild(
                                          index: 1 + index,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0),
                                            child: ProjectCardView(
                                              heroTag: heroTag,
                                              bgColor: primaryBGColor,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            ViewProjectScreen(
                                                              heroTag: heroTag,
                                                              isWhiteBackground:
                                                                  false,
                                                              projectId:
                                                                  project.id,
                                                              projectImage:
                                                                  project.photo,
                                                            )));
                                              },
                                              project: project,
                                            ),
                                          ),
                                        );
                                      })),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          );
                        },
                      ))
            ],
          ),
        ),
      );
    });
  }
}
