import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Models/product/sales_products_model.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';
import 'package:tinti_app/Widgets/wish_list_card.dart';
import 'package:tinti_app/provider/services_provider.dart';

import '../../../../Helpers/failure.dart';
import '../../../../Models/product/service_products_model.dart';
import '../../../../Widgets/button_widget.dart';
import '../../../../Widgets/custom_appbar.dart';
import '../../../../Widgets/loader_widget.dart';
import '../../../../Widgets/saels_screen_card.dart';
import '../../../../Widgets/servieses_card.dart';
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
  int currentPage = 0;
  // int currentPage = 0;
  var hight = 680.h;
  TextEditingController _search = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isSearch = false;
  dynamic productList;
  var addProductList;
  Future _getContentData() async {
    final prov = ref.read(servicesProvider);

    return await prov.getServiecesDataRequset();
  }

  Future _getSearchProductsData(dataSearch2) async {
    final prov = ref.read(productsProvider);

    return await prov.getSearchRequsett(name: dataSearch2 ?? '');
  }

  int updateServiceId(int service) {
    setState(() {
      serviceId = service;
    });
    return serviceId;
  }

  late Future _fetchedMyRequest;

  Future _getProductsData(page) async {
    final prov = ref.read(productsProvider);

    return await prov.getSalesProductDataRequset(page: page);
  }

  late Future _fetchedProductRequest;

  @override
  void initState() {
    _fetchedMyRequest = _getContentData();
    _fetchedProductRequest = _getProductsData(0);
    isSearch = false;
    _search.text = '';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() async {
        print("object");

        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          var portalRequset =
              ref.watch(productsProvider).getProductsSellsDataList ??
                  ProductModel();
          if ((portalRequset.success?.pageNumber ?? 0) <
              (portalRequset.success?.totalPages ?? 0)) {
            print("has more pages");
            setState(() {
              showLoding = true;
              hight = 650.h;
            });
            final prov = ref.read(productsProvider);

            await prov
                .getSalesProductDataRequset(
                    page: (portalRequset.success?.pageNumber ?? 0) + 1,
                    isNewProduct: false)
                .then((value) {
              setState(() {
                showLoding = false;
                hight = 680.h;
              });
              setState(() {});
            });
          }
        }
      });
    });

    super.initState();
  }

  bool showLoding = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future fetch(page) async {
    final prov = ref.read(productsProvider);
    productList = ref.watch(productsProvider).getProductsSellsDataList;
    addProductList = await prov.getSalesProductDataRequset(page: page + 1);
    // if (addProductList.length < 10) {}
    productList.addAll(addProductList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        isProfile: false,
        "sales".tr(),
        isNotification: false,
        isHome: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _fetchedProductRequest = _getProductsData(0);
          });
          return _fetchedProductRequest;
        },
        child: Consumer(
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
                  child: Text('لا يوجد نتائج مطابقة'),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data is Failure) {
                  return Center(child: TextWidget('لا يوجد نتائج مطابقة'));
                }
                //
                //  print("snapshot data is ${snapshot.data}");

                var serviecesModel = ref.watch(servicesProvider).getDataList;

                return ListView(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                      child: Consumer(
                        builder: (context, ref, child) => FutureBuilder(
                          future: _fetchedMyRequest,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('لا يوجد نتائج مطابقة'),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data is Failure) {
                                return Center(
                                    child: TextWidget('لا يوجد نتائج مطابقة'));
                              }
                              //
                              //  print("snapshot data is ${snapshot.data}");

                              var serviecesModel =
                                  ref.watch(servicesProvider).getDataList;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 290.w,
                                    child: RoundedInputField(
                                      hintText: 'search'.tr(),
                                      hintColor: AppColors.scadryColor,
                                      seen: false,
                                      controller: _search,
                                      onChanged: (val) {
                                        setState(() {
                                          isSearch = true;
                                          _fetchedProductRequest =
                                              _getSearchProductsData(val);
                                        });
                                      },
                                      // icon: const Icon(
                                      //   Icons.search,
                                      //   color: AppColors.scadryColor,
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60.w,
                                    child: ButtonWidget(
                                      onPressed: () {
                                        if (_search.text.isNotEmpty) {
                                          setState(() {
                                            _fetchedProductRequest =
                                                _getSearchProductsData(
                                                    _search.text);
                                            isSearch = true;
                                            // _search.text = '';
                                          });
                                        } else {
                                          setState(() {
                                            _fetchedProductRequest =
                                                _getProductsData(0);
                                            isSearch = false;
                                          });
                                        }
                                      },
                                      widget: Icon(
                                        Icons.search,
                                      ),
                                      backgroundColor: AppColors.orange,
                                    ),
                                  )
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isSearch ? true : false,
                      child: Consumer(
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
                                child: Text('لا يوجد نتائج مطابقة'),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data is Failure) {
                                return Center(
                                    child: TextWidget('لا يوجد نتائج مطابقة'));
                              }
                              //
                              //  print("snapshot data is ${snapshot.data}");

                              var productModel =
                                  ref.watch(productsProvider).getSearchDataList;
                              var length = productModel?.success?.length ?? 0;
                              return Column(
                                children: [
                                  Padding(
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
                                          itemCount: length,
                                          controller: _scrollController,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ServiceDetailsScreen(
                                                            id: productModel
                                                                    ?.success?[
                                                                        index]
                                                                    .id ??
                                                                0,
                                                            row_id: productModel
                                                                    ?.success?[
                                                                        index]
                                                                    .id ??
                                                                0,
                                                            isFavorite: 0,
                                                          )),
                                                );
                                                // print(
                                                //     ' sssssssss ${productByServiceModel.success?.items?.length}');
                                              },
                                              child: ServicesCard(
                                                  // productByServiceModel.Products.length ??
                                                  productModel?.success?[index]
                                                          .image ??
                                                      'assets/images/sa1.jpeg',
                                                  productModel?.success?[index]
                                                          .name ??
                                                      ' تظليل',
                                                  productModel?.success?[index]
                                                          .description ??
                                                      'شركة جونسون اد جونسون.',
                                                  productModel?.success?[index]
                                                          .price ??
                                                      '355',
                                                  '',
                                                  '',
                                                  0,
                                                  productModel?.success?[index]
                                                          .id ??
                                                      0),
                                            );
                                          }),
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
                    ),
                    Visibility(
                      visible: isSearch ? false : true,
                      child: Consumer(
                        builder: (context, ref, child) => FutureBuilder(
                          future: _fetchedMyRequest,
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
                                child: Text('لا يوجد نتائج مطابقة'),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data is Failure) {
                                return Center(
                                    child: TextWidget('لا يوجد نتائج مطابقة'));
                              }
                              //
                              //  print("snapshot data is ${snapshot.data}");

                              var serviecesModel =
                                  ref.watch(servicesProvider).getDataList;

                              return Column(
                                children: [
                                  Consumer(
                                    builder: (context, ref, child) =>
                                        FutureBuilder(
                                      future: _fetchedMyRequest,
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
                                            child: Text(
                                                'Error: ${snapshot.error}'),
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

                                          var serviecesModel = ref
                                              .watch(servicesProvider)
                                              .getDataList;

                                          return Consumer(
                                            builder: (context, ref, child) =>
                                                FutureBuilder(
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
                                                    child: Text(
                                                        'Error: ${snapshot.error}'),
                                                  );
                                                }
                                                if (snapshot.hasData) {
                                                  if (snapshot.data
                                                      is Failure) {
                                                    return Center(
                                                        child: TextWidget(
                                                            snapshot.data
                                                                .toString()));
                                                  }
                                                  //
                                                  //  print("snapshot data is ${snapshot.data}");

                                                  productList = ref
                                                      .watch(productsProvider)
                                                      .getProductsSellsDataList;
                                                  var lenght = ref
                                                          .watch(
                                                              productsProvider)
                                                          .getProductsSellsDataList
                                                          ?.success
                                                          ?.items
                                                          ?.length ??
                                                      0;
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .only(
                                                                start: 15.w,
                                                                end: 15.w,
                                                                top: 5.h),
                                                    child: SizedBox(
                                                      height: 680.h,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: hight,
                                                            child: ListView
                                                                .builder(
                                                                    // physics: BouncingScrollPhysics(),
                                                                    shrinkWrap:
                                                                        false,
                                                                    itemCount:
                                                                        lenght,
                                                                    controller:
                                                                        _scrollController,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                ctx,
                                                                            index) {
                                                                      return Container(
                                                                        width: double
                                                                            .infinity,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => ServiceDetailsScreen(
                                                                                        id: productList?.success?.items?[index].id ?? 0,
                                                                                        row_id: 0,
                                                                                        isFavorite: productList?.success?.items?[index].is_favorite ?? 1,
                                                                                      )),
                                                                            );
                                                                          },
                                                                          child:
                                                                              SaelsScreenCardCard(
                                                                            details:
                                                                                productList?.success?.items?[index].description ?? '',
                                                                            isFavorite:
                                                                                productList?.success?.items?[index].is_favorite ?? 0,
                                                                            image:
                                                                                productList?.success?.items?[index].image ?? '',
                                                                            lastPrice:
                                                                                productList?.success?.items?[index].price ?? '',
                                                                            price:
                                                                                productList?.success?.items?[index].salePrice ?? '',
                                                                            title:
                                                                                productList?.success?.items?[index].name ?? '',
                                                                            id: productList?.success?.items?[index].id ??
                                                                                0,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                          if (showLoding)
                                                            SizedBox(
                                                              height: 30.h,
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return Container();
                                              },
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
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     if (snapshot.data!['page_number'] <
                    //         snapshot.data!['total_pages'])
                    //       OutlinedButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             currentPage++;
                    //           });
                    //         },
                    //         child: Text(
                    //           "Next",
                    //         ),
                    //       ),
                    //     if (snapshot.data!['page_number'] > 1)
                    //       OutlinedButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             currentPage--;
                    //           });
                    //         },
                    //         child: Text(
                    //           "Previous",
                    //         ),
                    //       ),
                    //   ],
                    // ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),

        // SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
        //         child: RoundedInputField(
        //           hintText: 'search'.tr(),
        //           hintColor: AppColors.scadryColor,
        //           seen: false,
        //           onChanged: (val) {},
        //           icon: const Icon(
        //             Icons.search,
        //             color: AppColors.scadryColor,
        //           ),
        //         ),
        //       ),
        //       Consumer(
        //         builder: (context, ref, child) => FutureBuilder(
        //           future: _fetchedMyRequest,
        //           builder: (context, snapshot) {
        //             if (snapshot.connectionState == ConnectionState.waiting) {
        //               return SizedBox(
        //                 height: 70.h,
        //                 child: const Center(
        //                   child: LoaderWidget(),
        //                 ),
        //               );
        //             }
        //             if (snapshot.hasError) {
        //               return Center(
        //                 child: Text('Error: ${snapshot.error}'),
        //               );
        //             }
        //             if (snapshot.hasData) {
        //               if (snapshot.data is Failure) {
        //                 return Center(
        //                     child: TextWidget(snapshot.data.toString()));
        //               }
        //               //
        //               //  print("snapshot data is ${snapshot.data}");

        //               var serviecesModel =
        //                   ref.watch(servicesProvider).getDataList;

        //               return Consumer(
        //                 builder: (context, ref, child) => FutureBuilder(
        //                   future: _fetchedProductRequest,
        //                   builder: (context, snapshot) {
        //                     if (snapshot.connectionState ==
        //                         ConnectionState.waiting) {
        //                       return SizedBox(
        //                         height: 70.h,
        //                         child: const Center(
        //                           child: LoaderWidget(),
        //                         ),
        //                       );
        //                     }
        //                     if (snapshot.hasError) {
        //                       return Center(
        //                         child: Text('Error: ${snapshot.error}'),
        //                       );
        //                     }
        //                     if (snapshot.hasData) {
        //                       if (snapshot.data is Failure) {
        //                         return Center(
        //                             child:
        //                                 TextWidget(snapshot.data.toString()));
        //                       }
        //                       //
        //                       //  print("snapshot data is ${snapshot.data}");

        //                       var productByServiceModel = ref
        //                           .watch(productsProvider)
        //                           .getProductsSellsDataList;
        //                       return Padding(
        //                         padding: EdgeInsetsDirectional.only(
        //                             start: 15.w, end: 15.w, top: 5.h),
        //                         child: SizedBox(
        //                           height: 680.h,
        //                           child: ListView.builder(
        //                               // physics: BouncingScrollPhysics(),
        //                               shrinkWrap: false,
        //                               itemCount: productByServiceModel
        //                                       ?.success?.items?.length ??
        //                                   0,
        //                               itemBuilder: (BuildContext ctx, index) {
        //                                 return Container(
        //                                   width: double.infinity,
        //                                   child: GestureDetector(
        //                                     onTap: () {
        //                                       Navigator.push(
        //                                         context,
        //                                         MaterialPageRoute(
        //                                             builder: (context) =>
        //                                                 ServiceDetailsScreen(
        //                                                   id: productByServiceModel
        //                                                           ?.success
        //                                                           ?.items?[
        //                                                               index]
        //                                                           .id ??
        //                                                       0,
        //                                                   row_id: 0,
        //                                                   isFavorite:
        //                                                       productByServiceModel
        //                                                               ?.success
        //                                                               ?.items?[
        //                                                                   index]
        //                                                               .is_favorite ??
        //                                                           1,
        //                                                 )),
        //                                       );
        //                                     },
        //                                     child: SaelsScreenCardCard(
        //                                       details: productByServiceModel
        //                                               ?.success
        //                                               ?.items?[index]
        //                                               .description ??
        //                                           '',
        //                                       isFavorite: productByServiceModel
        //                                               ?.success
        //                                               ?.items?[index]
        //                                               .is_favorite ??
        //                                           0,
        //                                       image: productByServiceModel
        //                                               ?.success
        //                                               ?.items?[index]
        //                                               .image ??
        //                                           '',
        //                                       lastPrice: productByServiceModel
        //                                               ?.success
        //                                               ?.items?[index]
        //                                               .salePrice ??
        //                                           '',
        //                                       price: productByServiceModel
        //                                               ?.success
        //                                               ?.items?[index]
        //                                               .price ??
        //                                           '',
        //                                       title: productByServiceModel
        //                                               ?.success
        //                                               ?.items?[index]
        //                                               .name ??
        //                                           '',
        //                                       id: productByServiceModel?.success
        //                                               ?.items?[index].id ??
        //                                           0,
        //                                     ),
        //                                   ),
        //                                 );
        //                               }),
        //                         ),
        //                       );
        //                     }
        //                     return Container();
        //                   },
        //                 ),
        //               );
        //             }
        //             return Container();
        //           },
        //         ),
        //       ),
        //       SizedBox(
        //         height: 20.h,
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }

  TextButton textButtonModel(name, index, id) {
    return TextButton(
      onPressed: () {
        setState(() {
          pageIndex = index;
          serviceId = id;
          _fetchedProductRequest = _getProductsData(0);
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
