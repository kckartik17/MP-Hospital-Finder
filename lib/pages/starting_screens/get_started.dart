import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hospital_finder/pages/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignInAccount _currentUser;
  FirebaseUser firebaseUser;

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      setState(() {
        _currentUser = account;
      });
    });

    _googleSignIn.signInSilently(suppressErrors: false).then((account) {
      _signIn(account);
    }).catchError((dynamic onError) {
      print(onError.toString());
    });
  }

  Future<void> _signIn(GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    setState(() {
      firebaseUser = user;
    });
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      _signIn(googleUser);
    } catch (error) {
      print("Cancelled");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    return Scaffold(
        backgroundColor: Color(0xFF3750b2),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              top: size.height * 0.1,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 300,
                    child: Image.asset("assets/images/doctors_banner.png"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Find your hospital !",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    "Now it's so easy to find a hospital in an emergency",
                    maxLines: 2,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        color: Colors.white24),
                  ),
                  SizedBox(height: 30),
                  FlipCard(
                    key: cardKey,
                    flipOnTouch: false,
                    front: Center(
                      child: RaisedButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        color: Colors.blue[800],
                        onPressed: () {
                          cardKey.currentState.toggleCard();
                        },
                        shape: StadiumBorder(),
                        child: Text(
                          "Get Started",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    back: Center(
                      child: Column(
                        children: <Widget>[
                          GoogleSignInButton(
                            onPressed: () async {
                              _handleSignIn().whenComplete(() async {
                                prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('seen', true);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Dashboard()));
                              });
                            },
                            borderRadius: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "or",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () async {
                              prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('seen', true);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Dashboard()));
                            },
                            child: Text(
                              "Continue as a guest",
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
