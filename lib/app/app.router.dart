// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i9;
import 'package:flutter/material.dart';
import 'package:kopokopo/models/payment_record.dart' as _i11;
import 'package:kopokopo/models/ticket_type.dart' as _i10;
import 'package:kopokopo/ui/views/conference/conference_home_view.dart' as _i3;
import 'package:kopokopo/ui/views/home/home_view.dart' as _i7;
import 'package:kopokopo/ui/views/payment/payment_view.dart' as _i4;
import 'package:kopokopo/ui/views/payment_history/payment_history_view.dart'
    as _i6;
import 'package:kopokopo/ui/views/payment_tracking/payment_tracking_view.dart'
    as _i5;
import 'package:kopokopo/ui/views/splash/splash_view.dart' as _i2;
import 'package:kopokopo/ui/views/startup/startup_view.dart' as _i8;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i12;

class Routes {
  static const splashView = '/';

  static const conferenceHomeView = '/conference-home-view';

  static const paymentView = '/payment-view';

  static const paymentTrackingView = '/payment-tracking-view';

  static const paymentHistoryView = '/payment-history-view';

  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const all = <String>{
    splashView,
    conferenceHomeView,
    paymentView,
    paymentTrackingView,
    paymentHistoryView,
    homeView,
    startupView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.splashView,
      page: _i2.SplashView,
    ),
    _i1.RouteDef(
      Routes.conferenceHomeView,
      page: _i3.ConferenceHomeView,
    ),
    _i1.RouteDef(
      Routes.paymentView,
      page: _i4.PaymentView,
    ),
    _i1.RouteDef(
      Routes.paymentTrackingView,
      page: _i5.PaymentTrackingView,
    ),
    _i1.RouteDef(
      Routes.paymentHistoryView,
      page: _i6.PaymentHistoryView,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i7.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i8.StartupView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.SplashView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.SplashView(),
        settings: data,
      );
    },
    _i3.ConferenceHomeView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.ConferenceHomeView(),
        settings: data,
      );
    },
    _i4.PaymentView: (data) {
      final args = data.getArgs<PaymentViewArguments>(nullOk: false);
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i4.PaymentView(key: args.key, ticket: args.ticket),
        settings: data,
      );
    },
    _i5.PaymentTrackingView: (data) {
      final args = data.getArgs<PaymentTrackingViewArguments>(nullOk: false);
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.PaymentTrackingView(
            key: args.key, paymentRecord: args.paymentRecord),
        settings: data,
      );
    },
    _i6.PaymentHistoryView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.PaymentHistoryView(),
        settings: data,
      );
    },
    _i7.HomeView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.HomeView(),
        settings: data,
      );
    },
    _i8.StartupView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.StartupView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class PaymentViewArguments {
  const PaymentViewArguments({
    this.key,
    required this.ticket,
  });

  final _i9.Key? key;

  final _i10.TicketType ticket;

  @override
  String toString() {
    return '{"key": "$key", "ticket": "$ticket"}';
  }

  @override
  bool operator ==(covariant PaymentViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.ticket == ticket;
  }

  @override
  int get hashCode {
    return key.hashCode ^ ticket.hashCode;
  }
}

class PaymentTrackingViewArguments {
  const PaymentTrackingViewArguments({
    this.key,
    required this.paymentRecord,
  });

  final _i9.Key? key;

  final _i11.PaymentRecord paymentRecord;

  @override
  String toString() {
    return '{"key": "$key", "paymentRecord": "$paymentRecord"}';
  }

  @override
  bool operator ==(covariant PaymentTrackingViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.paymentRecord == paymentRecord;
  }

  @override
  int get hashCode {
    return key.hashCode ^ paymentRecord.hashCode;
  }
}

extension NavigatorStateExtension on _i12.NavigationService {
  Future<dynamic> navigateToSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToConferenceHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.conferenceHomeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPaymentView({
    _i9.Key? key,
    required _i10.TicketType ticket,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.paymentView,
        arguments: PaymentViewArguments(key: key, ticket: ticket),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPaymentTrackingView({
    _i9.Key? key,
    required _i11.PaymentRecord paymentRecord,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.paymentTrackingView,
        arguments: PaymentTrackingViewArguments(
            key: key, paymentRecord: paymentRecord),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPaymentHistoryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.paymentHistoryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithConferenceHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.conferenceHomeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPaymentView({
    _i9.Key? key,
    required _i10.TicketType ticket,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.paymentView,
        arguments: PaymentViewArguments(key: key, ticket: ticket),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPaymentTrackingView({
    _i9.Key? key,
    required _i11.PaymentRecord paymentRecord,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.paymentTrackingView,
        arguments: PaymentTrackingViewArguments(
            key: key, paymentRecord: paymentRecord),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPaymentHistoryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.paymentHistoryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
