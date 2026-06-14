import 'package:flutter/widgets.dart';

/// Spacing helpers so layouts read declaratively: `12.gapH`, `20.gapW`.
extension SpacingX on num {
  Widget get gapH => SizedBox(height: toDouble());
  Widget get gapW => SizedBox(width: toDouble());

  SizedBox get sliverGapH => SizedBox(height: toDouble());
}
