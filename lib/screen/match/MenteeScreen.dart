import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/Estimate.dart';
import 'package:hobby_mate/screen/class/class_list_%20screen.dart';
import 'package:hobby_mate/screen/estimate/estimate_screen.dart';
import 'package:hobby_mate/service/class_service.dart';
import 'package:hobby_mate/style/style.dart';
import 'package:hobby_mate/widget/home/class_box.dart';
import 'package:intl/intl.dart';

import '../../model/vod.dart';
import '../../util/number_format.dart';
import '../../widget/number_btn.dart';
import '../sign/signup_profile_screen.dart';

enum PriceType { total, hourly }

const List<String> buttons = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '00',
  '0',
  'DEL',
];

final priceProvider = StateProvider((ref) => '0');
final priceDetailProvider = StateProvider((ref) => '');

class MenteeScreen extends ConsumerStatefulWidget {
  const MenteeScreen({Key? key}) : super(key: key);

  @override
  MenteeScreenState createState() => MenteeScreenState();
}

class MenteeScreenState extends ConsumerState<MenteeScreen> {
  PriceType priceType = PriceType.hourly;
  final textEditingController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final price = ref.watch(priceProvider);
    final priceDetail = ref.watch(priceDetailProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 50,
          // leading: InkWell(
          //     onTap: () => Navigator.of(context).pop(),
          //     child: const Icon(
          //       Icons.arrow_back_ios,
          //       color: Colors.black,
          //     )),
          // actions: const [
          //   SizedBox(width: 50)
          // ],
          title: const Center(
              child: Text('프로필',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black))),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EstimateScreen()));
          },
          child: const Icon(Icons.add),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage(
                                    'assets/images/default_user_profile.png'),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'yhs',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                  'Hobby : 음악\nMagor : 운동',
                                  style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Email: yhs@example.com',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Phone: 010-456-7890',
                                style: TextStyle(fontSize: 16),
                              ),

                              Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RowButton(
                                        data: '멘토',
                                        onGenderChoosed: () => setState(() {
                                          priceType = PriceType.hourly;
                                        }),
                                        state: priceType == PriceType.hourly,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      RowButton(
                                          data: '멘티',
                                          onGenderChoosed: () => setState(() {
                                                priceType = PriceType.total;
                                              }),
                                          state: priceType == PriceType.total),
                                    ],
                                  )),
                              const SizedBox(height: 20),
                              if (priceType==PriceType.hourly)...[
                              const Text(
                                '내가 등록한 Class',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey[300],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: TextField(
                                    style: const TextStyle(
                                        overflow: TextOverflow.clip,
                                        fontSize: 16,
                                        height: 1.4),
                                    cursorColor: Colors.grey[500],
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 7,
                                    cursorWidth: 1.5,
                                    controller: textEditingController,
                                    onChanged: (value) {
                                      setState(() {
                                        ref
                                            .read(priceDetailProvider.notifier)
                                            .state = value;
                                      });                  
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.black12.withOpacity(0.05),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                      labelText: '강좌명 : 통기타 시작하기.\n\n강좌내용 : 100명중 1명만이 터득하는 통기타 수업\n\n강좌수 : 5개\n\n금액 : 50000원',
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                    )),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                '나에게 온 요청',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey[300],
                              ),
                              ]else...[
                                const Text(
                                '내가 구매한 Class',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey[300],
                              ),

                              ]

                            ]))),
                Positioned(
                    bottom: 0,
                    child: InkWell(
                        onTap: () {
                          final estimate = Estimate(
                            id: 0,
                              writer: 'user',
                              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                              price: price,
                              detail: priceDetail,
                              priceType: priceType == PriceType.hourly?true:false,
                            category: ''

                          );
                          ClassService().sendEstimate(estimate);
                          Navigator.of(context).pop();
                        } // 리버팟 적용된 HomeScreen 만들기
                        ,
                        child: Container( // 여기 없으면 왜 rowbutton 안 먹는거에요 ?
                            )))
              ],
            )));
  }
}

class PriceBottomSheet extends ConsumerStatefulWidget {
  const PriceBottomSheet({Key? key}) : super(key: key);

  @override
  PriceBottomSheetState createState() => PriceBottomSheetState();
}

class PriceBottomSheetState extends ConsumerState<PriceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final price = ref.watch(priceProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Text(
            '${numberFormat(price)}원',
            style: const TextStyle(
                fontSize: 36, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: Colors.grey[300],
          height: MediaQuery.of(context).size.width * 2.4 / 3,
          alignment: Alignment.center,
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 0.6,
              ),
              itemBuilder: (BuildContext context, int index) {
                // Delete Button
                if (index == 11) {
                  return NumberButton(
                    buttontapped: () {
                      setState(() {
                        if (price != '') {
                          ref.read(priceProvider.notifier).state =
                              price.substring(0, price.length - 1);
                        }
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.white,
                    textColor: Colors.black,
                  );
                }
                // other buttons
                else {
                  return NumberButton(
                      buttontapped: () {
                        if (price.length < 9) {
                          setState(() {
                            ref.read(priceProvider.notifier).state =
                                price + buttons[index];
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('숫자가 너무 큽니다'),
                            ),
                          );
                        }
                      },
                      buttonText: buttons[index],
                      color: Colors.white);
                }
              }), // GridView.builder
        ),
      ],
    );
  }
}
