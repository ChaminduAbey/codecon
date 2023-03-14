import 'package:client_app/api_endpoints.dart';
import 'package:client_app/main.dart';
import 'package:client_app/screens/splash_screen.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/view_state_mixin.dart';
import 'package:client_app/views/constrained_button_view.dart';
import 'package:client_app/views/image_widget.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/http_service.dart';
import '../services/user_service.dart';
import '../theme.dart';
import '../views/busy_error_child_view.dart';

class SelectLoginUserScreen extends StatefulWidget {
  const SelectLoginUserScreen({Key? key}) : super(key: key);

  @override
  State<SelectLoginUserScreen> createState() => _SelectLoginUserScreenState();
}

class _SelectLoginUserScreenState extends State<SelectLoginUserScreen> {
  late Future<List<User>> usersFuture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      usersFuture = getIt<HttpService>().getList(
          url: ApiEndpoints().getUsers(),
          fromJson: (json) => User.fromJson(json));

      usersFuture.catchError((value) => print(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBGColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
              tag: "primary-logo",
              child: Image.asset("assets/graphics/logo.png")),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ConstrainedButton(
              child: ElevatedButton(
                  onPressed: () => _showBottomSheet(),
                  child: Text("Select User")),
            ),
          )
        ],
      ),
    );
  }

  // show bottom sheet
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            child:
                _UserListView(usersFuture: usersFuture, loginUser: loginUser),
          );
        });
  }

  Future<void> loginUser(User user) async {
    try {
      await getIt<UserService>().signInUser(userId: user.id);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SplashScreen()));
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }
}

class _UserListView extends StatefulWidget {
  final Future<List<User>> usersFuture;
  final Function(User) loginUser;
  const _UserListView(
      {Key? key, required this.usersFuture, required this.loginUser})
      : super(key: key);

  @override
  State<_UserListView> createState() => __UserListViewState();
}

class __UserListViewState extends State<_UserListView> with ViewStateMixin {
  late List<User> users;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        setBusy();

        users = await widget.usersFuture;

        setIdle();
      } catch (ex) {
        setError();
        rethrow;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BusyErrorChildView(
        viewState: viewState,
        builder: () => ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: ImageWidget(
                        imageUrl: users[index].photo!.url,
                        blurhash: users[index].photo!.blurhash),
                  ),
                ),
                title:
                    Text("${users[index].firstName} ${users[index].lastName}"),
                subtitle: Text(users[index].email),
                onTap: () {
                  Navigator.pop(context);
                  widget.loginUser(users[index]);
                },
              );
            }));
  }
}
