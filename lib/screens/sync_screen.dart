import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/offline_queue.dart';

class SyncScreen extends StatefulWidget {
  final ApiService api;
  const SyncScreen({super.key, required this.api});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final queue = OfflineQueue();
  int count = 0;
  bool loading = false;

  Future<void> refresh() async {
    count = await queue.count();
    if (mounted) setState(() {});
  }

  Future<void> sync() async {
    setState(() => loading = true);
    try {
      await queue.sync(widget.api);
      await refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت المزامنة')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذرت المزامنة: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('المزامنة')),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text('عدد العمليات غير المزامنة: $count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(onPressed: loading ? null : sync, child: const Text('مزامنة الآن')),
            ],
          ),
        ),
      ),
    );
  }
}
