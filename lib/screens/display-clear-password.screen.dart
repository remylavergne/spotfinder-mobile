import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/dto/update-password.dto.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/feed.screen.dart';
import 'package:spotfinder/string-methods.dart';
import 'package:spotfinder/widgets/application-title.dart';
import 'package:spotfinder/widgets/bottom-action-button.dart';

class ClearPasswordScreen extends StatefulWidget {
  static String route = '/display-clear-password';

  final String clearPassword;

  ClearPasswordScreen({Key key, @required this.clearPassword})
      : super(key: key);

  @override
  _ClearPasswordScreenState createState() => _ClearPasswordScreenState();
}

class _ClearPasswordScreenState extends State<ClearPasswordScreen> {
  bool copied = false;

  // Change password
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _currentPasswordCtrl;
  TextEditingController _newPasswordCtrl = new TextEditingController();
  TextEditingController _newPasswordVerificationCtrl =
      new TextEditingController();
  bool _passwordLoading = false;
  bool _updateCallback = false;
  Text _updateCallbackText;
  Function(void Function() p1) _passwordDialogState;
  String userId;

  @override
  void initState() {
    SharedPrefsHelper.instance.getId().then((String id) => this.userId = id);
    this._currentPasswordCtrl =
        new TextEditingController(text: widget.clearPassword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFE5E5E5),
        child: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: ApplicationTitle(
                  title: S.of(context).appTitle,
                  size: 100.0,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      S.current.accountCreatedTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Text(
                        S.current.clearPasswordExplanation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    new ClipboardData(text: this.widget.clearPassword),
                  );
                  setState(() {
                    this.copied = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        this.widget.clearPassword,
                        style: TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Visibility(
                        visible: !this.copied,
                        child: Text(
                          S.current.clickToCopy,
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      Visibility(
                        visible: this.copied,
                        child: Text(
                          S.current.copy,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    this._changeCurrentPassword(context, this.userId);
                  },
                  child: Text(S.of(context).setMyOwnPassword)),
            ],
          ),
          BottomActionButton(
            parentContext: context,
            text: S.of(context).next,
            onTap: () {
              this._navigateToFeedScreen();
            },
          ),
        ]),
      ),
    );
  }

  void _navigateToFeedScreen() {
    Navigator.pushNamedAndRemoveUntil(
        context, FeedScreen.route, (route) => false);
  }

  void _changeCurrentPassword(BuildContext context, String userId) {
    // Open Popup
    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(builder:
          (BuildContext dialogContext, Function(void Function()) dialogState) {
        this._passwordDialogState = dialogState;
        return AlertDialog(
          content: Container(
            child: Form(
              key: this._formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: this._currentPasswordCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    minLines: 1,
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      hintText: capitalize(S.of(context).currentPassword),
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return capitalize(S.of(context).fieldEmptyError);
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 8.0),
                    child: TextFormField(
                      controller: this._newPasswordCtrl,
                      keyboardType: TextInputType.visiblePassword,
                      minLines: 1,
                      maxLines: 1,
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: true,
                        hintText: capitalize(S.of(context).newPassword),
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return capitalize(S.of(context).fieldEmptyError);
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: this._newPasswordVerificationCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: true,
                      hintText: capitalize(S.of(context).newPassword),
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return capitalize(S.of(context).fieldEmptyError);
                      } else if (value.isNotEmpty &&
                          this._newPasswordCtrl.text.isNotEmpty &&
                          this._newPasswordCtrl.text != value) {
                        return capitalize(S.of(context).passwordDontMatch);
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Visibility(
                      visible: this._passwordLoading,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Visibility(
                      visible: this._updateCallback,
                      child: Center(
                        child: this._updateCallbackText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                this.clearPasswordDialog();
              },
              child: Text(capitalize(S.of(context).closeGeneric)),
            ),
            FlatButton(
              onPressed: () {
                if (this._formKey.currentState.validate()) {
                  this.setPasswordLoading(true);
                  String currentPassword = this._currentPasswordCtrl.text;
                  String newPassword = this._newPasswordCtrl.text;
                  Repository()
                      .updateUserPassword(new UpdatePassword(
                          userId, currentPassword, newPassword))
                      .then((bool success) async {
                    this.setPasswordLoading(false);
                    if (success) {
                      this.setDisplayPasswordUpdateResult(success, true);
                      await Future.delayed(Duration(seconds: 3)).then((_) {
                        Navigator.of(context).pop();
                        this.clearPasswordDialog();
                        this._navigateToFeedScreen();
                      });
                    } else {
                      this.setDisplayPasswordUpdateResult(success, true);
                      await Future.delayed(Duration(seconds: 3)).then((_) {
                        this.setRemoveUpdatePasswordError();
                      });
                    }
                  });
                }
              },
              child: Text(capitalize(S.of(context).changeGeneric)),
            ),
          ],
        );
      }),
      barrierDismissible: false,
    );
  }

  void setPasswordLoading(bool state) {
    this._passwordDialogState(() {
      this._passwordLoading = state;
    });
  }

  void setDisplayPasswordUpdateResult(bool success, bool display) {
    this._passwordDialogState(() {
      this._updateCallbackText = success
          ? Text(
              capitalize(S.of(context).genericSuccess),
              style: TextStyle(color: Colors.green),
            )
          : Text(
              capitalize(S.of(context).genericError),
              style: TextStyle(color: Colors.red),
            );
      this._updateCallback = display;
    });
  }

  void setRemoveUpdatePasswordError() {
    this._passwordDialogState(() {
      this._updateCallback = false;
    });
  }

  void clearPasswordDialog() {
    // this._currentPasswordCtrl.clear();
    this._newPasswordCtrl.clear();
    this._newPasswordVerificationCtrl.clear();
    this._passwordLoading = false;
    this._updateCallback = false;
    this._updateCallbackText = null;
  }
}
