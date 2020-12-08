// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `SpotFinder`
  String get spotfinder {
    return Intl.message(
      'SpotFinder',
      name: 'spotfinder',
      desc: 'Application name',
      args: [],
    );
  }

  /// `Choisissez un pseudo`
  String get chooseYourUsername {
    return Intl.message(
      'Choisissez un pseudo',
      name: 'chooseYourUsername',
      desc: 'Hint for account creation',
      args: [],
    );
  }

  /// `Please enter your username`
  String get pleaseEnterUsername {
    return Intl.message(
      'Please enter your username',
      name: 'pleaseEnterUsername',
      desc: '',
      args: [],
    );
  }

  /// `This username already exist. Please choose another one.`
  String get usernameAlreadyExists {
    return Intl.message(
      'This username already exist. Please choose another one.',
      name: 'usernameAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `I have an account`
  String get login {
    return Intl.message(
      'I have an account',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get usernameHint {
    return Intl.message(
      'Username',
      name: 'usernameHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your username`
  String get enterUsernameError {
    return Intl.message(
      'Please enter your username',
      name: 'enterUsernameError',
      desc: '',
      args: [],
    );
  }

  /// `Please check your username / password`
  String get loginError {
    return Intl.message(
      'Please check your username / password',
      name: 'loginError',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordHint {
    return Intl.message(
      'Password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get passwordError {
    return Intl.message(
      'Please enter your password',
      name: 'passwordError',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Spot without name`
  String get spotWithoutName {
    return Intl.message(
      'Spot without name',
      name: 'spotWithoutName',
      desc: '',
      args: [],
    );
  }

  /// `Address is being calculated`
  String get addressBeingCalculated {
    return Intl.message(
      'Address is being calculated',
      name: 'addressBeingCalculated',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Type comment here`
  String get typeCommentHint {
    return Intl.message(
      'Type comment here',
      name: 'typeCommentHint',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `No comment yet`
  String get noComment {
    return Intl.message(
      'No comment yet',
      name: 'noComment',
      desc: '',
      args: [],
    );
  }

  /// `Account successfully created!`
  String get accountCreatedTitle {
    return Intl.message(
      'Account successfully created!',
      name: 'accountCreatedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Un mot de passe a été généré pour récupérer votre compte. Vous devez l'avoir si vous voulez vous connecter sur un autre appareil, ou tout simplement récupérer votre compte après une réinstallation.`
  String get clearPasswordExplanation {
    return Intl.message(
      'Un mot de passe a été généré pour récupérer votre compte. Vous devez l\'avoir si vous voulez vous connecter sur un autre appareil, ou tout simplement récupérer votre compte après une réinstallation.',
      name: 'clearPasswordExplanation',
      desc: '',
      args: [],
    );
  }

  /// `Click to copy`
  String get clickToCopy {
    return Intl.message(
      'Click to copy',
      name: 'clickToCopy',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Synchronization in progress...`
  String get synchroInProgress {
    return Intl.message(
      'Synchronization in progress...',
      name: 'synchroInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Create a Spot`
  String get createSpotTitle {
    return Intl.message(
      'Create a Spot',
      name: 'createSpotTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add a picture`
  String get addPictureTitle {
    return Intl.message(
      'Add a picture',
      name: 'addPictureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Spot name (optional)`
  String get spotNameHint {
    return Intl.message(
      'Spot name (optional)',
      name: 'spotNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Creation`
  String get creation {
    return Intl.message(
      'Creation',
      name: 'creation',
      desc: '',
      args: [],
    );
  }

  /// `Picture is being synchronized`
  String get pictureIsBeingSynchronized {
    return Intl.message(
      'Picture is being synchronized',
      name: 'pictureIsBeingSynchronized',
      desc: '',
      args: [],
    );
  }

  /// `Error during creation... Redirection to the main screen.`
  String get errorSpotCreation {
    return Intl.message(
      'Error during creation... Redirection to the main screen.',
      name: 'errorSpotCreation',
      desc: '',
      args: [],
    );
  }

  /// `Successful creation! Automatic redirection.`
  String get spotCreationSuccess {
    return Intl.message(
      'Successful creation! Automatic redirection.',
      name: 'spotCreationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo`
  String get addPhoto {
    return Intl.message(
      'Add a photo',
      name: 'addPhoto',
      desc: '',
      args: [],
    );
  }

  /// `The photo has been added`
  String get addPhotoSuccess {
    return Intl.message(
      'The photo has been added',
      name: 'addPhotoSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error during photo synchronization... Redirection to the main screen.`
  String get errorPhotoUpload {
    return Intl.message(
      'Error during photo synchronization... Redirection to the main screen.',
      name: 'errorPhotoUpload',
      desc: '',
      args: [],
    );
  }

  /// `Newest`
  String get newestTabTitle {
    return Intl.message(
      'Newest',
      name: 'newestTabTitle',
      desc: '',
      args: [],
    );
  }

  /// `Closest`
  String get closestTabTitle {
    return Intl.message(
      'Closest',
      name: 'closestTabTitle',
      desc: '',
      args: [],
    );
  }

  /// `Open settings`
  String get openSettings {
    return Intl.message(
      'Open settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `Okay`
  String get okay {
    return Intl.message(
      'Okay',
      name: 'okay',
      desc: '',
      args: [],
    );
  }

  /// `Error while retrieving Spots...`
  String get errorGetSpots {
    return Intl.message(
      'Error while retrieving Spots...',
      name: 'errorGetSpots',
      desc: '',
      args: [],
    );
  }

  /// `Location permission is mandatory to display closest Spots around you. Please, activate it into application settings.`
  String get errorPermissionNearestSpots {
    return Intl.message(
      'Location permission is mandatory to display closest Spots around you. Please, activate it into application settings.',
      name: 'errorPermissionNearestSpots',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get photoTitle {
    return Intl.message(
      'Photo',
      name: 'photoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photosTitle {
    return Intl.message(
      'Photos',
      name: 'photosTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occured... Please retry.`
  String get errorAndRetry {
    return Intl.message(
      'An error occured... Please retry.',
      name: 'errorAndRetry',
      desc: '',
      args: [],
    );
  }

  /// `Distance: `
  String get distance {
    return Intl.message(
      'Distance: ',
      name: 'distance',
      desc: '',
      args: [],
    );
  }

  /// `Route calculation`
  String get routeCalculation {
    return Intl.message(
      'Route calculation',
      name: 'routeCalculation',
      desc: '',
      args: [],
    );
  }

  /// `Latest photos`
  String get latestPhotos {
    return Intl.message(
      'Latest photos',
      name: 'latestPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Display all`
  String get displayAll {
    return Intl.message(
      'Display all',
      name: 'displayAll',
      desc: '',
      args: [],
    );
  }

  /// `+ Add`
  String get addAction {
    return Intl.message(
      '+ Add',
      name: 'addAction',
      desc: '',
      args: [],
    );
  }

  /// `Latest comments`
  String get latestComments {
    return Intl.message(
      'Latest comments',
      name: 'latestComments',
      desc: '',
      args: [],
    );
  }

  /// `Take`
  String get takePictureAction {
    return Intl.message(
      'Take',
      name: 'takePictureAction',
      desc: '',
      args: [],
    );
  }

  /// `Please, type something to search`
  String get searchFieldEmptyError {
    return Intl.message(
      'Please, type something to search',
      name: 'searchFieldEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Query too short!`
  String get queryTooShortError {
    return Intl.message(
      'Query too short!',
      name: 'queryTooShortError',
      desc: '',
      args: [],
    );
  }

  /// `Camera permission is mandatory during spot creation process.`
  String get cameraPermissionMandatory {
    return Intl.message(
      'Camera permission is mandatory during spot creation process.',
      name: 'cameraPermissionMandatory',
      desc: '',
      args: [],
    );
  }

  /// `Missing permission`
  String get permissionDialogTitle {
    return Intl.message(
      'Missing permission',
      name: 'permissionDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Location service seems to be off. Please, turn it on.`
  String get locationServiceOff {
    return Intl.message(
      'Location service seems to be off. Please, turn it on.',
      name: 'locationServiceOff',
      desc: '',
      args: [],
    );
  }

  /// `Access to gps is mandatory during spot creation process.`
  String get gpsPermissionMandatory {
    return Intl.message(
      'Access to gps is mandatory during spot creation process.',
      name: 'gpsPermissionMandatory',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message(
      'Profile',
      name: 'profileTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}