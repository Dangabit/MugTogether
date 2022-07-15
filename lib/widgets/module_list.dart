import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mug_together/widgets/data.dart';
import 'package:dropdown_search2/dropdown_search2.dart';

class ModuleList {
  static late List<String> modList;

  /// Initialise a static modList to be used for all Dropdown search
  static Future<void> init() async {
    _getModuleList().then((list) {
      modList = list;
    });
  }

  /// Grabs a list of modules from nusmods
  static Future<List<String>> _getModuleList() async {
    return http
        .get(Uri.parse("https://api.nusmods.com/v2/2021-2022/moduleList.json"))
        .then<List>((response) {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return List.empty() as List<String>;
      }
    }).then<List<String>>((list) {
      return list.map<String>((modMap) => modMap["moduleCode"]).toList();
    });
  }

  /// Creates a Dropdown searchable widget
  static Widget createListing(Data currentValue) {
    return DropdownSearch(
      validator: (value) => value == null ? "Field required" : null,
      dropdownSearchDecoration: const InputDecoration(
        hintText: "Select Module",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        constraints: BoxConstraints(
          maxWidth: 180.0,
        ),
      ),
      mode: Mode.MENU,
      showSearchBox: true,
      showSelectedItems: true,
      items: modList,
      maxHeight: 250,
      dropdownSearchBaseStyle: const TextStyle(
        color: Colors.white,
      ),
      onChanged: (String? newValue) {
        currentValue.text = newValue;
      },
    );
  }
}
