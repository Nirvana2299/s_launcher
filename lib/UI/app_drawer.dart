import 'dart:ui';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final List sortedApps;
  final List applications;
  final ScrollController scrollController;
  AppDrawer({super.key, required this.sortedApps, required this.applications, required this.scrollController});

    
  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      controller: scrollController,
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: applications.length,
    itemBuilder: (context, index) {
      // final applicationIcon = widget.sortedApps.isNotEmpty ? widget.sortedApps[index].icon as Uint8List : widget.sortApps[index].icon as Uint8List;
    final application = sortedApps.isNotEmpty
        ? sortedApps[index] as ApplicationWithIcon
        : applications[index] as ApplicationWithIcon;
    return SizedBox(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => DeviceApps.openApp(application.packageName),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Container(
                  child: AspectRatio(
                    aspectRatio: 6 / 6,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                            color: Colors.transparent),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(application.icon))),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.width * 0.04,
              child: Text(
                application.appName,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.clip,
              ),
            )
          ]),
    );
    },
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      mainAxisSpacing: 20, maxCrossAxisExtent: 90, crossAxisSpacing: 20),
      );
  }
}
