import 'dart:developer';

import 'package:client_app/main.dart';
import 'package:client_app/models/project.dart';
import 'package:client_app/models/timeline.dart';
import 'package:client_app/services/projects_service.dart';
import 'package:client_app/theme.dart';
import 'package:client_app/view_state_mixin.dart';
import 'package:client_app/views/busy_error_child_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

import '../views/staggered_animation_child.dart';

class ViewTimelineScreen extends StatefulWidget {
  const ViewTimelineScreen({super.key, required this.project});
  final Project project;

  @override
  State<ViewTimelineScreen> createState() => _ViewTimelineScreenState();
}

class _ViewTimelineScreenState extends State<ViewTimelineScreen>
    with ViewStateMixin {
  late List<Timeline> timelines;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        setBusy();

        timelines = await getIt<ProjectService>()
            .getTimelineForProject(projectId: widget.project.id);

        setIdle();
      } catch (e) {
        log("Error in ViewTimeLineScreen InitState", error: e);
        setError();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBGColor,
      appBar: AppBar(
        backgroundColor: primaryBGColor,
        title: const Text("Timeline"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BusyErrorChildView(
            viewState: viewState,
            builder: () => AnimationLimiter(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: timelines.length,
                      itemBuilder: ((context, index) {
                        final Timeline timeline = timelines[index];
                        // use intl package to 19th Mar format
                        String month = DateFormat("MMM").format(timeline.date);

                        //date with 1st 2nd 3rd 10th etc format
                        // append st, nd, rd, th to date
                        late String date;
                        if (timeline.date.day == 1 ||
                            timeline.date.day == 21 ||
                            timeline.date.day == 31) {
                          date = "${timeline.date.day}st";
                        } else if (timeline.date.day == 2 ||
                            timeline.date.day == 22) {
                          date = "${timeline.date.day}nd";
                        } else if (timeline.date.day == 3 ||
                            timeline.date.day == 23) {
                          date = "${timeline.date.day}rd";
                        } else {
                          date = "${timeline.date.day}th";
                        }
                        return StaggerAnimationChild(
                          index: index,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  width: 96,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text("$date ${month}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: primaryColor)),
                                      Text(timeline.date.year.toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: primaryColor)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: Text(timeline.text,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor))),
                              ],
                            ),
                          ),
                        );
                      })),
                )),
      ),
    );
  }
}
