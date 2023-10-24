// ignore: unused_import

import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  AuthService authService = AuthService();
  String userName;
  String email;
  ProfilePage({super.key, required this.email, required this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('ប្រវត្តរូប'),
        centerTitle: true,
      ),
      drawer: Drawer(
          backgroundColor: Theme.of(context).primaryColor,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: [
              const Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 15),
              Text(
                widget.userName,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                height: 2,
              ),
              ListTile(
                  onTap: () {
                    nextScreen(context, const HomePage());
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 5,
                  ),
                  leading: const Icon(
                    Icons.group,
                    color: Colors.white,
                  ),
                  title: const Text('ក្រុម',
                      style: TextStyle(color: Colors.white))),
              ListTile(
                  onTap: () {},
                  selected: true,
                  selectedColor: Colors.redAccent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 5,
                  ),
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('ប្រវត្តរូប',
                      style: TextStyle(color: Colors.white))),
              ListTile(
                  onTap: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content:
                                const Text('are you sure you want to logout?'),
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    await authService.sigout();
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                        (context) => false);
                                  },
                                  icon: const Icon(
                                    Icons.done,
                                    color: Colors.blue,
                                  ))
                            ],
                          );
                        });
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 5,
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: const Text('ចាកចេញពីគណនី',
                      style: TextStyle(color: Colors.white)))
            ],
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.person,
            size: 200,
            color: Colors.white,
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Full Name',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 15,
          // ),
          const Divider(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Email Adrresses',
                   style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.email,
                   style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
