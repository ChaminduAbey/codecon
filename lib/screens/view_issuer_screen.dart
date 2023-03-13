import 'dart:developer';

import 'package:client_app/main.dart';
import 'package:client_app/models/cdn_image.dart';
import 'package:client_app/screens/view_project_screen.dart';
import 'package:client_app/services/projects_service.dart';
import 'package:client_app/theme.dart';
import 'package:client_app/view_state_mixin.dart';
import 'package:client_app/views/busy_error_child_view.dart';
import 'package:client_app/views/image_widget.dart';
import 'package:flutter/material.dart';

import '../models/issuer.dart';
import '../models/project.dart';
import '../views/project_card_view.dart';
import '../views/review_card.dart';

class ViewIssuerScreen extends StatefulWidget {
  const ViewIssuerScreen(
      {super.key,
      required this.issuerId,
      required this.issuerImage,
      required this.isIssuer,
      required this.isWhiteBackground});
  final int issuerId;
  final CdnImage issuerImage;
  final bool isWhiteBackground;
  final bool isIssuer;

  @override
  State<ViewIssuerScreen> createState() => _ViewIssuerScreenState();
}

class _ViewIssuerScreenState extends State<ViewIssuerScreen>
    with ViewStateMixin {
  late Issuer issuer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        setBusy();

        print(widget.issuerId);

        issuer = await getIt<ProjectService>()
            .getIssuer(isIssuer: widget.isIssuer, issuerId: widget.issuerId);

        setIdle();
      } catch (e) {
        log("Error in ViewIssuerScreen Init", error: e);
        setError();
        rethrow;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            widget.isWhiteBackground ? Colors.white : primaryBGColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: ImageWidget.fromCdn(
                        widget.issuerImage,
                      ),
                    ),
                    // backbutton
                    Positioned(
                        left: 16,
                        top: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: BackButton(
                            color: primaryColor,
                          ),
                        )),
                  ],
                ),
                BusyErrorChildView(
                    viewState: viewState,
                    builder: () {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              issuer.title,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            // description
                            Text(
                              issuer.description,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: primaryColor,
                              ),
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            Text("What People Say About Their Work",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor)),

                            const SizedBox(
                              height: 16,
                            ),

                            Container(
                              height: 150,
                              child: ListView.builder(
                                  itemExtent:
                                      MediaQuery.of(context).size.width * 0.9,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: issuer.reviews!.length,
                                  itemBuilder: ((context, index) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: ReviewCard(
                                          review: issuer.reviews![index],
                                          bgColor: !widget.isWhiteBackground
                                              ? Colors.white
                                              : primaryBGColor,
                                        ),
                                      ))),
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            Text("Their Work",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor)),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                              height: 350,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: issuer.projects!.length,
                                  itemBuilder: ((context, index) {
                                    final Project project =
                                        issuer.projects![index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: ProjectCardView(
                                        bgColor: !widget.isWhiteBackground
                                            ? Colors.white
                                            : primaryBGColor,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ViewProjectScreen(
                                                        isWhiteBackground: widget
                                                            .isWhiteBackground,
                                                        projectId: project.id,
                                                        projectImage:
                                                            project.photo,
                                                      )));
                                        },
                                        project: project,
                                      ),
                                    );
                                  })),
                            ),

                            //bottom
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }
}
