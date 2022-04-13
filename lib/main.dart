import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isLoading = false;
  var isdone = false;
  var button_text = 'Load';
  var w = 200.0;
  UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: InkWell(
            onTap: () async {
              if (!isLoading)
                setState(() {
                  isLoading = true;
                  w = 50;
                });

              user = await MyInfo.GetMoethod();
              await Future.delayed(Duration(seconds: 1));

              setState(() {
                isLoading = false;
                w = 200;
                button_text = "Reload";
              });
              setState(() => isdone = true);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                user != null
                    ? Expanded(child: My_github_info(user!))
                    : SizedBox.shrink(),
                Container(
                  height: 150,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    height: 50,
                    width: w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25)),
                    duration: Duration(milliseconds: 600),
                    child: isLoading
                        ? Container(
                            padding: const EdgeInsets.all(12.0),
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(button_text),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget My_github_info(UserModel u) => Column(
        children: [
          text_builder("Login", u.login),
          text_builder("Name", u.name),
          text_builder("Public_repos", u.public_repos.toString()),
          text_builder("Followers", u.followers.toString()),
          text_builder("Following", u.following.toString()),
        ],
      );

  Widget text_builder(String s1, String s2) => Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: s1 + " = ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    letterSpacing: .5,
                    fontWeight: FontWeight.w900)),
            TextSpan(
                text: s2,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    letterSpacing: .5,
                    fontWeight: FontWeight.bold)),
          ]),
        ),
      );
}

class UserModel {
  var login;
  String name;
  int public_repos;
  int followers;
  int following;

  UserModel.Fromjson(dynamic json)
      : login = json['login'],
        name = json['name'],
        public_repos = json['public_repos'],
        followers = json['followers'],
        following = json['following'];
}

class MyInfo {
  static Future<UserModel> GetMoethod() async {
    var url = Uri.parse('https://api.github.com/users/NuriddinJorayev');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return UserModel.Fromjson(jsonDecode(response.body));
  }
}
