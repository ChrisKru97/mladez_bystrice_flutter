//
// Generated file. Do not edit.
//

import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:import_js_library/import_js_library.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:wakelock_web/wakelock_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FirebaseFirestoreWeb.registerWith(registrar);
  FirebaseAuthWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  ImportJsLibrary.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  WakelockWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
