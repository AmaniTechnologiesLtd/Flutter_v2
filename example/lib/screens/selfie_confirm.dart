import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelfieConfirm extends StatelessWidget {
  const SelfieConfirm({super.key});

  static const routeName = '/selfie-confirm';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ConfirmArgs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Confirm"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.memory(
            args.image,
            fit: BoxFit.contain,
            width: double.infinity,
            height: 450,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  child: const Text("Retry")),
              OutlinedButton(
                  onPressed: (() {
                    args.onUploadPressed.call(context);
                  }),
                  child: Text(args.uploadButtonText))
            ],
          )
        ],
      ),
    );
  }
}

class ConfirmArgs {
  Uint8List image;
  Function(BuildContext) onUploadPressed;
  String uploadButtonText;

  ConfirmArgs(
    this.image,
    this.onUploadPressed,
    this.uploadButtonText,
  );
}
