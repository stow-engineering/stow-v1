import 'package:flutter/material.dart';

import '../../models/user.dart';

class AccountPage extends StatefulWidget {
  final StowUser user;
  const AccountPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
