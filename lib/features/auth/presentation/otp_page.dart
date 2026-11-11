import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pilot/core/errors/app_failure.dart';
import 'package:pilot/core/storage/secure_store.dart';
import 'package:pilot/core/widgets/prila_gradient_button.dart';
import 'package:pilot/features/auth/data/auth_repository.dart';
import 'package:pilot/l10n/app_localizations.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key, required this.phone, this.debugCode});

  final String phone;
  final String? debugCode;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _controller = TextEditingController();
  var _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.debugCode != null) _controller.text = widget.debugCode!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).verifyOtp(widget.phone, _controller.text.trim());
      ref.invalidate(authSessionProvider);
      final kyc = await ref.read(secureStoreProvider).read('kyc_status');
      if (!mounted) return;
      if (kyc == 'approved') {
        context.go('/home');
      } else if (kyc == 'pending') {
        context.go('/kyc-review');
      } else {
        context.go('/kyc');
      }
    } catch (e) {
      setState(() => _error = e is AppFailure ? e.message : 'Invalid OTP');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.otpTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l10n.otpSubtitle(widget.phone)),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(counterText: ''),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const Spacer(),
            PrilaGradientButton(label: l10n.verifyOtp, onPressed: _verify, loading: _loading),
          ],
        ),
      ),
    );
  }
}
