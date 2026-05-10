import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SearchBeneficiaryScreen extends StatefulWidget {
  final ApiService api;
  const SearchBeneficiaryScreen({super.key, required this.api});

  @override
  State<SearchBeneficiaryScreen> createState() => _SearchBeneficiaryScreenState();
}

class _SearchBeneficiaryScreenState extends State<SearchBeneficiaryScreen> {
  final query = TextEditingController();
  List<dynamic> all = [];
  bool loading = false;

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final result = await widget.api.getPersons();
      final data = result['data'] ?? result['persons'] ?? result['result'] ?? [];
      all = data is List ? data : [];
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر جلب المستفيدين: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  List<dynamic> get filtered {
    final q = query.text.trim();
    if (q.isEmpty) return all;
    return all.where((item) => item.toString().contains(q)).toList();
  }

  @override
  void initState() {
    super.initState();
    load();
    query.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final list = filtered;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('البحث عن مستفيد')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(controller: query, decoration: const InputDecoration(labelText: 'بحث بالاسم أو رقم الهوية')),
            ),
            if (loading) const LinearProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final item = list[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(item['name']?.toString() ?? item.toString()),
                      subtitle: Text('رقم الهوية: ${item['national_id'] ?? item['id_number'] ?? ''}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
