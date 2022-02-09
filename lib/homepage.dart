import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  Map userObj = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: isLoggedIn
                ? Column(
                    children: [
                      // Image.network(userObj["picture"]["data"]["url"]),
                      Text(userObj['name']),
                      Text(userObj['email']),
                      TextButton(
                          onPressed: () {
                            FacebookAuth.instance.logOut().then((value) {
                              setState(() {
                                isLoggedIn = false;
                                userObj = {};
                              });
                            });
                          },
                          child: Text('Logout')),
                    ],
                  )
                : Center(
                    child: ElevatedButton(
                        child: Text('Login with Facebook'),
                        onPressed: () async {
                          final result = await FacebookAuth.instance
                              .login(permissions: ["public_profile", "email"]);
                          print(result.status);

                          if (result.status == LoginStatus.success) {
                            final userData =
                                await FacebookAuth.instance.getUserData(
                              fields: "email,name",
                            );

                            setState(() {
                              userObj = userData;
                              isLoggedIn = true;
                            });
                          }
                        }),
                  ),
          ),
        ),
      ),
    );
  }
}
