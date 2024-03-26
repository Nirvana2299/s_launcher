import 'dart:async';
import 'dart:ui';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
    Navigator.pop(context);
    setState(() {
      if (!wallpaperMode) {
        wallpaperMode = true;
      } else {
        wallpaperMode = false;
      }
    });
  }

  List<Application> searchResultList = [];
  List<Application> applications = [];
  bool loading = false;
  List<Application> searchList = [];

  List<Application> filteredApplications = [];
  bool searching = false;

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  void fetchApplications() async {
    try {
      setState(() {
        loading = true;
      });
      final apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );
      setState(() {
        applications = apps;
        sortApps();
        searchList =
            List.of(applications); // Initialize searchList with all apps
        loading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      setState(() {
        loading = false;
      });
    }
  }

  void sortApps() {
    applications.sort(
        (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
  }

  void updateList() {
    setState(() {
      searchList = applications;
      searchBarTextController.clear();
      searching = false;
    });
  }

  void searchResult(String query) {
    query = query.trim();
    if (query.isNotEmpty) {
      setState(() {
        filteredApplications = applications
            .where((app) =>
                app.appName.toLowerCase().contains(query.toLowerCase()))
            .toList();
        searching = true;
      });
    } else {
      setState(() {
        // filteredApplications = List.of(applications);
        searching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor:
            wallpaperMode ? Colors.transparent : const Color(0xff1C1760),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Stack(
              children: [
                loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : filteredApplications.isEmpty && searchBarTextController.text.isNotEmpty || searchList.isEmpty 
                        ? BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),color: Colors.grey.withOpacity(0.6)),
                                height: 300,
                                width: 300,
                                
                                child: const Center(
                                  child: Text(
                                    'app not found :(',
                                    style: TextStyle(
                                        fontSize: 24.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            ))
                        : SingleChildScrollView(
                            // controller: firstController,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: AppDrawer(
                                sortedApps:
                                    searching ? filteredApplications : searchList,
                                scrollController: firstController,
                              ),
                            ),
                          ),
                Builder(builder: (context) {
                  return Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                          child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.09,
                                decoration: const BoxDecoration(
                                    color: Colors.transparent),
                              ))));
                }),
                const Positioned(top: 34, left: 9, child: ClockWidget()),
                Builder(
                  builder: (context) {
                    return Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Builder(
                            builder: (context) {
                              return CustomSearchBar(
                              
                               searchBarTextController: searchBarTextController,
                               changeBackground: changeBackground,
                               fetchApplications: fetchApplications,
                               onChanged: (value) => searchResult(value),
                               onTap: updateList,
                                    );
                            }
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PopupMenuExample extends StatelessWidget {
  final BuildContext context1;
  final void Function()? onTap;
  final void Function()? reload;
  final dynamic openSettingsApp;

  const PopupMenuExample(
      {super.key,
      required this.context1,
      this.onTap,
      this.reload,
      this.openSettingsApp});

  @override
  Widget build(BuildContext context1) {
    return PopupMenuButton<Menu>(
      color: Colors.white,
      // popUpAnimationStyle: _animationStyle,

      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (Menu item) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        PopupMenuItem<Menu>(
          value: Menu.wallpaperMode,
          child: ListTile(
            onTap: () => onTap!(),
            leading: const Icon(Icons.wallpaper),
            title: const Text('Wallpaper Mode'),
          ),
        ),
        PopupMenuItem<Menu>(
          value: Menu.systemSettings,
          child: ListTile(
            onTap: () => openSettingsApp(),
            leading: const Icon(Icons.settings),
            title: const Text('System Settings'),
          ),
        ),
        PopupMenuItem<Menu>(
          value: Menu.appListReload,
          child: ListTile(
            onTap: reload,
            leading: const Icon(Icons.restart_alt),
            title: const Text('Reload App Drawer'),
          ),
        ),
        // const PopupMenuDivider(),
        // const PopupMenuItem<Menu>(
        //   value: Menu.remove,
        //   child: ListTile(
        //     leading: Icon(Icons.delete_outline),
        //     title: Text('Remove'),
        //   ),
        // ),
        // const PopupMenuItem<Menu>(
        //   value: Menu.download,
        //   child: ListTile(
        //     leading: Icon(Icons.download_outlined),
        //     title: Text('Download'),
        //   ),
        // ),
      ],
    );
  }
}

enum Menu { wallpaperMode, systemSettings, appListReload, remove, download }

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.white.withOpacity(0.9)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Text(
                      DateFormat('MM/dd/yyyy hh:mm:ss').format(DateTime.now()),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              MediaQuery.of(context).devicePixelRatio *
                              0.01,
                          color: Colors.black),
                    ))));
      },
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController searchBarTextController;
  final void Function() changeBackground;
  final void Function() fetchApplications;

  const CustomSearchBar(
      {super.key,
      this.onTap,
      this.onChanged,
      required this.searchBarTextController,
      required this.changeBackground,
      required this.fetchApplications});

  @override
  Widget build(BuildContext context) {
    openSettingsApp() {
      Navigator.pop(context);
      DeviceApps.openApp('com.android.settings');
    }

    return ClipRRect(child: Builder(builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.only(bottom: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.transparent,
          ),
          child: SearchBar(
                controller: searchBarTextController,
                elevation: const MaterialStatePropertyAll(0),
                textStyle: const MaterialStatePropertyAll(
                    TextStyle(color: Colors.white)),
                backgroundColor:
                    const MaterialStatePropertyAll(Colors.transparent),
                onChanged: (value) => onChanged!(value),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
                hintText: 'Search Apps',
                padding: const MaterialStatePropertyAll(EdgeInsets.all(10.0)),
                side: MaterialStatePropertyAll(
                    BorderSide(color: Colors.grey.shade500, width: 2.0)),
                hintStyle: const MaterialStatePropertyAll(
                    TextStyle(color: Colors.white, fontSize: 18.0)),
                leading: const Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                trailing: [
                  GestureDetector(
                      onTap: onTap,
                      child: searchBarTextController.text.isNotEmpty
                          ? const Icon(
                              Icons.cancel,
                              color: Colors.white70,
                            )
                          : Container()),
                  PopupMenuExample(
                    context1: context,
                    onTap: changeBackground,
                    reload: fetchApplications,
                    openSettingsApp: openSettingsApp,
                  )
                ],
              )
        ),
      );
    }));
  }
}
