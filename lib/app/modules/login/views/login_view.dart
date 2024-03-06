import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frame/app/routes/app_pages.dart';
import 'package:frame/app/utils/local_icons.dart';
import 'package:frame/app/utils/re_used_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  final _formkey = GlobalKey<FormState>();
  final loginc = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: buildstaticImageWidget(100, LocalIcons.login),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formkey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Obx(() {
                            return TextFormField(
                              controller: loginc.emailController.value,
                              onChanged: (value) {
                                loginc.emailController.refresh();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email address';
                                }
                                if (!RegExp(
                                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                labelText: 'Enter Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                ),
                                errorStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9.0),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Obx(() {
                              return TextFormField(
                                controller: loginc.passwordController.value,
                                onChanged: (value) {
                                  loginc.passwordController.refresh();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 8) {
                                    return "Password must be at least 8 characters";
                                  } else if (!RegExp(
                                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}|:;<>,.?~\\-]).{8,}$')
                                      .hasMatch(value)) {
                                    return "Contain at least one special character, one uppercase letter, and one digit";
                                  }
                                  return null;
                                },
                                obscureText: loginc.isVisible.value,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  labelText: 'Password',
                                  prefixIcon: const Icon(
                                    Icons.key,
                                    color: Colors.green,
                                  ),
                                  suffixIcon: Obx(() => IconButton(
                                        splashRadius: 20,
                                        onPressed: () {
                                          loginc.toggleVisibility();
                                        },
                                        icon: loginc.isVisible.value
                                            ? const Icon(
                                                Icons.visibility_off_outlined)
                                            : const Icon(
                                                Icons.visibility_outlined,
                                              ),
                                      )),
                                  errorStyle: const TextStyle(fontSize: 18.0),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.0)),
                                  ),
                                ),
                              );
                            })),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(180, 0, 0, 0),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forget Password!',
                              style: GoogleFonts.comfortaa(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Obx(() {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: loginc.emailController
                                                .value.text.isNotEmpty &&
                                            loginc.passwordController.value.text
                                                .isNotEmpty
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  onPressed: loginc.emailController.value.text
                                              .isNotEmpty &&
                                          loginc.passwordController.value.text
                                              .isNotEmpty
                                      ? () async {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            if (!loginc.isLoading.value) {
                                              bool? result =
                                                  await controller.login();
                                              if (result == true) {
                                                Get.toNamed(Routes.HOME);
                                              }
                                            }
                                          }
                                        }
                                      : null,
                                  child: loginc.isLoading.isFalse
                                      ? Text(
                                          'Login',
                                          style: createCustomTextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        )
                                      : const CircularProgressIndicator(
                                          color: Colors.amberAccent,
                                        ),
                                );
                              })),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                User? user = await loginc.signInWithGoogle();
                                if (user != null) {
                                  Get.toNamed(Routes.HOME);
                                } else {
                                  Get.snackbar('Google Sign-In',
                                      'Failed to sign in with Google');
                                  if (kDebugMode) {
                                    print('Google Sign-In Failed');
                                  }
                                }
                              },
                              icon:
                                  buildstaticImageWidget(40, LocalIcons.google),
                            ),
                            const SizedBox(width: 20),
                            IgnorePointer(
                              ignoring: true,
                              child: ColorFiltered(
                                colorFilter:
                                    const ColorFilter.linearToSrgbGamma(),
                                child: buildstaticImageWidget(
                                    40, LocalIcons.facebook),
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
