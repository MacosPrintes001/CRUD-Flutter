import 'package:flutter/material.dart';
import 'package:flutter_crud/views/home.dart';
import 'package:flutter_crud/views/login.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        verificaUsuario().then((temUsuario) {
          if (temUsuario) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            //mandar usuario logar
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LoginPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/animations/secure.json",
              onLoaded: (composition) {
                // A animação foi carregada, comece a reproduzi-la
                _controller.duration = composition.duration;
                _controller.forward();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> verificaUsuario() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? repeat = prefs.getBool('repeat');

  if (repeat == false || repeat == null) {
    return false;
  } else {
    return true;
  }
}
