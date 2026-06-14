import 'package:flutter/material.dart';

import 'app.dart';
import 'core/dependency_injection/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const WassalnyCaptainApp());
}
