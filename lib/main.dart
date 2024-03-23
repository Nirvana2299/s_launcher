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

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        ));

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


  bool wallpaperMode = false;

  changeBackground() {
    if(!wallpaperMode) {
      wallpaperMode = true;
    } else {
      wallpaperMode = false;
    }
    print(wallpaperMode);
    setState(() {
      
    });
  }
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
      
      backgroundColor: wallpaperMode ?  Colors.transparent : const Color(0xff1C1760),
      body: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loading
                ? const Center(
                  child: CircularProgressIndicator(),
                )
                : searchList.isEmpty ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), child: const Center(child: Text('app not found :(', style: TextStyle(fontSize: 24.0, color: Colors.white),),))  :
                SingleChildScrollView(
                  // controller: firstController,
                  child: AppDrawer(
                    sortedApps: searchList,
                    // applications: searchList.isNotEmpty
                    //     ? searchList
                    //     : applications,
                    scrollController: firstController,
                  ),
                ),
                  const SizedBox(height: 5.0,),
                   Stack(
              children: [

                     Builder(
                  builder: (BuildContext context) {
                    return Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.09,
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent),
                                ))));
                  },
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    child: Builder(
                      builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),color: Colors.transparent,),
                            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: SearchBar(
                              controller: searchBarTextController,
                              elevation: const MaterialStatePropertyAll(0),
                              textStyle: const MaterialStatePropertyAll(TextStyle(color: Colors.white)),
                              backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
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
                              }), child: searchBarTextController.text.isNotEmpty ? const Icon(Icons.cancel, color: Colors.white70,) : Container()),PopupMenuExample(context1: context, onTap: changeBackground,)],
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}

class PopupMenuExample extends StatefulWidget {
  final BuildContext context1;
  final void Function()? onTap;
  const PopupMenuExample({super.key, required this.context1, this.onTap});

  @override
  State<PopupMenuExample> createState() => _PopupMenuExampleState();
}

  enum Menu { preview, share, getLink, remove, download }
class _PopupMenuExampleState extends State<PopupMenuExample> {

  @override
  Widget build(BuildContext context1) {
    return  
                PopupMenuButton<Menu>(
                  color: Colors.white,
                  // popUpAnimationStyle: _animationStyle,
                             
                  icon: const Icon(Icons.more_vert, color: Colors.white,),
                  onSelected: (Menu item) {},
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    PopupMenuItem<Menu>(
                      value: Menu.preview,
                      child: ListTile(
                        onTap: () => widget.onTap!(),
                        leading: const Icon(Icons.wallpaper),
                        title: const Text('Wallpaper Mode'),
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.share,
                      child: ListTile(
                        leading: Icon(Icons.share_outlined),
                        title: Text('Share'),
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.getLink,
                      child: ListTile(
                        leading: Icon(Icons.link_outlined),
                        title: Text('Get link'),
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<Menu>(
                      value: Menu.remove,
                      child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Remove'),
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.download,
                      child: ListTile(
                        leading: Icon(Icons.download_outlined),
                        title: Text('Download'),
                      ),
                    ),
                  ],
                );   
  }
}

