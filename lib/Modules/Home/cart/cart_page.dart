import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/provider/order_provider.dart';

import '../../../Helpers/failure.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/order_list_card.dart';
import '../../../Widgets/text_widget.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  Future _getordersData() async {
    final prov = ref.read(ordersProvider);

    return await prov.getOrderDataRequset();
  }

  late Future _fetchedOrderRequest;

  @override
  void initState() {
    _fetchedOrderRequest = _getordersData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          "طلباتي",
          isProfile: false,
          isNotification: false,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _fetchedOrderRequest = _getordersData();
            });
            return _fetchedOrderRequest;
          },
          child: Consumer(
            builder: (context, ref, child) => FutureBuilder(
              future: _fetchedOrderRequest,
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
                    return Center(child: TextWidget(snapshot.data.toString()));
                  }
                  //
                  //  print("snapshot data is ${snapshot.data}");

                  var ordersModel = ref.watch(ordersProvider).getOrdersDataList;

                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: ordersModel?.orders?.length,
                    itemBuilder: (BuildContext context, int index) => OrderListCard(
                        image: ordersModel?.orders?[index].image ??
                            'assets/images/sa1.jpeg',
                        title: ordersModel?.orders?[index].name ??
                            'تنظيف بالبخار ',
                        compeny: ordersModel?.orders?[index].company ??
                            'شركة ليومار',
                        details: ordersModel?.orders?[index].description ??
                            'تلعب العناية المنتظمة بالسيارة دورا كبيرا في المحافظة على السيارات وهذا هو السبب الذي يجعل بعض السيارات تستمر   ',
                        price: ordersModel?.orders?[index].price.toString() ??
                            '460'),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
