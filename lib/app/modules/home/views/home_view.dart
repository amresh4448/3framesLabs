import 'package:flutter/material.dart';
import 'package:frame/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
   HomeView({Key? key}) : super(key: key);
  final loginc = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
    loginc.signOut().then((value) {
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar("logout", "Succesflly Logout");
    });

    },
    icon: Icon(Icons.logout, color:  Colors.redAccent,))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           CircleAvatar(
             radius: 30,
             backgroundImage: NetworkImage(loginc.imageUrl.value),
           ),
            Text(
              "${loginc.Username}",
              style: const  TextStyle(fontSize: 20),
            ),
            Text(
              "${loginc.email}",
              style: const TextStyle(fontSize: 20),
            )
          ],
        )
      ),
    );
  }
}
