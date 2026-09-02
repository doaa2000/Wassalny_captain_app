import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/map_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/ride_request.dart';
import '../bloc/trip_bloc.dart';
import '../widgets/map_sheet.dart';
import '../widgets/passenger_tile.dart';
import '../widgets/trip_route_details.dart';

/// Incoming ride request with the acceptance countdown ring.
class IncomingRequestView extends StatelessWidget {
  const IncomingRequestView({super.key, required this.request, required this.countdown});

  final RideRequest request;
  final int countdown;

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            const Positioned.fill(child: MapView(variant: MapVariant.route)),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x66080C10), Color(0x1A080C10), Color(0xD9080C10)],
                    stops: [0, 0.4, 1],
                  ),
                ),
              ),
            ),
            if (!keyboardOpen)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _CountdownRing(countdown: countdown),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: _RequestSheet(request: request),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CountdownRing extends StatelessWidget {
  const _CountdownRing({required this.countdown});

  final int countdown;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final double total = AppConstants.requestCountdown.inSeconds.toDouble();
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: countdown / total, end: countdown / total),
              duration: const Duration(milliseconds: 950),
              builder: (_, value, __) => CircularProgressIndicator(
                value: value,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                color: AppColors.primary,
                backgroundColor: AppColors.darkBorder,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$countdown', style: AppTextStyles.title.copyWith(color: AppColors.textPrimaryDark, fontSize: 30)),
              Text(l.seconds, style: AppTextStyles.micro.copyWith(color: AppColors.textMutedDark, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequestSheet extends StatefulWidget {
  const _RequestSheet({required this.request});

  final RideRequest request;

  @override
  State<_RequestSheet> createState() => _RequestSheetState();
}

class _RequestSheetState extends State<_RequestSheet> {
  static const int _step = 5;

  late final TextEditingController _fareController;
  late double? _passengerFare;
  double? _offeredFare;

  RideRequest get request => widget.request;

  @override
  void initState() {
    super.initState();
    _passengerFare = request.fareAmount;
    _offeredFare = _passengerFare;
    _fareController = TextEditingController(text: _formatAmount(_offeredFare));
  }

  @override
  void didUpdateWidget(covariant _RequestSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.request.id != request.id) {
      _passengerFare = request.fareAmount;
      _offeredFare = _passengerFare;
      _fareController.text = _formatAmount(_offeredFare);
    }
  }

  @override
  void dispose() {
    _fareController.dispose();
    super.dispose();
  }

  String _formatAmount(double? amount) {
    if (amount == null) return '';
    return amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2);
  }

  String _displayFare(AppLocalizations l, double amount) {
    return '${l.egpCurrency} ${_formatAmount(amount)}';
  }

  void _setFare(double value) {
    final double next = value < 0 ? 0 : value;
    setState(() => _offeredFare = next);
    final String text = _formatAmount(next);
    if (_fareController.text != text) {
      _fareController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  void _onFareTyped(String raw) {
    final double? parsed = double.tryParse(raw.trim());
    setState(() => _offeredFare = parsed);
  }

  bool get _canAccept => _offeredFare != null && _offeredFare! > 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bool fareChanged =
        _offeredFare != null && _passengerFare != null && _offeredFare != _passengerFare;
    return MapSheet(
      showHandle: false,
      borderColor: const Color(0xFF2A6B8A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              StatusBadge(label: request.tier, color: AppColors.primary),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  '${request.pickupEtaMinutes} ${l.min} · ${request.pickupDistance}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _FareEditor(
            label: fareChanged || _passengerFare == null ? l.yourFare : l.passengerFare,
            currency: l.egpCurrency,
            controller: _fareController,
            onChanged: _onFareTyped,
            onDecrement: () => _setFare((_offeredFare ?? 0) - _step),
            onIncrement: () => _setFare((_offeredFare ?? 0) + _step),
          ),
          if (fareChanged && _passengerFare != null) ...[
            const SizedBox(height: 8),
            Text(
              '${l.passengerFare}: ${_displayFare(l, _passengerFare!)}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textMutedDark),
            ),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: PassengerTile(request: request, avatarSize: 46),
          ),
          const SizedBox(height: 14),
          TripRouteDetails(
            pickup: request.pickup,
            dropoff: request.dropoff,
            pickupLabel: l.pickupDistance(request.pickupDistance),
            dropoffLabel: l.dropoffDistance(request.distance),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              SizedBox(
                width: 96,
                child: AppButton(
                  label: l.decline,
                  variant: AppButtonVariant.outlined,
                  expand: false,
                  height: 58,
                  onPressed: () => context.read<TripBloc>().add(const TripDeclined()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: l.acceptFare(
                    _canAccept ? _displayFare(l, _offeredFare!) : request.fare,
                  ),
                  onPressed: _canAccept
                      ? () => context.read<TripBloc>().add(TripAccepted(offeredFare: _offeredFare))
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FareEditor extends StatelessWidget {
  const _FareEditor({
    required this.label,
    required this.currency,
    required this.controller,
    required this.onChanged,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final String currency;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.micro.copyWith(color: AppColors.textMutedDark)),
          const SizedBox(height: 4),
          Row(
            children: [
              _StepButton(icon: Icons.remove_rounded, onPressed: onDecrement),
              const SizedBox(width: 8),
              Text(currency, style: AppTextStyles.bodyStrong.copyWith(color: AppColors.success)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  onChanged: onChanged,
                  scrollPadding: const EdgeInsets.only(bottom: 80),
                  style: AppTextStyles.title.copyWith(color: AppColors.success, fontSize: 24),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              _StepButton(icon: Icons.add_rounded, onPressed: onIncrement),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.darkSurfaceAlt,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: AppColors.textPrimaryDark, size: 22),
        ),
      ),
    );
  }
}
