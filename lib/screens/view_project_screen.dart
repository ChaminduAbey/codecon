import 'dart:developer';

import 'package:client_app/main.dart';
import 'package:client_app/models/cdn_image.dart';
import 'package:client_app/models/issuer.dart';
import 'package:client_app/models/project.dart';
import 'package:client_app/screens/add_update_review_screen.dart';
import 'package:client_app/screens/view_issuer_screen.dart';
import 'package:client_app/view_state_mixin.dart';
import 'package:client_app/views/busy_error_child_view.dart';
import 'package:flutter/material.dart';

import '../services/projects_service.dart';
import '../theme.dart';
import '../views/image_widget.dart';
import '../views/review_card.dart';

class ViewProjectScreen extends StatefulWidget {
  const ViewProjectScreen(
      {super.key,
      required this.projectId,
      required this.projectImage,
      required this.isWhiteBackground});
  final CdnImage projectImage;
  final int projectId;
  final bool isWhiteBackground;

  @override
  State<ViewProjectScreen> createState() => _ViewProjectScreenState();
}

class _ViewProjectScreenState extends State<ViewProjectScreen>
    with ViewStateMixin {
  late Project project;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        setBusy();

        project = await getIt<ProjectService>()
            .getProjectById(projectId: widget.projectId);

        setIdle();
      } catch (e) {
        log("Error in ViewProjectScreen Init", error: e);
        setError();
        rethrow;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color childrenBGColor = !widget.isWhiteBackground
        ? Colors.white
        : Theme.of(context).scaffoldBackgroundColor;
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
                      widget.projectImage,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            project.title,
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
                            project.description,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: primaryColor,
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: childrenBGColor),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "Est. Time :",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor),
                                    )),
                                    Text(
                                      project.estTime,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "Est. Cost  :",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor),
                                    )),
                                    Text(
                                      "${project.estCost} LKR",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          if (project.reviews.isNotEmpty) ...[
                            Text("What People Think",
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
                                  itemCount: project.reviews.length,
                                  itemBuilder: ((context, index) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: ReviewCard(
                                          review: project.reviews![index],
                                          bgColor: !widget.isWhiteBackground
                                              ? Colors.white
                                              : primaryBGColor,
                                        ),
                                      ))),
                            ),
                            const SizedBox(
                              height: 16,
                            )
                          ],

                          if (project.status == "UPCOMING") ...[
                            Text("Bids",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor)),
                            const SizedBox(
                              height: 16,
                            ),
                            buildBidsSection(childrenBGColor),
                            const SizedBox(
                              height: 16,
                            ),
                          ],

                          Text("Issued By",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor)),

                          const SizedBox(
                            height: 16,
                          ),

                          issuedByCard(context, childrenBGColor),

                          const SizedBox(
                            height: 16,
                          ),

                          if (project.status != "UPCOMING") ...[
                            Text("Contractor",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor)),
                            const SizedBox(
                              height: 16,
                            ),
                            contactractorCard(context, childrenBGColor),
                            const SizedBox(
                              height: 16,
                            ),
                          ],

                          const SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        )),
        floatingActionButton: !isIdle
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddUpdateReview(project: project)));
                },
                icon: const Icon(Icons.add),
                label: Text("Add Reivew"),
              ));
  }

  Widget buildBidsSection(Color childrenBGColor) {
    return Container(
      height: 285,
      child: ListView.builder(
          itemCount: project.bidders.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final Issuer bidder = project.bidders[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewIssuerScreen(
                            isIssuer: false,
                            isWhiteBackground: !widget.isWhiteBackground,
                            issuerId: bidder.id,
                            issuerImage: bidder.photo)));
              },
              child: Container(
                width: 250,
                margin: const EdgeInsets.only(right: 16),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 12,
                      child: ImageWidget(
                          imageUrl: bidder.photo.url,
                          blurhash: bidder.photo.blurhash),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: childrenBGColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0),
                          )),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bidder.title,
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            project.description,
                            maxLines: 2,
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 12),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget issuedByCard(BuildContext context, Color childrenBGColor) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ViewIssuerScreen(
                  issuerId: project.issuer.id,
                  issuerImage: project.issuer.photo,
                  isIssuer: true,
                  isWhiteBackground: !widget.isWhiteBackground))),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ImageWidget(
                  imageUrl: project.issuer.photo.url,
                  blurhash: project.issuer.photo.blurhash),
            ),
            Container(
              decoration: BoxDecoration(
                  color: childrenBGColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  )),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.issuer.title,
                    style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    project.issuer.description,
                    maxLines: 2,
                    style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contactractorCard(BuildContext context, Color childrenBGColor) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ViewIssuerScreen(
                  issuerId: project.contractor.id,
                  issuerImage: project.contractor.photo,
                  isIssuer: false,
                  isWhiteBackground: !widget.isWhiteBackground))),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ImageWidget(
                  imageUrl: project.contractor.photo.url,
                  blurhash: project.contractor.photo.blurhash),
            ),
            Container(
              decoration: BoxDecoration(
                  color: childrenBGColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  )),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.contractor.title,
                    style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    project.contractor.description,
                    maxLines: 2,
                    style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
