import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Models/product/service_products_model.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';
import 'package:tinti_app/Widgets/wish_list_card.dart';
import 'package:tinti_app/provider/products_provider.dart';

import '../../../../Helpers/failure.dart';
import '../../../../Models/product/sales_products_model.dart';
import '../../../../Widgets/custom_appbar.dart';
import '../../../../Widgets/loader_widget.dart';
import '../../../../Widgets/servieses_card.dart';
import '../../../../Widgets/text_widget.dart';
import '../../../../Widgets/type.dart';
import '../../../../provider/services_provider.dart';
import 'details/servies_details.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  ServicesScreen({
    super.key,
  });

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  int serviceId = 1;
  int pageIndex = 1;

  Future _getContentData() async {
    final prov = ref.read(servicesProvider);

    return await prov.getServiecesDataRequset();
  }

  int updateServiceId(int service) {
    setState(() {
      serviceId = service;
    });
    return serviceId;
  }

  late Future _fetchedMyRequest;

  Future _getProductsData() async {
    final prov = ref.read(productsProvider);

    return await prov.getProductDataByServisesRequset(
        id: updateServiceId(serviceId));
  }

  late Future _fetchedProductRequest;

  @override
  void initState() {
    _fetchedMyRequest = _getContentData();
    _fetchedProductRequest = _getProductsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        isProfile: false,
        "services".tr(),
        isNotification: false,
        isHome: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _fetchedProductRequest = _getProductsData();
          });
          return _fetchedProductRequest;
        },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
              child: RoundedInputField(
                hintText: 'search'.tr(),
                hintColor: AppColors.scadryColor,
                seen: false,
                onChanged: (val) {},
                icon: const Icon(
                  Icons.search,
                  color: AppColors.scadryColor,
                ),
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

                    var serviecesModel =
                        ref.watch(servicesProvider).getDataList;

                    return Column(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 370.w,
                            height: 48.h,
                            child: Center(
                              child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: serviecesModel?.services?.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      textButtonModel(
                                          serviecesModel?.services?[index].name,
                                          serviecesModel?.services?[index].id,
                                          serviecesModel?.services?[index].id)),
                            ),
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) => FutureBuilder(
                            future: _fetchedProductRequest,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                      child:
                                          TextWidget(snapshot.data.toString()));
                                }
                                //
                                //  print("snapshot data is ${snapshot.data}");

                                var productByServiceModel = ref
                                        .watch(productsProvider)
                                        .getProductsSirvesDataList ??
                                    ServiceProductModel();
                                return Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 15.w,
                                      end: 15.w,
                                      top: 5.h,
                                      bottom: 20.h),
                                  child: SizedBox(
                                    height: 620.h,
                                    child: GridView.builder(
                                        // physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 300,
                                                childAspectRatio: 2 / 2.3,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10),
                                        itemCount: productByServiceModel
                                                .success?.items?.length ??
                                            0,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ServiceDetailsScreen(
                                                          id: productByServiceModel
                                                                  .success
                                                                  ?.items?[
                                                                      index]
                                                                  .id ??
                                                              0,
                                                          row_id:
                                                              productByServiceModel
                                                                      .success
                                                                      ?.items?[
                                                                          index]
                                                                      .id ??
                                                                  0,
                                                          isFavorite:
                                                              productByServiceModel
                                                                      .success
                                                                      ?.items?[
                                                                          index]
                                                                      .is_favorite ??
                                                                  0,
                                                        )),
                                              );
                                              print(
                                                  ' sssssssss ${productByServiceModel.success?.items?.length}');
                                            },
                                            child: ServicesCard(
                                                // productByServiceModel.Products.length ??
                                                productByServiceModel.success
                                                        ?.items?[index].image ??
                                                    'assets/images/sa1.jpeg',
                                                productByServiceModel.success
                                                        ?.items?[index].name ??
                                                    ' تظليل',
                                                productByServiceModel
                                                        .success
                                                        ?.items?[index]
                                                        .description ??
                                                    'شركة جونسون اد جونسون.',
                                                productByServiceModel.success
                                                        ?.items?[index].price ??
                                                    '355',
                                                '',
                                                '',
                                                productByServiceModel
                                                        .success
                                                        ?.items?[index]
                                                        .is_favorite ??
                                                    0,
                                                productByServiceModel.success
                                                        ?.items?[index].id ??
                                                    0),
                                          );
                                        }),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }

  TextButton textButtonModel(name, index, id) {
    return TextButton(
      onPressed: () {
        setState(() {
          pageIndex = index;
          serviceId = id;
          _fetchedProductRequest = _getProductsData();
        });
      },
      child: pageIndex == index
          ? Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Color(0xffF57A38),
                borderRadius: BorderRadius.circular(10.w),
                // border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'DINNEXTLTARABIC',
                      fontWeight: FontWeight.normal),
                ),
              ),
            )
          : Container(
              // width: 60.w,
              // height: 30.h,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                // color: Colors.orange[300],
                borderRadius: BorderRadius.circular(10.w),
                border: Border.all(
                  color: const Color(0xffF57A38),
                ),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontFamily: 'DINNEXTLTARABIC',
                    fontWeight: FontWeight.normal),
              ),
            ),
    );
  }
}
