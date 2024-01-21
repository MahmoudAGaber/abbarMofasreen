// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
//
// class ImageWidget extends StatelessWidget {
//   final File imgFile;
//   final Asset img;
//   final Function function;
//   final int i;
//   const ImageWidget({
//     this.imgFile,
//     @required this.function,
//     this.img,
//     this.i = 0,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Stack(
//         alignment: Alignment.center,
//         overflow: Overflow.visible,
//         children: [
//           Container(
//             width: 130.w,
//             height: 100.h,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(8)),
//                 border: Border.all(color: Colors.transparent)),
//           ),
//           Positioned(
//             right: 0,
//             child: Container(
//                 width: 130.w,
//                 height: 100.h,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                     border: Border.all(color: Colors.black)),
//                 child: i == 1
//                     ? AssetThumb(
//                       quality: 100,
//                         asset: img,
//                         height: 100,
//                         width: 100,
//                       )
//                     : Image.file(
//                         imgFile,
//                         fit: BoxFit.cover,
//                       )),
//           ),
//
//           Positioned(
//             top: -10,
//             left: -10.w,
//             child: GestureDetector(
//               onTap: () => function(i == 1 ? img : imgFile),
//               child: Container(
//                 height: 35.h,
//                 width: 35.w,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: Container(
//                     height: 30.h,
//                     width: 30.w,
//                     child: CircleAvatar(
//                       backgroundColor: Color(0xffF05366),
//                       child: Icon(
//                         Icons.delete,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
