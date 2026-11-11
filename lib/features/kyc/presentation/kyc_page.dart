import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pilot/core/errors/app_failure.dart';
import 'package:pilot/core/widgets/prila_gradient_button.dart';
import 'package:pilot/features/kyc/data/kyc_repository.dart';
import 'package:pilot/l10n/app_localizations.dart';

class KycPage extends ConsumerStatefulWidget {
  const KycPage({super.key});

  @override
  ConsumerState<KycPage> createState() => _KycPageState();
}

class _KycPageState extends ConsumerState<KycPage> {
  final _name = TextEditingController();
  final _vehicleNumber = TextEditingController();
  var _vehicleType = 'bike';
  final _docs = <String, String>{};
  var _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _vehicleNumber.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _requiredDocs() {
    // Server KYC list will drive this from bootstrap in a later pass.
    return const [
      {'id': 'dl', 'label': 'Driving Licence'},
      {'id': 'rc', 'label': 'RC'},
      {'id': 'id', 'label': 'Government ID'},
      {'id': 'selfie', 'label': 'Selfie'},
      {'id': 'bank', 'label': 'Bank / UPI'},
    ];
  }

  Future<void> _pick(String docId) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final url = await ref.read(kycRepositoryProvider).uploadDocument(
            file: File(file.path),
            folder: 'kyc/$_vehicleType/$docId',
            contentType: 'image/jpeg',
          );
      setState(() => _docs[docId] = url);
    } catch (e) {
      setState(() {
        _error = e is AppFailure
            ? e.message
            : 'Upload failed (is R2 configured?). You can still continue after fixing env.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(kycRepositoryProvider).submitLocal(
            name: _name.text.trim(),
            vehicleType: _vehicleType,
            vehicleNumber: _vehicleNumber.text.trim(),
            documentUrls: _docs,
          );
      if (!mounted) return;
      context.go('/kyc-review');
    } catch (e) {
      setState(() => _error = e is AppFailure ? e.message : 'Submit failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final docs = _requiredDocs();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.kycTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.kycSubtitle),
          const SizedBox(height: 16),
          TextField(controller: _name, decoration: InputDecoration(labelText: l10n.nameHint)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _vehicleType,
            decoration: InputDecoration(labelText: l10n.vehicleType),
            items: const [
              DropdownMenuItem(value: 'bike', child: Text('Bike')),
              DropdownMenuItem(value: 'auto', child: Text('Auto')),
              DropdownMenuItem(value: 'parcel', child: Text('Parcel')),
              DropdownMenuItem(value: 'logistics', child: Text('Logistics')),
            ],
            onChanged: (v) => setState(() => _vehicleType = v ?? 'bike'),
          ),
          const SizedBox(height: 12),
          TextField(controller: _vehicleNumber, decoration: InputDecoration(labelText: l10n.vehicleNumber)),
          const SizedBox(height: 20),
          for (final d in docs)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(d['label'] as String),
              subtitle: Text(_docs[d['id']] != null ? 'Uploaded' : 'Required'),
              trailing: TextButton(onPressed: _loading ? null : () => _pick(d['id'] as String), child: Text(l10n.upload)),
            ),
          if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 16),
          PrilaGradientButton(
            label: l10n.submitKyc,
            loading: _loading,
            onPressed: _name.text.trim().isEmpty || _vehicleNumber.text.trim().isEmpty ? null : _submit,
          ),
        ],
      ),
    );
  }
}
