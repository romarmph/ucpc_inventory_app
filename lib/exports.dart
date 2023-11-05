///
///
/// ! ---------------------------------------------------- PACKAGES
///
///
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:flex_color_scheme/flex_color_scheme.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:quickalert/quickalert.dart';

///
///
/// ! ---------------------------------------------------- CONFIG
///
///

// ? ---------------  Constants
export 'package:ucpc_inventory_management_app/config/constants/route_names.dart';
export 'package:ucpc_inventory_management_app/config/constants/navigator_key.dart';
// ? ---------------  Exports
// ? ---------------  Routes
export 'package:ucpc_inventory_management_app/config/routes/routes.dart';

// ? ---------------  Theme
export 'package:ucpc_inventory_management_app/config/theme/padding.dart';
export 'package:ucpc_inventory_management_app/config/theme/themes.dart';
export 'package:ucpc_inventory_management_app/config/theme/color_scheme.dart';

///
///
/// ! ---------------------------------------------------- DATABASE
///
///

///
///
/// ! ---------------------------------------------------- MODELS
///
///

///
///
/// ! ---------------------------------------------------- RIVERPOD
///
///

// ? ---------------  Auth
export 'package:ucpc_inventory_management_app/riverpod/auth/login_form.riverpod.dart';
export 'package:ucpc_inventory_management_app/riverpod/auth/auth_service.riverpod.dart';

///
///
/// ! ---------------------------------------------------- SERVICES
///
///

export 'package:ucpc_inventory_management_app/services/auth/auth.service.dart';

///
///
/// ! ---------------------------------------------------- UTILS
///
///

///
///
/// ! ---------------------------------------------------- VIEWS
///
///

export 'package:ucpc_inventory_management_app/views/wrapper.dart';

// ? ---------------  Auth
export 'package:ucpc_inventory_management_app/views/auth/login.view.dart';

// ? ---------------  Home
export 'package:ucpc_inventory_management_app/views/home/home.view.dart';
// * --- Widgets
export 'package:ucpc_inventory_management_app/views/home/widgets/menu_button_card.dart';
