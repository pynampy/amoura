import 'package:amoura/common_widgets/back_button.dart';
import 'package:amoura/common_widgets/custom_button.dart';
import 'package:amoura/couple/couple_bloc.dart';
import 'package:amoura/couple/couple_events.dart';
import 'package:amoura/couple/couple_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinkPartnerScreen extends StatefulWidget {
  const LinkPartnerScreen({super.key});

  @override
  State<LinkPartnerScreen> createState() => _LinkPartnerScreenState();
}

class _LinkPartnerScreenState extends State<LinkPartnerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _codeController = TextEditingController();
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

  void _submitCode() {
    final code = _codeController.text.trim();
    if (code.length != 8) {
      setState(() => _error = "Code must be 8 characters.");
      return;
    }

    context.read<CoupleBloc>().add(CoupleLinkingRequested(code: code));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Link Partner"),
        leading: BackButtonWidget(
          onTap: () => Navigator.of(context).maybePop(),
        ),
      ),
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
                      const SizedBox(height: 20),
                      // if (_generatedCode != null)
                      Column(
                        children: [
                          BlocBuilder<CoupleBloc, CoupleState>(
                            builder: (context, state) {
                              print(state);
                              return Column(
                                children: [
                                  if (state is! CoupleCodeGenerated)
                                    CustomButton(
                                      text: "Generate Code",
                                      onPressed: () => context
                                          .read<CoupleBloc>()
                                          .add(GenerateCodeRequested()),
                                    ),

                                  Text(
                                    state is CoupleCodeGenerated
                                        ? "Share this code with your partner:"
                                        : "",
                                  ),

                                  const SizedBox(height: 8),
                                  Text(
                                    state is CoupleCodeGenerated
                                        ? state.code
                                        : "",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                BlocListener<CoupleBloc, CoupleState>(
                  listener: (context, state) {
                    if (state is CoupleError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else if (state is CoupleLinked) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("You’re now linked!")),
                      );
                      // Optionally navigate or update UI here
                    }
                  },

                  child: Padding(
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
                        CustomButton(
                          text: "Link with Partner",
                          onPressed: _submitCode,
                        ),
                      ],
                    ),
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
