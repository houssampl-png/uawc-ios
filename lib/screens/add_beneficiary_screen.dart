import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/beneficiary.dart';
import '../services/api_service.dart';
import '../services/offline_queue.dart';

class AddBeneficiaryScreen extends StatefulWidget {
  final ApiService api;
  const AddBeneficiaryScreen({super.key, required this.api});

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  final name = TextEditingController();
  final nationalId = TextEditingController();
  final mobile = TextEditingController();
  bool loading = false;

  Future<void> save() async {
    final beneficiary = Beneficiary(name: name.text.trim(), nationalId: nationalId.text.trim(), mobile: mobile.text.trim());
    final data = beneficiary.toJson();

    setState(() => loading = true);
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        await OfflineQueue().add('create_person', data);
      } else {
        await widget.api.createPerson(data);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ المستفيد')));
      Navigator.pop(context);
    } catch (_) {
      await OfflineQueue().add('create_person', data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ Offline لحين توفر الإنترنت')));
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
        appBar: AppBar(title: const Text('إضافة مستفيد')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم المستفيد')),
            const SizedBox(height: 12),
            TextField(controller: nationalId, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'رقم الهوية')),
            const SizedBox(height: 12),
            TextField(controller: mobile, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الجوال')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: loading ? null : save, child: const Text('حفظ')),
          ],
        ),
      ),
    );
  }
}
