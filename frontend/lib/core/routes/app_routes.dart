import 'package:flutter/material.dart';

import '../../pages/loading/loading_screen.dart';
import '../../pages/landing/landing_page.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/register_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/hotel/detail_hotel_page.dart';
import '../../pages/booking/choose_date_page.dart';
import '../../pages/booking/request_booking_page.dart';
import '../../pages/payment/payment_method_page.dart';
import '../../pages/payment/waiting_payment_page.dart';
import '../../pages/voucher/voucher_page.dart';
import '../../pages/voucher/voucher_pdf_preview_page.dart';

class AppRoutes {
  static const String loading = '/loading';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String hotelDetail = '/hotel-detail';
  static const String chooseDate = '/choose-date';
  static const String requestBooking = '/request-booking';
  static const String paymentMethod = '/payment-method';
  static const String waitingPayment = '/waiting-payment';
  static const String voucher = '/voucher';
  static const String voucherPdf = '/voucher-pdf';

  static final Map<String, WidgetBuilder> routes = {
    landing: (_) => const LandingPage(),
    loading: (context) => const LoadingScreen(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    home: (context) => const HomePage(),
    hotelDetail: (context) => const DetailHotelPage(),
    chooseDate: (context) => const ChooseDatePage(),
    requestBooking: (context) => const RequestBookingPage(),
    paymentMethod: (context) => const PaymentMethodPage(),
    waitingPayment: (context) => const WaitingPaymentPage(),
    voucher: (context) => const VoucherPage(),
    voucherPdf: (context) => const VoucherPdfPreviewPage(),
  };
}
