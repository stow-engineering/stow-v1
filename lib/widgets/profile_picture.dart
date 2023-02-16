import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/auth/auth_events.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<AuthBloc>(context);

    String userInitials = "";
    if (userBloc.state.firstname != null) {
      if (userBloc.state.firstname!.isNotEmpty) {
        userInitials += userBloc.state.firstname![0];
      }
    }
    if (userBloc.state.lastname != null) {
      if (userBloc.state.lastname!.isNotEmpty) {
        userInitials += userBloc.state.lastname![0];
      }
    }

    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: CircularProfileAvatar(
          userBloc.state.profilePicUrl ?? "",
          radius: 100,
          backgroundColor: Colors.transparent,
          borderWidth: 5,
          initialsText: Text(
            userInitials,
            style: const TextStyle(fontSize: 40, color: Colors.white),
          ),
          borderColor: Colors.black,
          elevation: 5.0,
          foregroundColor: Colors.greenAccent.withOpacity(0.5),
          cacheImage: true,
          onTap: () {
            pickUploadImage(userBloc.state.user!.uid, context);
          },
        ),
      ),
    );
  }

  void pickUploadImage(String uid, BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      String profilePicId = "profilepic" + uid;

      Reference ref = FirebaseStorage.instance.ref().child(profilePicId);

      await ref.putFile(File(image!.path));
      ref.getDownloadURL().then((value) {
        print(value);
        BlocProvider.of<AuthBloc>(context)
            .add(UpdateProfilePicEvent(profilePic: value));
      });
    } catch (e) {
      if (e is PlatformException) {
        openAppSettings();
      }
      print(e);
    }
  }
}
