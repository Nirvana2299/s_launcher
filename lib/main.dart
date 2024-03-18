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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hi Shoaib! :)',
                style: TextStyle(fontSize: 30, color: Colors.white),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 5.0,
              ),
              SearchBar(
                controller: searchBarTextController,
                textStyle: const MaterialStatePropertyAll(TextStyle(color: Colors.white)),
                backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(70, 0, 0, 0)),
                onChanged: (value) => searchResult(value),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),),
                hintText: 'Search Apps',
                padding: const MaterialStatePropertyAll(EdgeInsets.all(10.0)),
                side: MaterialStatePropertyAll(BorderSide(color: Colors.grey.shade500, width: 2.0)),
                hintStyle: const MaterialStatePropertyAll(TextStyle(color: Colors.white54, fontSize: 18.0)),
                leading: const Icon(Icons.search, color: Colors.white70,),
                trailing: [GestureDetector(onTap: () => setState(() {
                  searchList = sortedApps;
                  searchBarTextController.clear();
                }), child: const Icon(Icons.cancel, color: Colors.white70,))],
              ),
              const SizedBox(
                height: 10.0,
              ),
              loading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Flexible(
                      child: CupertinoScrollbar(
                        controller: firstController,
                        child: SingleChildScrollView(
                          // controller: firstController,
                          child: AppDrawer(
                            sortedApps: searchList.isNotEmpty ? searchList : sortedApps,
                            applications: searchList.isNotEmpty
                                ? searchList
                                : applications,
                            scrollController: firstController,
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
