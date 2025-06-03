
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/fetch_rating_avg_cubit/fetch_rating_avg_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/service_widget/service_pageone/service_accordion_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/service_widget/service_pageone/service_review_botomsheet.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/settings_widget/setting_booking_detail_widget/detail_customs_cards_widget.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingAndReviewWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  const RatingAndReviewWidget(
      {super.key, required this.screenHeight, required this.screenWidth});

  @override
  State<RatingAndReviewWidget> createState() => _RatingAndReviewWidgetState();
}

class _RatingAndReviewWidgetState extends State<RatingAndReviewWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchRatingAvgCubit>().avgRatingAndReview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * .04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ratings & Reviews',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      profileviewWidget(
                        widget.screenWidth,
                        context,
                        Icons.verified,
                        'by varified Customers',
                        textColor: AppPalette.greyClr,
                        AppPalette.blueClr,
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        showReviewDetisSheet(
                            context, widget.screenHeight, widget.screenHeight);
                      },
                      icon: Icon(Icons.arrow_forward_ios_rounded))
                ],
              ),
              ConstantWidgets.hight30(context),
              BlocBuilder<FetchRatingAvgCubit, FetchRatingAvgState>(
                builder: (context, state) {
                  if (state is FetchRatingAvgSuccess) {
                    return Row(
                      children: [
                        Text('${state.avg} / 5',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
                        ConstantWidgets.width20(context),
                        RatingBarIndicator(
                          rating: state.avg,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: AppPalette.blackClr,
                          ),
                          itemCount: 5,
                          itemSize: 25.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Text('0.0 / 5',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                      ConstantWidgets.width20(context),
                      RatingBarIndicator(
                        rating: 0.0,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: AppPalette.blackClr,
                        ),
                        itemCount: 5,
                        itemSize: 25.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  );
                },
              ),
              ConstantWidgets.hight10(context),
              Text(
                'Ratings and reiews are varified and are from people who use the same type of device that you use ⓘ',
              ),
              Divider(),
              ConstantWidgets.hight20(context),
              ServiceAccordionWidget()
            ],
          ),
        ));
  }
}
