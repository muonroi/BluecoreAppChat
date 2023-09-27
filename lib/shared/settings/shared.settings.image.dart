class ImagesGlobal {
  static const String imageRootPath = 'assets/images/';
  static const String imagePath2x = '${imageRootPath}2x/';
  static const String imagePath3x = '${imageRootPath}3x/';
  static const String mainLogo2x = '${imagePath2x}main_logo_2x.png';
  static const String mainLogo3x = '${imagePath3x}main_logo_3x.png';
}

// Container(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: getPercentageOfDevice(context, expectWidth: 500).width,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: ColorsGlobal.disableColor),
//                   borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                         height: getPercentageOfDevice(context, expectHeight: 50)
//                             .height,
//                         width: getPercentageOfDevice(context, expectWidth: 300)
//                             .width,
//                         child: TextFormFieldGlobal(
//                           obscureText: false,
//                           decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: _chatName,
//                               hintStyle: FontsGlobal.h6
//                                   .copyWith(fontStyle: FontStyle.italic)),
//                         )),
//                     SizedBox(
//                         child: ButtonGlobal(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorsGlobal.redColor,
//                       ),
//                       text: '✘',
//                       onPressed: () {},
//                       textStyle: FontsGlobal.h6
//                           .copyWith(color: ColorsGlobal.whiteColor),
//                     ))
//                   ],
//                 ),
//               ),
//               const DividerWidget(color: Color.fromARGB(119, 182, 181, 181)),
//               BlocProvider(
//                 create: (context) => _chatBloc,
//                 child: BlocBuilder<ChatBloc, ChatState>(
//                   builder: (context, state) {
//                     if (state is ChatLoadingState) {
//                       const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     if (state is ChatLoadedState) {
//                       var chatHistoryInfo = state.chatInfo.result;
//                       return Expanded(
//                         child: ListView.builder(
//                             itemCount: chatHistoryInfo.length,
//                             itemBuilder: (context, index) {
//                               var chatInfo = chatHistoryInfo[index];
//                               return Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Column(
//                                   children: [
//                                     _chatMessage(
//                                         context,
//                                         chatInfo.content,
//                                         chatInfo.role,
//                                         chatInfo.role == "user"
//                                             ? CrossAxisAlignment.end
//                                             : CrossAxisAlignment.start,
//                                         chatInfo.role == "user"
//                                             ? MainAxisAlignment.end
//                                             : MainAxisAlignment.start)
//                                   ],
//                                 ),
//                               );
//                             }),
//                       );
//                     }
//                     return Container();
//                   },
//                 ),
//               ),
//               const DividerWidget(color: Color.fromARGB(119, 182, 181, 181)),
//               SizedBox(
//                   child: TextFormFieldGlobal(
//                 controller: _chatControllerContent,
//                 obscureText: false,
//                 decoration: InputDecoration(
//                     border: const OutlineInputBorder(
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(8.0),
//                             bottomLeft: Radius.circular(8.0))),
//                     hintText: L(LanguageCodes.enterContentMessageChatTextInfo
//                         .toString()),
//                     hintStyle:
//                         FontsGlobal.h6.copyWith(fontStyle: FontStyle.italic),
//                     prefixIcon: const Icon(Icons.send),
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         //_
//                         // _chatBloc.addEvent(AskInfo(
//                         //   _chatId,
//                         //   _chatControllerContent.text,
//                         // ));
//                         _chatControllerContent.clear();
//                       },
//                       icon: const Icon(Icons.ios_share),
//                     )),
//               )),
//             ],
//           ),
//         )