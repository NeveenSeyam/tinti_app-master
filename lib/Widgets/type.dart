import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Widgets/text_widget.dart';

import '../Helpers/failure.dart';
import '../provider/services_provider.dart';
import 'loader_widget.dart';

class typeWidget extends ConsumerStatefulWidget {
  const typeWidget({super.key});

  @override
  _typeWidgetState createState() => _typeWidgetState();
}

class _typeWidgetState extends ConsumerState<typeWidget> {
  int pageIndex = 1;
  Future _getContentData() async {
    final prov = ref.read(servicesProvider);

    return await prov.getServiecesDataRequset();
  }

  late Future _fetchedMyRequest;

  @override
  void initState() {
    _fetchedMyRequest = _getContentData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      height: 40.h,
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
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data is Failure) {
                return Center(child: TextWidget(snapshot.data.toString()));
              }
              //
              //  print("snapshot data is ${snapshot.data}");

              var serviecesModel = ref.watch(servicesProvider).getDataList;

              return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: serviecesModel?.services?.length,
                  itemBuilder: (BuildContext context, int index) =>
                      textButtonModel(serviecesModel?.services?[index].name,
                          serviecesModel?.services?[index].id));
            }
            return Container();
          },
        ),
      ),
    );
  }

  TextButton textButtonModel(name, index) {
    return TextButton(
      onPressed: () {
        setState(() {
          pageIndex = index;
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
