import 'package:kopokopo/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:kopokopo/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:kopokopo/ui/views/home/home_view.dart';
import 'package:kopokopo/ui/views/startup/startup_view.dart';
import 'package:kopokopo/ui/views/splash/splash_view.dart';
import 'package:kopokopo/ui/views/conference/conference_home_view.dart';
import 'package:kopokopo/ui/views/payment/payment_view.dart';
import 'package:kopokopo/ui/views/payment_tracking/payment_tracking_view.dart';
import 'package:kopokopo/ui/views/payment_history/payment_history_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: ConferenceHomeView),
    MaterialRoute(page: PaymentView),
    MaterialRoute(page: PaymentTrackingView),
    MaterialRoute(page: PaymentHistoryView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
