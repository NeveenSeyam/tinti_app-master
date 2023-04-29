import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';
import 'package:tinti_app/Widgets/wish_list_card.dart';

import '../../../../Widgets/custom_appbar.dart';
import '../../../../Widgets/saels_screen_card.dart';
import '../../../../Widgets/type.dart';

class SaelsScreen extends StatefulWidget {
  const SaelsScreen({super.key});

  @override
  State<SaelsScreen> createState() => _SaelsScreenState();
}

class _SaelsScreenState extends State<SaelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          "العروض",
          isNotification: false,
          isProfile: false,
          isHome: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: RoundedInputField(
                hintText: 'بحث',
                hintColor: AppColors.scadryColor,
                seen: false,
                onChanged: (val) {},
                icon: const Icon(
                  Icons.search,
                  color: AppColors.scadryColor,
                ),
              ),
            ),
            const typeWidget(),
            ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) =>
                  SaelsScreenCardCard(
                image: 'assets/images/sa1.jpeg',
                title: 'تنظيف بالبخار ',
                compeny: 'شركة ليومار',
                details:
                    'تلعب العناية المنتظمة بالسيارة دورا كبيرا في المحافظة على السيارات وهذا هو السبب الذي يجعل بعض السيارات تستمر   ',
                price: '\$ 460 ',
                lastPrice: '\$ 600',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
