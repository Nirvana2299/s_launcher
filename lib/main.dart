import 'dart:ui';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s_launcher/UI/app_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    const SystemUiOverlayStyle(
    //NavigationBar
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarIconBrightness: Brightness.dark,
    //StatusBar
    // systemStatusBarContrastEnforced: false,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  );
    return MaterialApp(
      title: 'S Launcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchBarTextController = TextEditingController();
  final ScrollController firstController = ScrollController();
  List<Application> applications = [];
  bool loading = false;
  void getApplications() async {
    try {
      loading = true;
      final apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );
      setState(() {
        applications = apps;
        sortApps(applications);
        searchList = sortedApps;
      });
      loading = false;
    } catch (e) {
      SnackBar(
        content: Text(e.toString()),
      );
    } finally {
      loading = false;
    }
  }

  List sortedApps = [];

  List sortApps(List appsListName) {
    sortedApps = appsListName.map((e) => e).toList();
    sortedApps.sort(
      (a, b) => a.appName
          .toString()
          .toLowerCase()
          .compareTo(b.appName.toString().toLowerCase()),
    );
    return sortedApps;
  }

  List searchList = [];

  void searchResult(String query) {
    query = query.trim();
    if (query.isNotEmpty) {
      searchList = sortedApps
          .where((application) => application.appName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    } else {
      searchList = sortedApps;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getApplications();
    // sortApps(applications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      
      backgroundColor: Colors.transparent,//const Color(0xff1C1760),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 12.0),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'Hi Shoaib! :)',
              //   style: TextStyle(fontSize: 30, color: Colors.white),
              //   textAlign: TextAlign.start,
              // ),
             
              // ClipRRect(
              //   child: BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              //     child: Container(
              //       color: Colors.grey.withOpacity(0.1),
              //       width: MediaQuery.of(context).size.width,
              //       height: 10.0,
              //     ),
              //   ),
              // ),
              loading
                  ? Center(
                    child: CircularProgressIndicator(),
                  )
                  : SingleChildScrollView(
                    // controller: firstController,
                    child: AppDrawer(
                      sortedApps: searchList.isNotEmpty ? searchList : sortedApps,
                      applications: searchList.isNotEmpty
                          ? searchList
                          : applications,
                      scrollController: firstController,
                    ),
                  ),
                    const SizedBox(height: 5.0,),
                     Stack(
                children: [
                  // Container(
                  //   width: 70,
                  //   height: 70,
                  //   decoration: const BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       gradient: LinearGradient(colors: [
                  //         Color(0xff744ff9),
                  //         Color(0xff8369de),
                  //         Color(0xff8da0cb)
                  //       ])),
                  // ),
                  // ClipRRect(
                  //   child: BackdropFilter(
                  //     filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  //     child: Container(
                  //       width: 500,
                  //       height: 200,
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey.withOpacity(0.1),
                  //       )
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),color: Colors.grey.withOpacity(0.1),),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: SearchBar(
                            controller: searchBarTextController,
                            elevation: const MaterialStatePropertyAll(0),
                            textStyle: const MaterialStatePropertyAll(TextStyle(color: Colors.white)),
                            backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                            onChanged: (value) => searchResult(value),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),),
                            hintText: 'Search Apps',
                            padding: const MaterialStatePropertyAll(EdgeInsets.all(10.0)),
                            side: MaterialStatePropertyAll(BorderSide(color: Colors.grey.shade500, width: 2.0)),
                            hintStyle: const MaterialStatePropertyAll(TextStyle(color: Colors.white, fontSize: 18.0)),
                            leading: const Icon(Icons.search, color: Colors.white70,),
                            trailing: [GestureDetector(onTap: () => setState(() {
                              searchList = sortedApps;
                              searchBarTextController.clear();
                            }), child: searchBarTextController.text.isNotEmpty ? const Icon(Icons.cancel, color: Colors.white70,) : Container())],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
