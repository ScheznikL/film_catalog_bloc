import 'package:flutter/material.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Theme.of(context).primaryColorDark,
      width: double.infinity,
      height: 200,
      // padding: EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1634896941598-b6b500a502a7?q=80&w=1956&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeatX),
            ),
          ),
          Text(
            "Name",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
