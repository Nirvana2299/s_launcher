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

  // String? _timeString;

  // String _formatDateTime(DateTime dateTime) {
  //   return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  // }

  // void _getTime() {
  //   final DateTime now = DateTime.now();
  //   final String formattedDateTime = _formatDateTime(now);
  //   setState(() {
  //     _timeString = formattedDateTime;
  //   });
  // }

  openSettingsApp() {
    setState(() {
      DeviceApps.openApp('com.android.settings');
    });
  }

  bool wallpaperMode = false;

  changeBackground() {
    setState(() {
      if (!wallpaperMode) {
        wallpaperMode = true;
      } else {
        wallpaperMode = false;
      }
    });
  }

  List<Application> applications = [];
  bool loading = false;
  List<Application> searchList = [];

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

  void searchResult(String query) {
    query = query.trim();
    if (query.isNotEmpty) {
      setState(() {
        searchList = applications
            .where((app) =>
                app.appName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        searchList = List.of(applications); // Reset searchList to all apps
      });
    }
  }
  // void getApplications() async {
  //   try {
  //     loading = true;
  //     final apps = await DeviceApps.getInstalledApplications(
  //       includeAppIcons: true,
  //       includeSystemApps: true,
  //       onlyAppsWithLaunchIntent: true,
  //     );
  //     setState(() {
  //       applications = apps;
  //       sortApps(applications);
  //       searchList = sortedApps;
  //     });
  //     loading = false;
  //     print('refresh triggered 3');
  //   } catch (e) {
  //     SnackBar(
  //       content: Text(e.toString()),
  //     );
  //   } finally {
  //     loading = false;
  //   }
  // }

  // List sortedApps = [];

  // List sortApps(List appsListName) {
  //   sortedApps = appsListName.map((e) => e).toList();
  //   sortedApps.sort(
  //     (a, b) => a.appName
  //         .toString()
  //         .toLowerCase()
  //         .compareTo(b.appName.toString().toLowerCase()),
  //   );
  //   print('refresh triggered 2');
  //   return sortedApps;
  // }

  // List searchList = [];

  // void searchResult(String query) {
  //   query = query.trim();
  //   if (query.isNotEmpty) {
  //     searchList = sortedApps
  //         .where((application) => application.appName
  //             .toString()
  //             .toLowerCase()
  //             .contains(query.toLowerCase()))
  //         .toList();
  //   } else {
  //     searchList = sortedApps;
  //   }
  //   print('refresh triggered');
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getApplications();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  : searchList.isEmpty
                      ? BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: const Center(
                            child: Text(
                              'app not found :(',
                              style: TextStyle(
                                  fontSize: 24.0, color: Colors.white),
                            ),
                          ))
                      : SingleChildScrollView(
                          // controller: firstController,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: AppDrawer(
                                  sortedApps: searchList,
                                  scrollController: firstController,
                                ),
                              ),
                            ],
                          ),
                        ),
              Stack(
                children: [
                  Builder(builder: (context) {
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
                  }),
                  const Positioned(top: 34, left: 9, child: ClockWidget()),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(child: Builder(builder: (context) {
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
                            backgroundColor: const MaterialStatePropertyAll(
                                Colors.transparent),
                            onChanged: (value) => searchResult(value),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                            ),
                            hintText: 'Search Apps',
                            padding: const MaterialStatePropertyAll(
                                EdgeInsets.all(10.0)),
                            side: MaterialStatePropertyAll(BorderSide(
                                color: Colors.grey.shade500, width: 2.0)),
                            hintStyle: const MaterialStatePropertyAll(
                                TextStyle(color: Colors.white, fontSize: 18.0)),
                            leading: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            trailing: [
                              GestureDetector(
                                  onTap: () => setState(() {
                                        searchList = applications;
                                        searchBarTextController.clear();
                                      }),
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
                          ),
                        ),
                      );
                    })),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopupMenuExample extends StatefulWidget {
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
  State<PopupMenuExample> createState() => _PopupMenuExampleState();
}

enum Menu { wallpaperMode, systemSettings, appListReload, remove, download }

class _PopupMenuExampleState extends State<PopupMenuExample> {
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
            onTap: () => widget.onTap!(),
            leading: const Icon(Icons.wallpaper),
            title: const Text('Wallpaper Mode'),
          ),
        ),
        PopupMenuItem<Menu>(
          value: Menu.systemSettings,
          child: ListTile(
            onTap: () => widget.openSettingsApp(),
            leading: const Icon(Icons.settings),
            title: const Text('System Settings'),
          ),
        ),
        PopupMenuItem<Menu>(
          value: Menu.appListReload,
          child: ListTile(
            onTap: widget.reload,
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
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
