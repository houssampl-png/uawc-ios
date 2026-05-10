import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';
import '../services/offline_queue.dart';

class ConfirmReceiveScreen extends StatefulWidget {
  final ApiService api;
  const ConfirmReceiveScreen({super.key, required this.api});

  @override
  State<ConfirmReceiveScreen> createState() => _ConfirmReceiveScreenState();
}

class _ConfirmReceiveScreenState extends State<ConfirmReceiveScreen> {
  final personId = TextEditingController();
  final aidId = TextEditingController();
  bool loading = false;

  Future<void> confirm() async {
    final data = {
      'person_id': personId.text.trim(),
      'aid_manage_id': aidId.text.trim(),
      'received_at': DateTime.now().toIso8601String(),
    };

    setState(() => loading = true);
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        await OfflineQueue().add('confirm_receive', data);
      } else {
        await widget.api.confirmReceive(data);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تأكيد الاستلام')));
      Navigator.pop(context);
    } catch (_) {
      await OfflineQueue().add('confirm_receive', data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التأكيد Offline')));
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تأكيد الاستلام')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(controller: personId, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'رقم المستفيد / رقم الهوية')),
            const SizedBox(height: 12),
            TextField(controller: aidId, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'رقم المساعدة / الكوبون')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: loading ? null : confirm, child: const Text('تأكيد الاستلام')),
          ],
        ),
      ),
    );
  }
}
