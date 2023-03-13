import 'package:client_app/models/project.dart';
import 'package:client_app/theme.dart';
import 'package:client_app/views/image_widget.dart';
import 'package:flutter/material.dart';

class ProjectCardView extends StatelessWidget {
  const ProjectCardView(
      {super.key,
      required this.onTap,
      required this.project,
      required this.bgColor});
  final Project project;
  final Function() onTap;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 250,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 12,
              child: ImageWidget(
                  imageUrl: project.photo.url,
                  blurhash: project.photo.blurhash),
            ),
            Container(
              decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  )),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  Text(
                    project.title,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        project.estTime,
                        style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      Text(
                        "${project.estCost} LKR",
                        style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
