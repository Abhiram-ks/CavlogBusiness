import 'package:barber_pannel/cavlog/app/presentation/widgets/revenue_widget/revenue_track_custom_widget.dart';
import 'package:barber_pannel/core/common/custom_app_bar.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/revenue_widget/revenue_cards_custom_widget.dart';

class RevenueScreen extends StatelessWidget {
  const RevenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
     builder: (context, constraints) {
      double screenHeight = constraints.maxHeight;
      double screenWidth = constraints.maxWidth;

      return ColoredBox(
        color: AppPalette.hintClr,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
                child: Column(
                  children: [
                    ConstantWidgets.hight30(context),
                    RevanueContainer(screenWidth: screenWidth, screenHeight: screenHeight),
                    ConstantWidgets.hight10(context),
                     SizedBox(
                          width: double.infinity,
                  height: screenHeight * 0.9,
                       child: GridView.count(
                                           crossAxisCount: 2,
                                           crossAxisSpacing:6,
                                           mainAxisSpacing:6,
                                           addAutomaticKeepAlives: true,
                                           addRepaintBoundaries: true,
                                            children: [
                              RevenueDetailsContainer(
                             gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 30, 104, 32),
                                  Color.fromARGB(255, 184, 255, 186),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              screenHeight: MediaQuery.of(context).size.height,
                            screenWidth: MediaQuery.of(context).size.width,
                              title: 'Total Revenu',
                              description: 'A clear snapshot of your earnings.',
                              icon: Icons.currency_rupee_sharp,
                              salesText: '₹ 1400000',
                              iconColor: const Color.fromARGB(255, 160, 196, 139),
                          ),
                            
                           RevenueDetailsContainer(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 14, 72, 119),
                                Color.fromARGB(255, 160, 212, 255)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            screenHeight: MediaQuery.of(context).size.height,
                            screenWidth: MediaQuery.of(context).size.width,
                            title: 'Today’s Earnings',
                            description: 'A focused glimpse of your daily hustle.',
                            icon: Icons.shopping_basket,
                            salesText:  '₹ 12,3000',
                            iconColor: const Color.fromARGB(255, 118, 171, 215),
                          ),
                           RevenueDetailsContainer(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.orange,
                                Color.fromARGB(255, 255, 220, 164)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            screenHeight: MediaQuery.of(context).size.height,
                            screenWidth: MediaQuery.of(context).size.width,
                            title: 'Total Services',
                            description: "The total count of every service you’ve provided",
                            icon: CupertinoIcons.wrench_fill,
                            salesText:'5',
                            iconColor: const Color.fromARGB(255, 255, 225, 181),
                          ),
                           RevenueDetailsContainer(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.purple,
                                Color.fromARGB(255, 245, 186, 255),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            screenHeight: MediaQuery.of(context).size.height,
                            screenWidth: MediaQuery.of(context).size.width,
                            title: 'Total Customers',
                            description: 'The clients who’ve chosen you as their go-to barber',
                            icon: Icons.people,
                            salesText: '23',
                            iconColor: const Color.fromARGB(255, 248, 181, 255),
                          
                        ),


                         RevenueDetailsContainer(
                            gradient: const LinearGradient(
                              colors: [
                                  Colors.red, 
                                Color.fromARGB(255, 255, 181, 181),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            screenHeight: MediaQuery.of(context).size.height,
                            screenWidth: MediaQuery.of(context).size.width,
                            title: 'Work Legacy',
                            description: "The accumulated hours of your craft, reflecting a lifetime of skill and passion.",
                            icon: CupertinoIcons.timer_fill,
                            salesText:'5',
                            iconColor: const Color.fromARGB(255, 255, 181, 181),
                          ),
                           RevenueDetailsContainer(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 60, 39, 176),
                                Color.fromARGB(255, 192, 186, 255),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            screenHeight: MediaQuery.of(context).size.height,
                            screenWidth: MediaQuery.of(context).size.width,
                            title: 'Total Bookings',
                            description: 'Every booking is a step towards building your success.',
                            icon: Icons.book ,
                            salesText: '43',
                            iconColor: const Color.fromARGB(255, 187, 181, 255),
                          
                        ),
                                           ],
                                         ),
                     ),
                  ],
                ),
              ),
            ),
          )
        ),
      );
     },
    );
  }
}