import 'package:chat_app/helper/helper_funtion.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authservice = AuthService();
  Stream? groups;
  // ignore: prefer_final_fields
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  //manipulation methods
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFuntions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFuntions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    //getting the list snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      groups = snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'ក្រុម',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
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
                userName,
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
                  selected: true,
                  selectedColor: Colors.red,
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
                  onTap: () {
                    nextScreen(
                        context,
                        ProfilePage(
                          userName: userName,
                          email: email,
                        ));
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 5,
                  ),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
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
                                const Text('Are you sure you want to logout?'),
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
                                    await authservice.sigout();
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          popUpDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              title: const Text(
                'បង្កើតក្រុម​',
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : TextField(
                          onChanged: (value) => {groupName = value},
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ignore: unnecessary_null_comparison
                    if (groupName != null) {
                      setState(() {
                        _isLoading = true;
                      });
                    }
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .creatGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                    showSnackBar(
                        context, Colors.blue, "ក្រុមត្រូវបានបង្កើតដោយជោគជ័យ");
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Create'),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
        //make some check to make sure
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: ((context, index) {
                    int resersIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        groupId: getId(snapshot.data['groups'][resersIndex]),
                        userName: snapshot.data['fullName'],
                        groupName:
                            getName(snapshot.data['groups'][resersIndex]));
                  }),
                );
              } else {
                noGroupWidget();
              }
            } else {
              noGroupWidget();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          return noGroupWidget();
        });
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => popUpDialog(context),
              child: const Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "អ្នកមិនបានចូលក្រុមណាមួយទេ ចុចបូតុង add ដើម្បីបង្កើតក្រុម",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ]),
    );
  }
}
