import 'dart:developer';

import 'package:client_app/main.dart';
import 'package:client_app/models/project.dart';
import 'package:client_app/services/projects_service.dart';
import 'package:client_app/theme.dart';
import 'package:client_app/view_state_mixin.dart';
import 'package:client_app/views/busy_error_child_view.dart';
import 'package:client_app/views/popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/review.dart';
import '../views/constrained_button_view.dart';
import '../views/custom_loading_dialog.dart';

class AddUpdateReview extends StatefulWidget {
  const AddUpdateReview({super.key, required this.project});
  final Project project;

  @override
  State<AddUpdateReview> createState() => _AddUpdateReviewState();
}

class _AddUpdateReviewState extends State<AddUpdateReview> {
  double rating = 0.0;
  final TextEditingController reviewTxtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("Provide Feedback"),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              // on small devices to keep a small space between bottom navigation bar and the button
              bottom: 40),
          child: Column(
            children: [
              // Center(
              //   child: Stack(
              //     clipBehavior: Clip.none,
              //     children: [
              //       // CachedNetworkImage(
              //       //   width: 90,
              //       //   height: 90,
              //       //   imageUrl: sellerInfo!.profilePicture!,
              //       //   placeholder: (context, url) =>
              //       //       ShimmerCircle(),
              //       //   errorWidget: (context, url, error) =>
              //       //       Icon(Icons.error),
              //       //   imageBuilder: (context, imageProvider) =>
              //       //       CircleAvatar(
              //       //     backgroundImage: imageProvider,
              //       //   ),
              //       //   fit: BoxFit.cover,
              //       // ),
              //       Positioned(
              //         left: 0,
              //         right: 0,
              //         bottom: -20,
              //         child: Center(
              //           child: Container(
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(32),
              //               // material style shadow
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: Colors.grey,
              //                   blurRadius: 5.0,
              //                   spreadRadius: 0.6,
              //                   offset: Offset(0.0, 1.0),
              //                 )
              //               ],
              //             ),
              //             padding: const EdgeInsets.all(8),
              //             child: Row(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Icon(
              //                   Icons.star,
              //                   color: Colors.amber,
              //                 ),
              //                 const SizedBox(
              //                   width: 8,
              //                 ),
              //                 Text(
              //                   "4.2" ?? "N\A",
              //                   style: TextStyle(
              //                       fontSize: 12,
              //                       color: primaryColor,
              //                       fontWeight: FontWeight.w500),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 32,
              ),
              Text(
                widget.project.title,
                textAlign: TextAlign.center,
                style: primaryTitleTxtStyle,
              ),
              const SizedBox(
                height: 24,
              ),
              Text("Rate this project",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 16,
              ),
              RatingBar.builder(
                initialRating: rating.toDouble(),
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                unratedColor: greyColor,
                onRatingUpdate: (x) {
                  setState(() {
                    rating = x;
                  });
                },
                ignoreGestures: false,
                itemSize: 40,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                "Feedback",
                style: TextStyle(
                    fontSize: 14,
                    color: greyColor,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 16,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: TextField(
                    minLines: 4,
                    maxLines: 6,
                    controller: reviewTxtController,
                    decoration: InputDecoration(
                        isDense: true,
                        hintStyle: TextStyle(
                            fontSize: 16,
                            color: greyColor,
                            fontWeight: FontWeight.w400),
                        hintText: "Write your feedback here",
                        border: multilineOutlineInputBorder,
                        enabledBorder: multilineOutlineInputBorder,
                        focusedBorder: multilineOutlineInputBorder)),
              ),
              SizedBox(height: 40),
              ConstrainedButton(
                child: ElevatedButton(
                  //disable button if rating is not provided
                  onPressed: rating == 0.0 ? null : submitReview,
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        )));
  }

  Future<void> submitReview() async {
    try {
      CustomLoadingDialog.show(context, message: "Submitting review...");

      final Review review = Review(
        id: 0,
        rating: rating,
        review: reviewTxtController.text,
        projectId: widget.project.id,
      );

      await getIt<ProjectService>().addReview(review: review);

      CustomLoadingDialog.hide(context);

      Popups.showSnackbar(context: context, message: "Review submitted");

      Navigator.of(context).pop();
    } catch (e) {
      log("Error submitting review: ", error: e);
      CustomLoadingDialog.hide(context);
      Popups.showSnackbar(context: context, message: "Error submitting review");
      rethrow;
    }
  }
}
