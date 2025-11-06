import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/kopokopo_service.dart';
import '../../../config/app_config.dart';

class SplashViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _kopokopoService = KopokopoService.instance;

  String _statusMessage = 'Initializing...';
  String get statusMessage => _statusMessage;

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2)); // Show splash animation

    _statusMessage = 'Checking configuration...';
    rebuildUi();
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if app is configured
    if (!AppConfig.isConfigured) {
      await _showConfigurationWarning();
    }

    _statusMessage = 'Setting up payment gateway...';
    rebuildUi();
    await Future.delayed(const Duration(milliseconds: 500));

    // Initialize Kopo Kopo SDK
    try {
      await _kopokopoService.initialize();
    } catch (e) {
      await _dialogService.showDialog(
        title: 'Initialization Error',
        description: 'Failed to initialize payment service: $e',
      );
    }

    _statusMessage = 'Ready!';
    rebuildUi();
    await Future.delayed(const Duration(milliseconds: 500));

    // Navigate to conference home
    _navigationService.replaceWithConferenceHomeView();
  }

  Future<void> _showConfigurationWarning() async {
    await _dialogService.showDialog(
      title: '⚠️ Configuration Required',
      description:
          'Please configure your Kopo Kopo credentials in the .env file. '
          'Copy env_example.txt to .env and add your credentials.\n\n'
          'The app will work in demo mode for now.',
    );
  }
}

