import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/service/streaming_service.dart';
import 'package:hobby_mate/widget/appbar.dart';
import 'package:hobby_mate/widget/home/class_box.dart';

import '../../model/vod.dart';

class ClassListScreen extends ConsumerStatefulWidget {
  const ClassListScreen({super.key});

  @override
  _ClassListScreenState createState() => _ClassListScreenState();
}

class _ClassListScreenState extends ConsumerState<ClassListScreen> {

  final vodProvider = FutureProvider((ref) => StreamingService().getAllVodGroup());
  @override
  Widget build(BuildContext context) {
    final vodGroups = ref.watch(vodProvider);
    return Scaffold(
        appBar: const MainAppbar(),
        backgroundColor: Colors.white,
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              const Text('내 수업 목록',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const Divider(
                color: Colors.black12,
              ),
              vodGroups.when(data: (vods){
                if(vods.isEmpty){
                  return const Center(child: Text('수업이 없습니다.'));
                }else{
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vods.length,
                    itemBuilder: (context, index){
                      return ClassBoxWidget(
                        vodGroup: vods[index],
                      );
                    },
                  );
                }
              }, error: (e, st){
                return const Center(child: Text('수업을 불러오는데 실패했습니다.'));
              }, loading: ()=>CircularProgressIndicator())
             ,
              const SizedBox(
                height: 20,
              ),

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
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
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
