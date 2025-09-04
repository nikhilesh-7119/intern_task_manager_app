import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/controller/auth_controller.dart';
import 'package:task_manager_app/screens/auth_screen/widgets/signinForm.dart';
import 'package:task_manager_app/screens/auth_screen/widgets/signupForm.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  final _loginKey = GlobalKey<FormState>();
  final _signKey = GlobalKey<FormState>();

  static const bg = Color.fromARGB(255, 236, 233, 233);
  static const btnBase = Color.fromARGB(255, 240, 143, 143);

  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final double s = (screen.width / 390).clamp(0.85, 1.25);

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16 * s),
      borderSide: BorderSide(color: Colors.black12.withOpacity(0.15)),
    );

    final fillColor = Colors.white.withOpacity(0.7);
    final cardColor = Colors.white.withOpacity(0.6);
    final btnColor = btnBase.withOpacity(0.25);

    return Scaffold(
      backgroundColor: bg,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20 * s,
                    vertical: 24 * s,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 12 * s),
                            Text(
                              'Welcome',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontSize: 26 * s,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 6 * s),
                            Text(
                              'Sign in to plan your dream wedding',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: const Color.fromARGB(
                                      255,
                                      31,
                                      31,
                                      31,
                                    ),
                                    fontSize: 16 * s,
                                    fontWeight: FontWeight.w400,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: 48 * s),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16 * s),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8 * s,
                            vertical: 4 * s,
                          ),
                          child: TabBar(
                            controller: _tab,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(20 * s),
                            ),
                            labelColor: const Color.fromARGB(
                              255,
                              233,
                              105,
                              105,
                            ),
                            unselectedLabelColor: const Color.fromARGB(
                              255,
                              60,
                              60,
                              60,
                            ),
                            tabs: [
                              Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6 * s,
                                  ),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16 * s),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6 * s,
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 16 * s),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16 * s),

                        // Card container with bounded TabBarView height to avoid layout errors
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16 * s),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16 * s),
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height:
                                  (_tab.index == 0 ? 300 : 300) *
                                  s, // prevents RenderViewport error
                              child: TabBarView(
                                controller: _tab,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  SignInForm(
                                    formKey: _loginKey,
                                    inputBorder: inputBorder,
                                    fillColor: fillColor,
                                    btnColor: btnColor,
                                    scale: s,
                                  ),
                                  SignUpForm(
                                    formKey: _signKey,
                                    inputBorder: inputBorder,
                                    fillColor: fillColor,
                                    btnColor: btnColor,
                                    scale: s,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 14 * s),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
