import 'package:amoura/timeline/bloc/timeline_bloc.dart';
import 'package:amoura/timeline/bloc/timeline_events.dart';
import 'package:amoura/timeline/bloc/timeline_states.dart';
import 'package:amoura/timeline/models/journal_entry.dart';
import 'package:amoura/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  void initState() {
    final userState = context.read<UserBloc>().state;
    print(userState.toString());
    if (userState is UserLoaded && userState.coupleDocId != null) {
      context.read<TimelineBloc>().add(
        FetchJournalEntries(userState.coupleDocId!),
      );
    }
    super.initState();
  }

  Future<void> _refreshEntries() async {
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded && userState.coupleDocId != null) {
      context.read<TimelineBloc>().add(
        FetchJournalEntries(userState.coupleDocId!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<TimelineBloc, TimelineState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              TimelineCard(),
              TimelineCard(),
              TimelineCard(),
              TimelineCard(),
            ],
          ),
        );
        // if (state is TimelineLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        // if (state is TimelineError) {
        //   return Center(child: Text(state.message));
        // }

        // if (state is TimelineLoaded) {
        //   final entries = state.entries;

        //   if (entries.isEmpty) {
        //     return const Center(child: Text("No journal entries yet."));
        //   }

        //   return TimelineTile()
        //   // return RefreshIndicator(
        //   //   onRefresh: _refreshEntries,
        //   //   child: ListView.builder(
        //   //     padding: const EdgeInsets.all(12),
        //   //     itemCount: entries.length,
        //   //     itemBuilder: (context, index) {
        //   //       final entry = entries[index];
        //   //       return _JournalCard(entry: entry);
        //   //     },
        //   //   ),
        //   // );
        // }

        // return const SizedBox.shrink(); // Initial or unknown state
      },
    );
  }
}

class TimelineCard extends StatelessWidget {
  const TimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: size.width,
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 10),

          Container(
            // color: Colors.red,
            // width: 10,
            // height: 10,
            child: Text("14 July"),
          ),
          SizedBox(width: 20),

          Expanded(
            child: Container(
              // height: 150,
              padding: EdgeInsets.only(bottom: 10),

              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/couple_photo.jpg",
                    fit: BoxFit.fill,
                    width: size.width,
                    height: 150,
                  ),
                  Text("Our First Date"),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
