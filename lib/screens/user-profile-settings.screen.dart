import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/enums/camera-type.enum.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/camera.helper.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/dto/update-password.dto.dart';
import 'package:spotfinder/models/user.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/create-account.screen.dart';
import 'package:spotfinder/screens/take-picture.screen.dart';
import 'package:spotfinder/string-methods.dart';

class UserProfileSettingsScreen extends StatefulWidget {
  static final String route = '/user-settings';

  final User user;

  UserProfileSettingsScreen({Key key, @required this.user}) : super(key: key);

  @override
  _UserProfileSettingsScreenState createState() =>
      _UserProfileSettingsScreenState();
}

class _UserProfileSettingsScreenState extends State<UserProfileSettingsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _currentPasswordCtrl = new TextEditingController();
  TextEditingController _newPasswordCtrl = new TextEditingController();
  TextEditingController _newPasswordVerificationCtrl =
      new TextEditingController();
  bool _passwordLoading = false;
  bool _updateCallback = false;
  Text _updateCallbackText;
  Function(void Function() p1) _passwordDialogState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        backgroundColor: Color(0xFF011627),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () {
                this._openTakePictureScreen(context);
              },
              child: Text(
                S.of(context).addProfilePicture,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                this._changeCurrentPassword(context, this.widget.user);
              },
              child: Text(
                S.of(context).changePassword,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlatButton(
                onPressed: () {
                  SharedPrefsHelper.instance.logout().then((value) =>
                      Navigator.pushNamedAndRemoveUntil(context,
                          CreateAccountScreen.route, (route) => false));
                },
                child: Text(
                  capitalize(S.of(context).logout),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// Navigation
  ///
  ///

  void _openTakePictureScreen(BuildContext context) {
    CameraHelper.instance.canUse().then((bool canUse) {
      if (canUse) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TakePictureScreen(
              takePictureFor: TakePictureFor.USER_PROFILE,
              position: Position(),
              cameraLocation: CameraLocation.FRONT,
            ),
          ),
        );
      } else {
        this.showDialogOpenSettings(
          context,
          Text(S.current.permissionDialogTitle),
          Text(S.current.cameraPermissionMandatory),
        );
      }
    });
  }

  void showDialogOpenSettings(
      BuildContext context, Widget title, Widget message) {
    showDialog(
        builder: (_) => AlertDialog(
              title: title,
              content: message,
              actions: [
                FlatButton(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                  },
                  child: Text(S.current.openSettings),
                ),
                FlatButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: Text(S.current.okay),
                ),
              ],
            ),
        barrierDismissible: false,
        context: context);
  }

  void _changeCurrentPassword(BuildContext context, User user) {
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
                          user.id, currentPassword, newPassword))
                      .then((bool success) async {
                    this.setPasswordLoading(false);
                    if (success) {
                      this.setDisplayPasswordUpdateResult(success, true);
                      await Future.delayed(Duration(seconds: 3)).then((_) {
                        Navigator.of(context).pop();
                        this.clearPasswordDialog();
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
    this._currentPasswordCtrl.clear();
    this._newPasswordCtrl.clear();
    this._newPasswordVerificationCtrl.clear();
    this._passwordLoading = false;
    this._updateCallback = false;
    this._updateCallbackText = null;
  }
}
