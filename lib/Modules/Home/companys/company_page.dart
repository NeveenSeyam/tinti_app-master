import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Models/companies/comany_model.dart';
import 'package:tinti_app/Modules/Home/companys/company-profile.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';
import 'package:tinti_app/provider/company_provider.dart';
import 'package:tinti_app/provider/products_provider.dart';

import '../../../Helpers/failure.dart';
import '../../../Widgets/custom_text.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/text_widget.dart';
import '../main/services/service_page.dart';

class CampanyPage extends ConsumerStatefulWidget {
  const CampanyPage({super.key});

  @override
  _CampanyPageState createState() => _CampanyPageState();
}

class _CampanyPageState extends ConsumerState<CampanyPage> {
  Future _getContentData() async {
    final prov = ref.read(companyProvider);

    return await prov.getCompanyDataRequset();
  }

  late Future _fetchedMyRequest;
  Future _getAllProductsData() async {
    final prov = ref.read(productsProvider);

    return await prov.getAllProductDataRequset();
  }

  late Future _fetchedAllProductsRequest;
  @override
  void initState() {
    _fetchedMyRequest = _getContentData();
    _fetchedAllProductsRequest = _getAllProductsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'مزودي الخدمة',
        isHome: true,
        isNotification: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RoundedInputField(
              hintText: 'بحث',
              seen: false,
              hintColor: AppColors.scadryColor,
              onChanged: (val) {},
              icon: const Icon(
                Icons.search,
                color: AppColors.scadryColor,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsetsDirectional.only(
                  start: 18.w, bottom: 12.h, top: 20.h, end: 18.w),
              child: CustomText(
                'الشركات',
                color: AppColors.scadryColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'DINNextLTArabic',
                fontSize: 18.sp,
              ),
            ),
            Consumer(
              builder: (context, ref, child) => FutureBuilder(
                future: _fetchedMyRequest,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 70.h,
                      child: const Center(
                        child: LoaderWidget(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data is Failure) {
                      return Center(
                          child: TextWidget(snapshot.data.toString()));
                    }
                    //
                    //  print("snapshot data is ${snapshot.data}");
                    var comanyModel =
                        ref.watch(companyProvider).getCompanyDataList ??
                            CompanyModel();
                    print('lingth ${comanyModel.companies?.length}');
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 370.w,
                          height: 180.h,
                          child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: comanyModel.companies?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) =>
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CompanyProfile(
                                                  name: comanyModel
                                                          .companies?[index]
                                                          .name ??
                                                      '',
                                                  about: comanyModel
                                                          .companies?[index]
                                                          .about ??
                                                      '',
                                                  id: comanyModel
                                                          .companies?[index]
                                                          .id ??
                                                      0,
                                                  img: comanyModel
                                                          .companies?[index]
                                                          .image ??
                                                      '',
                                                )),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 140.w,
                                        height: 170.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.w),
                                            color: AppColors.orange
                                                .withOpacity(0.5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.w),
                                                  child: Image.network(
                                                    comanyModel
                                                            .companies?[index]
                                                            .image ??
                                                        'assets/images/sa1.jpeg',
                                                    width: 120.w,
                                                    height: 70.h,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              CustomText(
                                                comanyModel.companies?[index]
                                                        .name ??
                                                    'نانو سيراميك',
                                                color: AppColors.scadryColor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'DINNextLTArabic',
                                                fontSize: 10.sp,
                                              ),
                                              CustomText(
                                                comanyModel.companies?[index]
                                                        .about ??
                                                    'نانو سيراميك',
                                                color: AppColors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'DINNextLTArabic',
                                                maxLines: 2,
                                                fontSize: 8.sp,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsetsDirectional.only(
                  start: 18.w, bottom: 12.h, top: 20.h, end: 18.w),
              child: CustomText(
                'الخدمات',
                color: AppColors.scadryColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'DINNextLTArabic',
                fontSize: 18.sp,
              ),
            ),
            Consumer(
              builder: (context, ref, child) => FutureBuilder(
                future: _fetchedAllProductsRequest,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 70.h,
                      child: const Center(
                        child: LoaderWidget(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data is Failure) {
                      return Center(
                          child: TextWidget(snapshot.data.toString()));
                    }
                    //
                    //  print("snapshot data is ${snapshot.data}");
                    var productsModel =
                        ref.watch(productsProvider).getProductsDataList;
                    print('lingth ${productsModel!.success?.items?.length}');
                    return SizedBox(
                      width: 370.w,
                      height: 400.h,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150,
                                  childAspectRatio: 2 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: productsModel.success?.items?.length ?? 0,
                          itemBuilder: (BuildContext ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ServicesScreen()),
                                );
                              },
                              child: Stack(
                                children: [
                                  Center(
                                      child: Image.asset(
                                    'assets/images/company_card.png',
                                    fit: BoxFit.fill,
                                    width: 200.w,
                                    height: 200.h,
                                  )),
                                  Center(
                                    child: Container(
                                      width: 100.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.w),
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.w),
                                            child: Image.network(
                                              productsModel.success
                                                      ?.items?[index].image ??
                                                  'assets/images/j_and_j.png',
                                              width: 50.w,
                                            ),
                                          ),
                                          CustomText(
                                            productsModel.success?.items?[index]
                                                    .name ??
                                                'جونسون اند جونسون ',
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'DINNextLTArabic',
                                            fontSize: 10.sp,
                                          ),
                                          CustomText(
                                            productsModel.success?.items?[index]
                                                    .price ??
                                                'جدة ',
                                            color: AppColors.orange,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'DINNextLTArabic',
                                            fontSize: 10.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
