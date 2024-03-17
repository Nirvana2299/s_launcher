import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final List sortedApps;
  final List sortApps;
  final List applications;
  const AppDrawer({super.key, required this.sortedApps, required this.sortApps, required this.applications});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: widget.applications.length,
    itemBuilder: (context, index) {
      // final applicationIcon = widget.sortedApps.isNotEmpty ? widget.sortedApps[index].icon as Uint8List : widget.sortApps[index].icon as Uint8List;
    final application = widget.sortedApps.isNotEmpty
        ? widget.sortedApps[index] as ApplicationWithIcon
        : widget.sortApps[index] as ApplicationWithIcon;
    return SizedBox(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => DeviceApps.openApp(application.packageName),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: AspectRatio(
                  aspectRatio: 6 / 6,
                  child: Container(
                      // width: MediaQuery.of(context).size.width * 0.19,
                      // height: MediaQuery.of(context).size.height * 0.28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                          color: Colors.white),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(application.icon))),
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            SizedBox(
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
      mainAxisSpacing: 10, maxCrossAxisExtent: 100, crossAxisSpacing: 10),
      );
  }
}
