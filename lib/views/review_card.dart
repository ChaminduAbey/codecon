import 'package:client_app/models/review.dart';
import 'package:client_app/theme.dart';
import 'package:client_app/views/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review, required this.bgColor});
  final Review review;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ImageWidget.fromCdn(
            review.user!.photo!,
            width: 120,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                review.user!.firstName + " " + review.user!.lastName,
                maxLines: 1,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: primaryColor),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                review.review,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: primaryColor),
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (int i = 1; i <= 5; i++)
                    Icon(
                      Icons.star,
                      color: i <= review.rating ? Colors.amber : Colors.grey,
                      size: 24,
                    )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          )),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
