
import 'package:accordion/accordion.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/pages/home/notification_screen/notification_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/pages/home/wallet_screen/wallet_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/pages/revenue/revenue_trackr_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/bookings_screen/bookings_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/help_screen/help_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/service_management_screen/service_manage_screen.dart';
import 'package:barber_pannel/cavlog/app/presentation/screens/settings/time_management_screen/time_management_screen.dart';
import 'package:barber_pannel/core/themes/colors.dart' show AppPalette;
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceAccordionWidget extends StatelessWidget {
  const ServiceAccordionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Accordion(
      paddingListTop: 0,
      paddingListBottom: 0,
      maxOpenSections: 1,
      headerBackgroundColorOpened: Colors.black54,
      headerPadding:const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      children: [
        AccordionSection(
          isOpen: true,
          onCloseSection: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) =>  HelpScreen()));
          },
          leftIcon:const Icon(Icons.help_outlined, color: Colors.white),
          headerBackgroundColor: AppPalette.buttonClr,
          headerBorderColor: AppPalette.hintClr,
          headerBackgroundColorOpened: AppPalette.buttonClr,
          header: const Text(
            'Need Help?',
          ),
          content: Row(
            children: [
              Icon(Icons.smart_toy, color: AppPalette.hintClr),
              ConstantWidgets.width20(context),
              Flexible(
                  flex: 1,
                  child: Text(
                    'Got questions? Your AI assistant is here to help! Explore tips, get instant answers, and enjoy a smarter, easier experience.',
                  ))
            ],
          ),
          contentHorizontalPadding: 10,
          contentBorderColor: AppPalette.buttonClr,
        ),
        AccordionSection(
          isOpen: true,
          onCloseSection: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TimeManagementScreen()));
          },
          leftIcon:const Icon(Icons.more_time_sharp, color: Colors.white),
          headerBackgroundColor: AppPalette.buttonClr,
          headerBorderColor: AppPalette.hintClr,
          headerBackgroundColorOpened: AppPalette.buttonClr,
          header: const Text('Time and Slot Management',),
          content: const Text('Efficiently manage your time and available slots with smart auto-generation based on real-time availability. Ensure smooth scheduling and reduce conflicts through intelligent slot handling.'),
          contentHorizontalPadding: 10,
          contentBorderColor: AppPalette.buttonClr,
        ),
        AccordionSection(
          isOpen: true,
          onCloseSection: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingsScreen()));
          },
          leftIcon: const Icon(CupertinoIcons.calendar_circle_fill,
              color: Colors.white),
          headerBackgroundColor: AppPalette.buttonClr,
          headerBorderColor: AppPalette.hintClr,
          headerBackgroundColorOpened: AppPalette.buttonClr,
          header: const Text(
            'Booking Management',
          ),
          content: const Text(
              "'Booking Overview', Keep full control of your appointments. monitor booking statuses, access client details, and ensure a smooth shedule every day"),
          contentHorizontalPadding: 10,
          contentBorderColor: AppPalette.buttonClr,
        ),
        AccordionSection(
          isOpen: true,
          onCloseSection: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RevenueTrackrScreen()));
          },
          leftIcon: const Icon(Icons.pie_chart_rounded,
              color: Colors.white),
          headerBackgroundColor: AppPalette.buttonClr,
          headerBorderColor: AppPalette.hintClr,
          headerBackgroundColorOpened: AppPalette.buttonClr,
          header: const Text(
            'Track and Analyze Revenue',
          ),
          content: Row(
            children: [
              Icon(Icons.stacked_line_chart_outlined,
                  color: AppPalette.hintClr),
              ConstantWidgets.width20(context),
              Flexible(
                  flex: 1,
                  child: Text(
                    'Easily track your earnings with custom date filters. See how your revenue changes over time and compare it with previous days to stay on top of your progress.',
                  ))
            ],
          ),
          contentHorizontalPadding: 10,
          contentBorderColor: AppPalette.buttonClr,
        ),
        AccordionSection(
          isOpen: true,
          onCloseSection: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WalletScreen()));
          },
          leftIcon: const Icon(Icons.account_balance_wallet_rounded,
              color: Colors.white),
          headerBackgroundColor: AppPalette.buttonClr,
          headerBorderColor: AppPalette.hintClr,
          headerBackgroundColorOpened: AppPalette.buttonClr,
          header: const Text(
            'Check My wallet',
          ),
          content: const Text(
              "Manage your wallet effortlessly-check history, monitor payments, and top up in secounds."),
          contentHorizontalPadding: 10,
          contentBorderColor: AppPalette.buttonClr,
        ),
        AccordionSection(
          isOpen: true,
          onCloseSection: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ServiceManageScreen()));
          },
          leftIcon: const Icon(CupertinoIcons.wrench_fill,
              color: Colors.white),
          headerBackgroundColor: AppPalette.buttonClr,
          headerBorderColor: AppPalette.hintClr,
          headerBackgroundColorOpened: AppPalette.buttonClr,
          header: const Text(
            'Service Management',
          ),
          content: const Text(
              "Craft your perfect service lineup - add, update, or fine-tune offerings to match your brand's style."),
          contentHorizontalPadding: 10,
          contentBorderColor: AppPalette.buttonClr,
        ),
        AccordionSection(
          isOpen: true,
          onCloseSection: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotifcationScreen()));
          },
          leftIcon: const Icon(Icons.notifications_active_rounded,
              color: Colors.white),
          headerBackgroundColor: AppPalette.buttonClr,
          headerBorderColor: AppPalette.hintClr,
          headerBackgroundColorOpened: AppPalette.buttonClr,
          header: const Text(
            'Notifications',
          ),
          content: const Text(
              "Stay updated with important booking alerts, including pending and confirmed appointments."),
          contentHorizontalPadding: 10,
          contentBorderColor: AppPalette.buttonClr,
        ),
      ],
    );
  }
}
