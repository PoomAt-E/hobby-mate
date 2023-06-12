import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/widget/appbar.dart';
import 'package:hobby_mate/widget/home/class_box.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({super.key});

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainAppbar(),
        backgroundColor: Colors.white,
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              // optionButton(),
              Expanded(
                  child: Column(
                      children: [1, 2, 3]
                          .map((e) => const ClassBoxWidget())
                          .toList()))
            ])));
  }

  Widget optionButton() {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                    color: Color.fromARGB(44, 0, 0, 0), width: 1),
                borderRadius: BorderRadius.circular(5.0))),
        onPressed: () => optionSheet(),
        child: Row(mainAxisSize: MainAxisSize.min, children: const [
          Text('필터', style: TextStyle(color: Colors.black87)),
          Icon(
            Icons.filter_alt_rounded,
            color: Colors.black54,
            size: 15,
          )
        ]));
  }

  void optionSheet() {
    Future<void> a = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        builder: (BuildContext context) => const OptionBottomSheet());
  }
}

class OptionBottomSheet extends ConsumerWidget {
  const OptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ['전체보기', 'Music', 'Movie', 'Game', 'Book', 'Sport', 'Etc'];
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    // ref
                    //     .read(counselorListProvider.notifier)
                    //     .addOption('type', list[index]);

                    Navigator.pop(context);
                  },
                  child: Container(
                      margin: index != 0
                          ? const EdgeInsets.symmetric(vertical: 20)
                          : const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            list[index],
                            style: index == 0
                                ? TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[600])
                                : const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ],
                      )));
            }));
  }
}
