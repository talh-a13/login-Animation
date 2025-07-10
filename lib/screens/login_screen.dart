import 'dart:math';
import 'package:animated_switch_login/components/wave_clipper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../components/tri_clipper.dart';
import '../widgets/feild.dart';
import '../widgets/login_door_widget.dart';
import '../widgets/signin_door_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late final AnimationController loginController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final AnimationController signUpController2 = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final AnimationController textController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final AnimationController formController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );
  late final AnimationController backgroundController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  );
  late final AnimationController welcomeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );
  late final AnimationController subtitleController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  // Animations
  late final Animation<double> formSlideAnimation;
  late final Animation<double> formFadeAnimation;
  late final Animation<double> backgroundRotation;
  late final Animation<double> welcomeSlideAnimation;
  late final Animation<double> welcomeFadeAnimation;
  late final Animation<double> welcomeScaleAnimation;
  late final Animation<double> subtitleSlideAnimation;
  late final Animation<double> subtitleFadeAnimation;

  bool isLogin = true;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    formSlideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: formController,
      curve: Curves.elasticOut,
    ));

    formFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: formController,
      curve: Curves.easeInOut,
    ));

    backgroundRotation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(backgroundController);

    // Enhanced welcome animations
    welcomeSlideAnimation = Tween<double>(
      begin: -80.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: welcomeController,
      curve: Curves.elasticOut,
    ));

    welcomeFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: welcomeController,
      curve: Curves.easeIn,
    ));

    welcomeScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: welcomeController,
      curve: Curves.bounceOut,
    ));

    // Subtitle animations
    subtitleSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: subtitleController,
      curve: Curves.easeOutBack,
    ));

    subtitleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: subtitleController,
      curve: Curves.easeIn,
    ));

    // Start initial animations
    signUpController2.forward();
    _startInitialAnimations();
  }

  void _startInitialAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    welcomeController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    subtitleController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    formController.forward();
    backgroundController.repeat();
  }

  @override
  void dispose() {
    loginController.dispose();
    signUpController2.dispose();
    textController.dispose();
    formController.dispose();
    backgroundController.dispose();
    welcomeController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  void _handleSwitch() async {
    if (isAnimating) return;

    setState(() {
      isAnimating = true;
    });

    // Animate subtitle change
    await subtitleController.reverse();

    if (isLogin) {
      await Future.wait([
        loginController.forward(),
        signUpController2.reverse(),
        textController.forward(),
      ]);
    } else {
      await Future.wait([
        loginController.reverse(),
        signUpController2.forward(),
        textController.reverse(),
      ]);
    }

    setState(() {
      isLogin = !isLogin;
      isAnimating = false;
    });

    // Animate subtitle back in
    subtitleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffEDE9FE),
              Color(0xffF3E8FF),
              Color(0xffFAF5FF),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            AnimatedBuilder(
              animation: backgroundRotation,
              builder: (context, child) {
                return Positioned(
                  top: -100,
                  right: -100,
                  child: Transform.rotate(
                    angle: backgroundRotation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.purple.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: backgroundRotation,
              builder: (context, child) {
                return Positioned(
                  bottom: -150,
                  left: -150,
                  child: Transform.rotate(
                    angle: -backgroundRotation.value * 0.7,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.blue.withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Main content
            AnimatedBuilder(
              animation: Listenable.merge([
                formSlideAnimation,
                formFadeAnimation,
                welcomeSlideAnimation,
                welcomeFadeAnimation,
                welcomeScaleAnimation,
                subtitleSlideAnimation,
                subtitleFadeAnimation,
              ]),
              builder: (context, child) {
                return Column(
                  children: [
                    const Spacer(),

                    // Enhanced Welcome Section - No Icon
                    Column(
                      children: [
                        // Main welcome text with enhanced animations
                        Transform.translate(
                          offset: Offset(0, welcomeSlideAnimation.value),
                          child: Transform.scale(
                            scale: welcomeScaleAnimation.value,
                            child: Opacity(
                              opacity: welcomeFadeAnimation.value,
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xff667eea),
                                    Color(0xff764ba2),
                                    Color(0xfff093fb),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  "Welcome Back!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                        color: Colors.black12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Animated subtitle
                        Transform.translate(
                          offset: Offset(0, subtitleSlideAnimation.value),
                          child: Opacity(
                            opacity: subtitleFadeAnimation.value,
                            child: TweenAnimationBuilder<double>(
                              key: ValueKey(isLogin),
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutBack,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: 0.8 + (0.2 * value),
                                  child: Opacity(
                                    opacity: value,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        isLogin
                                            ? "Sign in to continue"
                                            : "Create your account",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Enhanced Form Section
                    Transform.translate(
                      offset: Offset(0, formSlideAnimation.value),
                      child: Opacity(
                        opacity: formFadeAnimation.value,
                        child: Stack(
                          children: [
                            // Enhanced Login Animation
                            AnimatedBuilder(
                              animation: loginController,
                              builder: (_, child) {
                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(loginController.value * 2),
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const LoginDoorWidget(),
                                  ),
                                );
                              },
                            ),

                            // Enhanced SignUp Animation
                            Align(
                              alignment: Alignment.centerRight,
                              child: AnimatedBuilder(
                                animation: signUpController2,
                                builder: (_, child) {
                                  return Transform(
                                    alignment: Alignment.centerRight,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.001)
                                      ..rotateY(-(signUpController2.value * 2)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: const SignInDoorWidget(),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Enhanced Form Container
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Enhanced Triangle Arrow
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 80),
                                    child: AnimatedAlign(
                                      alignment: isLogin
                                          ? Alignment.topLeft
                                          : Alignment.topRight,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.elasticOut,
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween<double>(begin: 0, end: 1),
                                        duration:
                                            const Duration(milliseconds: 600),
                                        builder: (context, value, child) {
                                          return Transform.scale(
                                            scale: value,
                                            child: ClipPath(
                                              clipper: MyClipper(),
                                              child: Container(
                                                height: 40,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 10,
                                                      offset:
                                                          const Offset(0, 5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  // Enhanced Form Stack
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      // Enhanced Input Fields
                                      Column(
                                        children: [
                                          Container(
                                            height: 320,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  offset: const Offset(0, 15),
                                                  blurRadius: 30,
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Column(
                                              children: [
                                                // Input fields section
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const SizedBox(
                                                              height: 10),

                                                          // Animated Fields
                                                          TweenAnimationBuilder<
                                                              double>(
                                                            tween:
                                                                Tween<double>(
                                                                    begin: 0,
                                                                    end: 1),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        800),
                                                            builder: (context,
                                                                value, child) {
                                                              return Transform
                                                                  .translate(
                                                                offset: Offset(
                                                                    (1 - value) *
                                                                        50,
                                                                    0),
                                                                child: Opacity(
                                                                  opacity:
                                                                      value,
                                                                  child:
                                                                      const Field(
                                                                    hintText:
                                                                        'Email',
                                                                    icon: Icons
                                                                        .mail_outline,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),

                                                          const SizedBox(
                                                              height: 12),

                                                          TweenAnimationBuilder<
                                                              double>(
                                                            tween:
                                                                Tween<double>(
                                                                    begin: 0,
                                                                    end: 1),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1000),
                                                            builder: (context,
                                                                value, child) {
                                                              return Transform
                                                                  .translate(
                                                                offset: Offset(
                                                                    (1 - value) *
                                                                        50,
                                                                    0),
                                                                child: Opacity(
                                                                  opacity:
                                                                      value,
                                                                  child:
                                                                      const Field(
                                                                    hintText:
                                                                        'Password',
                                                                    icon: Icons
                                                                        .lock_outline,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),

                                                          // Additional field for signup
                                                          AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        400),
                                                            height: isLogin
                                                                ? 0
                                                                : 61,
                                                            child:
                                                                AnimatedOpacity(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          400),
                                                              opacity: isLogin
                                                                  ? 0
                                                                  : 1,
                                                              child: !isLogin
                                                                  ? Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              12),
                                                                      child:
                                                                          const Field(
                                                                        hintText:
                                                                            'Confirm Password',
                                                                        icon: Icons
                                                                            .lock_outline,
                                                                      ),
                                                                    )
                                                                  : const SizedBox
                                                                      .shrink(),
                                                            ),
                                                          ),

                                                          const SizedBox(
                                                              height: 10),

                                                          // Forgot password
                                                          SizedBox(
                                                            height: 24,
                                                            child:
                                                                AnimatedOpacity(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          400),
                                                              opacity: isLogin
                                                                  ? 1
                                                                  : 0,
                                                              child: isLogin
                                                                  ? const Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        "Forgot password?",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.deepPurple,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : const SizedBox
                                                                      .shrink(),
                                                            ),
                                                          ),

                                                          const SizedBox(
                                                              height: 15),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                // Enhanced Wave Section
                                                RotatedBox(
                                                  quarterTurns: 2,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    child: ClipPath(
                                                      clipper: BezierClipper(),
                                                      child: Container(
                                                        height: 80,
                                                        width: double.infinity,
                                                        decoration:
                                                            const BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color(0xff667eea),
                                                              Color(0xff764ba2),
                                                              Color(0xfff093fb),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),

                                      // Enhanced Login Button
                                      GestureDetector(
                                        onTap: () {
                                          // Handle login/signup logic
                                        },
                                        child: Container(
                                          height: 55,
                                          width: 140,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xff667eea),
                                                Color(0xff764ba2),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.deepPurple
                                                    .withOpacity(0.3),
                                                blurRadius: 15,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.center,
                                          child: AnimatedBuilder(
                                            animation: textController,
                                            builder: (context, child) {
                                              return Transform(
                                                alignment: Alignment.center,
                                                transform: Matrix4.identity()
                                                  ..setEntry(3, 2, 0.001)
                                                  ..rotateY((textController
                                                              .value <
                                                          0.5)
                                                      ? pi *
                                                          textController.value
                                                      : (pi *
                                                          (1 +
                                                              textController
                                                                  .value))),
                                                child: (textController.value <
                                                        0.5)
                                                    ? const Text(
                                                        "Login",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          letterSpacing: 1.1,
                                                        ),
                                                      )
                                                    : const Text(
                                                        "Sign-Up",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          letterSpacing: 1.1,
                                                        ),
                                                      ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Enhanced Confirmation Section
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1500),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, (1 - value) * 30),
                          child: Opacity(
                            opacity: value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text: isLogin
                                      ? "Don't have an account? "
                                      : "Already have an account? ",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: isLogin ? 'SIGN UP' : "LOG IN",
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = _handleSwitch,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const Spacer(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
