// import 'package:bluecore/shared/settings/shared.settings.color.dart';
// import 'package:bluecore/shared/settings/shared.settings.dart';
// import 'package:bluecore/shared/settings/shared.settings.font.dart';
// import 'package:flutter/material.dart';

// Widget _chatMessage(
//     BuildContext context,
//     String content,
//     String senderName,
//     CrossAxisAlignment crossAxisAlignment,
//     MainAxisAlignment mainAxisAlignment) {
//   return Column(
//     crossAxisAlignment: crossAxisAlignment,
//     children: [
//       Row(
//         mainAxisAlignment: mainAxisAlignment,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: getPercentageOfDevice(context, expectWidth: 50).width,
//             height: getPercentageOfDevice(context, expectHeight: 50).height,
//             child: Image.network(
//               "https://t3.ftcdn.net/jpg/02/09/37/00/240_F_209370065_JLXhrc5inEmGl52SyvSPeVB23hB6IjrR.jpg",
//               fit: BoxFit.fill,
//             ),
//           ),
//           Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               height: getPercentageOfDevice(context, expectHeight: 50).height,
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   senderName,
//                   style: FontsGlobal.h5.copyWith(fontWeight: FontWeight.w700),
//                 ),
//               )),
//         ],
//       ),
//       Container(
//           margin: const EdgeInsets.symmetric(vertical: 4.0),
//           padding: const EdgeInsets.all(10.0),
//           decoration: const BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(16.0)),
//               color: ColorsGlobal.customerChatColor),
//           child: Text(
//             content,
//             style: FontsGlobal.h5,
//           ))
//     ],
//   );
// }
