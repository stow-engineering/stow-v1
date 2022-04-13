import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database.dart';
import 'user_auth.dart';
import 'container.dart' as customContainer;

class Register extends StatefulWidget {
  const Register({Key? key, required this.mac}) : super(key: key);

  final String mac;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _nameController = TextEditingController();
  String _name = '';
  String _user = '';
  DatabaseService service = DatabaseService("");

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Device"),
        actions: [],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildNameField(),
            ElevatedButton(
                onPressed: () {
                  service.updateContainerName(widget.mac, _name);
                },
                child: const Text("Enter")),
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    // 1
    return Column(
      // 2
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 3
        Text(
          'Item Name',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        // 4
        TextField(
          // 5
          controller: _nameController,
          // 7
          decoration: InputDecoration(
            // 8
            hintText: 'E.g. Apples, Banana, 1 Bag of salt',
            // 9
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
