import 'package:flutter/material.dart';

class LinkPartnerScreen extends StatefulWidget {
  const LinkPartnerScreen({super.key});

  @override
  State<LinkPartnerScreen> createState() => _LinkPartnerScreenState();
}

class _LinkPartnerScreenState extends State<LinkPartnerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _codeController = TextEditingController();
  String? _generatedCode;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // You can later check if already linked
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _generateCode() {
    // You’ll replace this with actual Firestore logic
    setState(() {
      _generatedCode = _randomCode();
    });
  }

  void _submitCode() {
    final code = _codeController.text.trim();
    if (code.length != 8) {
      setState(() => _error = "Code must be 8 characters.");
      return;
    }

    // Later: Bloc logic to validate + link
    print("Trying to link with code: $code");
  }

  String _randomCode() {
    final rand = (DateTime.now().millisecondsSinceEpoch % 100000000)
        .toString()
        .padLeft(8, '0');
    return rand;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Link Partner")),
      body: Column(
        children: [
          const SizedBox(height: 12),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Generate Code"),
              Tab(text: "Enter Code"),
            ],
            labelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// Generate Code Tab
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _generateCode,
                        child: const Text("Generate Code"),
                      ),
                      const SizedBox(height: 20),
                      if (_generatedCode != null)
                        Column(
                          children: [
                            const Text("Share this code with your partner:"),
                            const SizedBox(height: 8),
                            SelectableText(
                              _generatedCode!,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                /// Enter Code Tab
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: "Enter Partner's 8-digit Code",
                          border: OutlineInputBorder(),
                        ),
                        maxLength: 8,
                      ),
                      if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitCode,
                        child: const Text("Link with Partner"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
