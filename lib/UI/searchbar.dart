import 'dart:ui';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_launcher/main.dart';

class AppSearchBar extends StatefulWidget {
  final void Function()? changeBackground;
  final void Function()? getApplications;
  final void Function(List) onSearchListChanged; 

  final List sortedApps;
  const AppSearchBar(
      {super.key,
      required this.changeBackground,
      required this.getApplications,
      required this.sortedApps, required this.onSearchListChanged});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController searchBarTextController = TextEditingController();
  List searchList = [];

  void searchResult(String query) {
    query = query.trim();
    if (query.isNotEmpty) {
      searchList = widget.sortedApps
          .where((application) => application.appName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    } else {
      searchList = widget.sortedApps;
    }
    widget.onSearchListChanged(searchList);
  }

  openSettingsApp() {
    setState(() {
      DeviceApps.openApp('com.android.settings');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchBarTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRRect(
        child: Builder(builder: (context) {
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
              onChanged: (value) => searchResult(value),
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
                    onTap: () => setState(() {
                          searchList = widget.sortedApps;
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
                  onTap: widget.changeBackground,
                  reload: widget.getApplications,
                  openSettingsApp: openSettingsApp,
                )
              ],
            ),
          ),
        );
      })),
    );
  }
}
