import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:s_launcher/UI/app_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
 

  @override
  void initState() {
    super.initState();
    getApplications();
    if (sortedApps.isNotEmpty) {
      sortApps(applications);
    }
  }

   @override
  void dispose() {
    // TODO: implement dispose
    getApplications();
    sortApps(applications);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
             const Text('Hi Shoaib! :)', style:  TextStyle(fontSize: 30, color: Colors.white),),
              const SizedBox(height: 10.0,),
              loading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Flexible(child: SingleChildScrollView(child: AppDrawer(sortedApps:sortedApps, sortApps: sortApps(applications), applications: applications,)))
            ],
          ),
        ),
      ),
    );
  }
}




