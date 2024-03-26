import 'dart:ui';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final List sortedApps;
  // final List applications;
  final ScrollController scrollController;
  const AppDrawer(
      {super.key, required this.sortedApps, required this.scrollController});

      openApp(String packageName) {
    // setState(() {
    DeviceApps.openApp(packageName);
    // });
  }

  //Uninstall Specific APP
  uninstallAPP(String packageName) {
    // setState(() {
    DeviceApps.uninstallApp(packageName);
    // });
  }

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 75.0, top: 20),
      child: GridView.builder(
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: sortedApps.length,
        itemBuilder: (context, index) {
          // final applicationIcon = widget.sortedApps.isNotEmpty ? widget.sortedApps[index].icon as Uint8List : widget.sortApps[index].icon as Uint8List;
          final application = sortedApps[index] as ApplicationWithIcon;
          // final application = sortedApps.isNotEmpty
          //     ? sortedApps[index] as ApplicationWithIcon
          //     : applications[index] as ApplicationWithIcon;
          return SizedBox(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onLongPress: () => appLongPressPopUP(
                        context, openApp, uninstallAPP,
                        appName: application.appName,
                        appPackageName: application.packageName),
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
                  Flexible(
                    child: Container(
                      color: Colors.transparent,
                      // height: MediaQuery.of(context).size.width * 0.04,
                      child: Text(
                        application.appName,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  )
                ]),
          );
        },
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 20, maxCrossAxisExtent: 100, crossAxisSpacing: 20),
      ),
    );
  }
}

Future<void> appLongPressPopUP(BuildContext context,
    dynamic Function(String) openApp, dynamic Function(String) uninstallAPP,
    {String appName = '', String appPackageName = ''}) {
  return showDialog(
    useSafeArea: false,
    
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
            shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              insetAnimationCurve: Curves.bounceIn,
              insetAnimationDuration: const Duration(milliseconds: 3000),
              backgroundColor: Colors.white.withOpacity(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child:  SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0, top: 5.0),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        openApp(appPackageName);
                      },
                      child: Container(
                    
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                              // border: Border(bottom: BorderSide(color: Colors.white54)),
                              color: Colors.blue.withOpacity(0.2)),
                        width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: const Center(
                              child: Text('Open',
                                  style: TextStyle(color: Colors.white))))),
               
                  Container(
                    decoration:
                          BoxDecoration(
                         
                          color: Colors.grey.withOpacity(0.2)),
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Center(
                          child: Text('Pin $appName on top',
                              style: const TextStyle(color: Colors.white)))),
                
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: const Center(
                          child: Text('App info',
                              style: TextStyle(color: Colors.white)))),
                
                  GestureDetector(
                      onTap: () => uninstallAPP(appPackageName),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)), color: Colors.red.withOpacity(0.2),
                          ),
                        
                        width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: const Center(
                              child: Text('Uninstall',
                                  style: TextStyle(color: Colors.white))))),
                ],
              ),
            ),
          ),
        );
      });
}
