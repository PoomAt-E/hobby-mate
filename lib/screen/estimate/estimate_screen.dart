import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_mate/model/Estimate.dart';
import 'package:hobby_mate/screen/class/class_list_%20screen.dart';
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

class EstimateScreen extends ConsumerStatefulWidget {
  const EstimateScreen({Key? key}) : super(key: key);

  @override
  EstimateScreenState createState() => EstimateScreenState();
}

class EstimateScreenState extends ConsumerState<EstimateScreen> {
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
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          actions: const [
            SizedBox(width: 50)
          ],
          title: const Center(
              child: Text('견적 등록',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black))),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '견적을 등록할 서비스',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              // ClassBoxWidget(vod: Vod(
                              //   ownerId: "1",
                              //   vodName: '통기타 시작하기',
                              //   vodGroupId: "1",
                              //   vodLengthH: 1,
                              //   vodLengthM: 30,
                              //   vodLengthS: 1,
                              //   vodType: "1",
                              //   id: "1",
                              //   vodUrl: "1",
                              // ),),
                              Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RowButton(
                                        data: '시간 당',
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
                                          data: '총 비용',
                                          onGenderChoosed: () => setState(() {
                                                priceType = PriceType.total;
                                              }),
                                          state: priceType == PriceType.total),
                                    ],
                                  )),
                              const SizedBox(height: 20),
                              const Text(
                                '견적 금액',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                  onTap: () => showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30))),
                                      builder: (context) =>
                                          const PriceBottomSheet()),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          const TextSpan(
                                              text: '최소  ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey)),
                                          TextSpan(
                                              text: numberFormat(price),
                                              style: const TextStyle(
                                                  fontSize: 27,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blue)),
                                          const TextSpan(
                                              text: ' 원 부터~',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  )),
                              Divider(
                                thickness: 1,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                '견적 설명',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: TextField(
                                    style: const TextStyle(
                                        overflow: TextOverflow.clip,
                                        fontSize: 16,
                                        height: 1.4),
                                    cursorColor: Colors.grey[500],
                                    maxLength: 400,
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
                                      hintText: '견적 설명을 입력해주세요.',
                                      counterStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[400]),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                    )),
                              )
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
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.blue,
                            child: const Center(
                                child: Text('견적 등록하기',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))))))
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
