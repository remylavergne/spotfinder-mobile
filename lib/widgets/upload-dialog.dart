import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/generated/l10n.dart';

class UploadDialog {
  BuildContext context;
  String text;
  void Function(void Function()) _dialogState;
  String _alertDialogContent;

  UploadDialog(BuildContext context, String text) {
    this.context = context;
    this._alertDialogContent = text;
  }

  UploadDialog show() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) =>
          StatefulBuilder(builder: (dialogContext, setState) {
        this._dialogState = setState;
        AlertDialog alertDialog = new AlertDialog(
          title: Center(
            child: Text(S.current.addPhoto),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  this._alertDialogContent,
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        );

        return alertDialog;
      }),
    );

    return this;
  }

  void updateText(String text) {
    this._dialogState(() {
      this._alertDialogContent = text;
    });
  }
}
