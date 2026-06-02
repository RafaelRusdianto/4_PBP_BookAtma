// import 'package:flutter/material.dart';
// import 'core/routes/app_routes.dart';
// import 'core/theme/app_colors.dart';

// void main() {
//   runApp(const BookAtmaApp());
// }

// class BookAtmaApp extends StatelessWidget {
//   const BookAtmaApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'BookAtma',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.white,

//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 15,
//           ),

//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: AppColors.border),
//           ),

//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: AppColors.border),
//           ),

//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
//           ),
//         ),

//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
//       ),
//       initialRoute: AppRoutes.loading,
//       routes: AppRoutes.routes,
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'pages/home/home_page.dart';
import 'pages/hotel/detail_hotel_page.dart';
import 'pages/booking/choose_date_page.dart';
import 'pages/booking/request_booking_page.dart';
import 'pages/payment/payment_method_page.dart';
import 'pages/payment/waiting_payment_page.dart';
import 'pages/voucher/voucher_page.dart';
import 'pages/voucher/voucher_pdf_preview_page.dart';

void main() {
  runApp(const BookAtmaApp());
}

class BookAtmaApp extends StatelessWidget {
  const BookAtmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookAtma',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/hotel-detail': (context) => const DetailHotelPage(),
        '/choose-date': (context) => const ChooseDatePage(),
        '/request-booking': (context) => const RequestBookingPage(),
        '/payment-method': (context) => const PaymentMethodPage(),
        '/waiting-payment': (context) => const WaitingPaymentPage(),
        '/voucher': (context) => const VoucherPage(),
        '/voucher-pdf': (context) => const VoucherPdfPreviewPage(),
      },
    );
  }
}