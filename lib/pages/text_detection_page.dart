import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/text_detection_bloc.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/widgets/primary_button_view.dart';

class TextDetectionPage extends StatelessWidget {
  const TextDetectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TextDetectionBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.chevron_left),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<TextDetectionBloc>(
                  builder: (context, bloc, child) => Visibility(
                    visible: bloc.chosenImageFile != null,
                    child: Image.file(
                      bloc.chosenImageFile ?? File("path"),
                      height: 300,
                      width: 300,
                    ),
                  ),
                ),
                const SizedBox(height: MARGIN_LARGE,),
                Consumer<TextDetectionBloc>(
                  builder: (context, bloc, child) => GestureDetector(
                    onTap: (){
                      ImagePicker().pickImage(source: ImageSource.gallery).then((value) async{
                        var bytes = await value?.readAsBytes();
                        bloc.onImageChosen(File(value?.path ?? ""), bytes ?? Uint8List(0));
                      }).catchError((error){
                        print("error");
                      });
                    },
                    child: const PrimaryButtonView(label: "Choose Image",),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
