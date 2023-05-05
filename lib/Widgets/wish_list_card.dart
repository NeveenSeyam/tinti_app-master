// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tinti_app/Util/theme/app_colors.dart';
// import 'package:tinti_app/Widgets/custom_text.dart';

// import '../Modules/Home/main/services/details/servies_details.dart';
// import '../provider/favorites_provider.dart';

// class WishListCard extends ConsumerStatefulWidget {
//   String image;
//   String title;
//   String compeny;
//   String details;
//   String price;
//   int id;
//   int isFavorite;

//   WishListCard(
//       {super.key,
//       required this.image,
//       required this.title,
//       required this.compeny,
//       required this.details,
//       required this.price,
//       required this.id,
//       required this.isFavorite});

//   @override
//   _WishListCardState createState() => _WishListCardState();
// }

// class _WishListCardState extends ConsumerState<WishListCard> {
//   bool isFav = false;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ServiceDetailsScreen(
//                       id: widget.id,
//                       row_id: widget.id,
//                       isFavorite: widget.isFavorite,
//                     )),
//           );
//         },
//         child: Container(
//           margin: const EdgeInsets.all(5),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.w),
//               color: AppColors.white),
//           child: Column(
//             children: [
//               Row(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     height: 145.h,
//                     width: 130.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.w), //<-- SEE HERE
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10.w),
//                       child: Image.network(
//                         widget.image,
//                         fit: BoxFit.fill,
//                         width: 148.w,
//                         height: 150.h,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10.w,
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Container(
//                         alignment: Alignment.centerRight,
//                         width: 200.w,
//                         child: CustomText(
//                           widget.title,
//                           fontSize: 13.sp,
//                         ),
//                       ),
//                       Container(
//                         width: 200.w,
//                         alignment: Alignment.topRight,
//                         child: CustomText(
//                           widget.compeny,
//                           fontSize: 12.sp,
//                           color: AppColors.orange,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 200.w,
//                         child: CustomText(widget.details,
//                             fontSize: 12.sp,
//                             color: AppColors.grey,
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis),
//                       ),
//                       SizedBox(
//                         height: 20.h,
//                       ),
//                       SizedBox(
//                         width: 200.w,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CustomText(
//                               widget.price,
//                               fontSize: 13.sp,
//                             ),
//                             Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       widget.isFavorite == 1
//                                           ? widget.isFavorite = 0
//                                           : widget.isFavorite = 1;
//                                       var favModel = ref.watch(favsProvider);

//                                       if (widget.isFavorite != 0) {
//                                         favModel.addFavRequset(id: widget.id);
//                                       } else {
//                                         favModel.removeFavRequset(
//                                             id: widget.id);
//                                       }
//                                     });
//                                   },
//                                   child: Container(
//                                     width: 25.w,
//                                     height: 24.h,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[300],
//                                       borderRadius: BorderRadius.circular(3.w),
//                                       // border: Border.all(color: Colors.grey),
//                                     ),
//                                     child: Icon(
//                                       widget.isFavorite == 0
//                                           ? Icons.favorite_border
//                                           : Icons.favorite,
//                                       color: widget.isFavorite == 0
//                                           ? AppColors.grey
//                                           : AppColors.orange,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       color: AppColors.grey.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(5.w)),
//                                   padding: EdgeInsets.all(4.w),
//                                   child: Image.asset(
//                                     'assets/images/aaddd.png',
//                                     fit: BoxFit.fill,
//                                     width: 20.w,
//                                     color: AppColors.orange,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               // SizedBox(
//               //   height: 10.h,
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
