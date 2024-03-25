import 'dart:ui';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final List sortedApps;
  // final List applications;
  final ScrollController scrollController;
  const AppDrawer({super.key, required this.sortedApps, required this.scrollController});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  //Open Specific app
  openApp(String packageName) {
    setState(() {
      DeviceApps.openApp(packageName);
    });
  }

  //Uninstall Specific APP
  uninstallAPP(String packageName) {
    setState(() {
    DeviceApps.uninstallApp(packageName);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 85.0, top: 20),
      child: GridView.builder(
        controller: widget.scrollController,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.sortedApps.length,
        itemBuilder: (context, index) {
          final application = widget.sortedApps[index] as ApplicationWithIcon;
          return GestureDetector(
            onLongPress: () => appLongPressPopUP(context, openApp, uninstallAPP,
                appName: application.appName,
                appPackageName: application.packageName),
            onTap: () => DeviceApps.openApp(application.packageName),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.10, // Adjust this value as needed
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.transparent,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              application.icon,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.004), // Adjust this value as needed
                      Container(
                        color: Colors.transparent,
                        child: Text(
                          application.appName,
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context)
                                .devicePixelRatio * 4.1, // Adjust this value as needed
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: MediaQuery.of(context).size.height * 0.024,
          maxCrossAxisExtent: 110,
          crossAxisSpacing: MediaQuery.of(context).size.width * 0.024,
        ),
      ),
    );
  }

}


Future<void> appLongPressPopUP(BuildContext context, dynamic Function(String) openApp, dynamic Function(String) uninstallAPP, {String appName = '', String appPackageName = ''}) {
  return showDialog(context: context, builder: (BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
       
          child: Dialog(
            backgroundColor: Colors.grey.withOpacity(0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(child: Align(alignment: Alignment.topRight, child: Padding(
                        padding: EdgeInsets.only(right: 10.0, top: 5.0),
                        child: Icon(Icons.cancel, color: Colors.white,),
                      )),),
                    ),
                    GestureDetector(onTap: () {
                      Navigator.pop(context);
                      openApp(appPackageName);
                      }, child: SizedBox(height: MediaQuery.of(context).size.height * 0.05,  child: const Center(child: Text('Open', style: TextStyle(color: Colors.white))))),
                    const Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,  child: Center(child: Text('Pin $appName on top', style: const TextStyle(color: Colors.white)))),
                    const Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,  child: const Center(child: Text('App info', style: TextStyle(color: Colors.white)))),
                    const Divider(),
                    GestureDetector(onTap: () => uninstallAPP(appPackageName), child: SizedBox(height: MediaQuery.of(context).size.height * 0.05,  child: const Center(child: Text('Uninstall', style: TextStyle(color: Colors.white))))),
                  ],
                ),
              ),
        ),
      
    );
  });
}