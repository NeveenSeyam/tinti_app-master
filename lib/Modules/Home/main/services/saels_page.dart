import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';
import 'package:tinti_app/Widgets/wish_list_card.dart';
import 'package:tinti_app/provider/services_provider.dart';

import '../../../../Helpers/failure.dart';
import '../../../../Widgets/custom_appbar.dart';
import '../../../../Widgets/loader_widget.dart';
import '../../../../Widgets/saels_screen_card.dart';
import '../../../../Widgets/text_widget.dart';
import '../../../../Widgets/type.dart';
import '../../../../provider/products_provider.dart';
import 'details/servies_details.dart';

class SaelsScreen extends ConsumerStatefulWidget {
  const SaelsScreen({super.key});

  @override
  _SaelsScreenState createState() => _SaelsScreenState();
}

class _SaelsScreenState extends ConsumerState<SaelsScreen> {
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

    return await prov.getSalesProductDataRequset();
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          isProfile: false,
          "العروض",
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
                                        child: TextWidget(
                                            snapshot.data.toString()));
                                  }
                                  //
                                  //  print("snapshot data is ${snapshot.data}");

                                  var productByServiceModel = ref
                                      .watch(productsProvider)
                                      .getProductsSellsDataList;
                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 15.w, end: 15.w, top: 5.h),
                                    child: SizedBox(
                                      height: 780.0,
                                      child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          // shrinkWrap: true,

                                          itemCount: productByServiceModel
                                                  ?.success?.items?.length ??
                                              0,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return Container(
                                              width: double.infinity,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ServiceDetailsScreen(
                                                              id: productByServiceModel
                                                                      ?.success
                                                                      ?.items?[
                                                                          index]
                                                                      .id ??
                                                                  0,
                                                              row_id: 0,
                                                              isFavorite: productByServiceModel
                                                                      ?.success
                                                                      ?.items?[
                                                                          index]
                                                                      .is_favorite ??
                                                                  1,
                                                            )),
                                                  );
                                                },
                                                child: SaelsScreenCardCard(
                                                  details: productByServiceModel
                                                          ?.success
                                                          ?.items?[index]
                                                          .description ??
                                                      '',
                                                  isFavorite:
                                                      productByServiceModel
                                                              ?.success
                                                              ?.items?[index]
                                                              .is_favorite ??
                                                          0,
                                                  image: productByServiceModel
                                                          ?.success
                                                          ?.items?[index]
                                                          .image ??
                                                      '',
                                                  lastPrice:
                                                      productByServiceModel
                                                              ?.success
                                                              ?.items?[index]
                                                              .salePrice ??
                                                          '',
                                                  price: productByServiceModel
                                                          ?.success
                                                          ?.items?[index]
                                                          .price ??
                                                      '',
                                                  title: productByServiceModel
                                                          ?.success
                                                          ?.items?[index]
                                                          .name ??
                                                      '',
                                                  id: productByServiceModel
                                                          ?.success
                                                          ?.items?[index]
                                                          .id ??
                                                      0,
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
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
                  style: const TextStyle(
                    color: Colors.white,
                  ),
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
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
    );
  }
}
