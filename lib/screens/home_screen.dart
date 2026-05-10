import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/offline_queue.dart';
import 'add_beneficiary_screen.dart';
import 'confirm_receive_screen.dart';
import 'search_beneficiary_screen.dart';
import 'sync_screen.dart';

class HomeScreen extends StatefulWidget {
  final ApiService api;
  const HomeScreen({super.key, required this.api});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final queue = OfflineQueue();
  int pending = 0;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    pending = await queue.count();
    if (mounted) setState(() {});
  }

  Widget tile(String title, IconData icon, VoidCallback onTap, {String? subtitle}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF136B3A), size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle == null ? null : Text(subtitle),
        trailing: const Icon(Icons.arrow_back_ios_new),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('برنامج المستفيدين')),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Image.asset('assets/images/uawc_logo.png', height: 82),
              const SizedBox(height: 14),
              tile('إضافة مستفيد', Icons.person_add, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddBeneficiaryScreen(api: widget.api))).then((_) => refresh());
              }),
              tile('البحث عن مستفيد', Icons.search, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SearchBeneficiaryScreen(api: widget.api)));
              }),
              tile('تأكيد الاستلام', Icons.verified_user, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmReceiveScreen(api: widget.api))).then((_) => refresh());
              }),
              tile('المزامنة', Icons.sync, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SyncScreen(api: widget.api))).then((_) => refresh());
              }, subtitle: 'عمليات غير مزامنة: $pending'),
            ],
          ),
        ),
      ),
    );
  }
}
