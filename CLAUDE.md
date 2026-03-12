# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Cric Spot is a Flutter cricket scoring app with offline-first design. It handles team management, match creation, live scorekeeping, and match history. All data is stored locally using Hive (no backend/API).

## Build & Run Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run code generation (freezed models, Hive adapters, MobX stores, JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes during development
dart run build_runner watch --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test

# Run a single test
flutter test test/widget_test.dart
```

## Architecture

### State Management: MobX
- Stores live in `lib/store/` with the `_Store with Store` mixin pattern
- Each store has a `.g.dart` generated file (run build_runner after modifying stores)
- Three stores: `HomeStore` (match/team management), `ScoreStore` (scoring logic), `TeamStore` (team operations)
- Stores are provided via `Provider` in `app.dart`

### Data Layer: Hive
- Models in `lib/model/` use `@HiveType` annotations with Freezed (`@unfreezed`)
- Each model has `.freezed.dart` and `.g.dart` generated files
- Hive adapters registered in `lib/dependency_injection/module/hive_module.dart`
- Box types defined in `lib/core/enum/box_type.dart`
- Domain models: Team, Player, Match, Inning, BattingLineUp, BowlingLineUp, ExtraRun, PartnerShip

### Dependency Injection: GetIt
- Global `getIt` instance in `main.dart`
- Hive boxes registered as async singletons, stores as regular singletons in `lib/dependency_injection/service_locator.dart`
- Initialization order: Hive adapters -> Hive boxes -> Stores

### Routing: GoRouter
- Routes defined in `lib/config/routes.dart`, route names in `lib/config/routes_name.dart`
- Uses path parameters for `matchId` and `run`

### UI Structure
- `lib/ui/home/` - Home, history, new match, teams pages
- `lib/ui/score/` - Score counting, scoreboard, winning pages
- `lib/ui/player/` - Player selection, bowler selection, fall of wicket
- `lib/ui/settings/` - Advanced match settings

### Theming
- Material 3 with dynamic color support (`dynamic_color` package)
- Google Fonts (Outfit) configured in `app.dart`
- Theme builder in `lib/core/theme/app_theme.dart`

## Key Conventions

- Models use Freezed `@unfreezed` (mutable) since Hive requires mutability
- Always run `build_runner` after modifying any model or store file
- Shared widgets are in `lib/core/widgtes/cric_widgets/`
- SDK constraint: `>=3.1.0 <4.0.0`



# CEPS Flutter Project - Architecture Reference Guide

> Use this document as a blueprint to transform CricSpot Flutter project into this exact folder structure with BLoC pattern.

---

## 1. COMPLETE FOLDER STRUCTURE

```
lib/
├── main.dart                              # Entry point
├── app.dart                               # Root widget (MultiBlocProvider + MaterialApp.router)
│
├── configs/
│   └── injector/
│       ├── injector.dart                  # Barrel exports for DI packages
│       └── injector_conf.dart             # GetIt registration (all singletons, factories)
│
├── core/
│   ├── api/
│   │   ├── api_exception.dart             # Exception hierarchy (BadRequest, Unauthorized, etc.)
│   │   ├── api_helper.dart                # Centralized HTTP client (post, get, put, delete)
│   │   ├── api_interceptor.dart           # Dio interceptor (base URL, error logging)
│   │   ├── api_response.dart              # Generic ApiResponse<T> wrapper
│   │   ├── api_url.dart                   # Base URL + all endpoint constants
│   │   ├── network_service.dart           # Connectivity check (static methods)
│   │   ├── request_builder.dart           # Header builder, FormData builder, logging
│   │   └── response_handler.dart          # HTTP status code handler (200/400/401/500)
│   │
│   ├── constants/
│   │   └── app_assets.dart                # Asset path constants (images, SVGs)
│   │
│   ├── errors/
│   │   ├── exceptions.dart                # Domain exceptions (ServerException, CacheException)
│   │   └── failures.dart                  # Sealed failure classes with Equatable
│   │
│   ├── extensions/
│   │   ├── context_extension.dart         # BuildContext shortcuts (theme, text styles)
│   │   ├── extension.dart                 # General extensions barrel
│   │   ├── size_extension.dart            # Responsive sizing (.w, .h, .sp, .r)
│   │   └── text_style_extention.dart      # TextStyle weight/color shortcuts
│   │
│   ├── network/
│   │   └── network_checker.dart           # NetworkInfo with Either<Failure, T>
│   │
│   ├── service/
│   │   ├── permission_service.dart        # Device permission handling
│   │   ├── secure_storage_service.dart    # flutter_secure_storage wrapper
│   │   └── shared_pref/
│   │       ├── constant.dart              # SharedPreferences key constants
│   │       ├── shared_prefrence_helper.dart    # Low-level get/set operations
│   │       └── shared_prefrence_repository.dart # High-level methods (login, logout, token)
│   │
│   ├── themes/
│   │   ├── app_color.dart                 # All color constants (primary, secondary, etc.)
│   │   ├── app_font.dart                  # Font family base styles
│   │   ├── app_text_style.dart            # 12-level typography scale (display→label)
│   │   └── app_theme.dart                 # ThemeData with Material 3
│   │
│   └── utils/
│       ├── logger.dart                    # Logger with PrettyPrinter
│       └── validator.dart                 # Form validation + input formatters
│
├── features/
│   ├── <feature_name>/                    # Each feature follows this structure:
│   │   ├── bloc/
│   │   │   ├── <feature>_bloc.dart        # BLoC class with event handlers
│   │   │   ├── <feature>_event.dart       # Sealed/abstract event classes
│   │   │   └── <feature>_state.dart       # State class(es)
│   │   ├── model/
│   │   │   └── <name>_model.dart          # Data models with fromJson/toJson
│   │   ├── repository/
│   │   │   └── <feature>_repository.dart  # Data access layer (API calls)
│   │   └── screens/
│   │       ├── <name>_screen.dart         # UI screens
│   │       └── widget/                    # Feature-specific widgets (optional)
│   │           └── <name>_widget.dart
│   │
│   ├── auth/                              # EXAMPLE: Authentication feature
│   │   ├── bloc/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── model/
│   │   │   ├── login_model.dart
│   │   │   ├── user_model.dart
│   │   │   └── verify_otp_model.dart
│   │   ├── repository/
│   │   │   └── auth_repository.dart
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       ├── splash_screen.dart
│   │       └── verification_code_screen.dart
│   │
│   ├── home/                              # EXAMPLE: Home feature
│   │   ├── bloc/
│   │   │   ├── home_bloc.dart
│   │   │   ├── home_event.dart
│   │   │   └── home_state.dart
│   │   ├── model/
│   │   │   ├── category_model.dart
│   │   │   └── service_model.dart
│   │   ├── repository/
│   │   │   └── service_repository.dart
│   │   └── screens/
│   │       ├── home_screen.dart
│   │       └── widget/
│   │           └── service_list_section_widget.dart
│   │
│   ├── cart/                              # Feature without BLoC (screens only)
│   │   └── screens/
│   │       ├── cart_screen.dart
│   │       └── checkout_cart_screen.dart
│   │
│   └── service/                           # Feature without BLoC (screens only)
│       └── screens/
│           ├── service_detail_screen.dart
│           └── sub_category_screen.dart
│
├── routes/
│   ├── app_route_conf.dart                # GoRouter configuration with ShellRoute
│   ├── app_route_path.dart                # Route enum with paths
│   └── routes.dart                        # Barrel file
│
└── widgets/                               # Shared/global reusable widgets
    ├── app_textform_feild.dart             # CommonTextField with factory constructors
    ├── app_toast.dart                      # AppToast (success, error, warning)
    ├── bottom_nav_wrapper.dart             # Bottom navigation bar
    ├── button_widget.dart                  # CommonButton, CommonOutlinedButton
    ├── common_app_bar.dart                 # CustomAppBar, CommonAppBar
    └── safe_scaffold.dart                  # SafeScaffold wrapper

assets/
├── images/                                # PNG raster images
├── svgs/                                  # SVG vector graphics
└── json/                                  # JSON data files
```

---

## 2. DEPENDENCIES (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7

  # Routing
  go_router: ^16.3.0

  # Dependency Injection
  get_it: ^9.0.5

  # Networking
  dio: ^5.9.0
  connectivity_plus: ^6.1.6
  internet_connection_checker: ^3.0.1

  # Storage
  shared_preferences: ^2.5.3
  flutter_secure_storage: ^9.2.4

  # Functional Programming
  fpdart: ^1.1.1

  # UI
  google_fonts: ^6.2.1
  flutter_svg: ^2.1.0
  pinput: ^5.1.1
  dropdown_textfield: ^1.1.1
  fluttertoast: ^8.2.12

  # Permissions & Location
  permission_handler: ^11.4.0
  geolocator: ^14.0.0
  geocoding: ^3.0.0

  # Logging
  logger: ^2.5.0
```

---

## 3. ARCHITECTURE PATTERNS WITH FULL EXAMPLES

### 3.1 Entry Point — main.dart

```dart
import 'package:flutter/material.dart';
import 'configs/injector/injector_conf.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDepedencies();
  runApp(const MyApp());
}
```

### 3.2 Root Widget — app.dart

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt.get<AuthBloc>()),
        // Add more global BLoCs here
      ],
      child: MaterialApp.router(
        title: 'AppName',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

### 3.3 Dependency Injection — injector_conf.dart

```dart
final getIt = GetIt.I;

void configureDepedencies() {
  // --- Platform Services ---
  getIt.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  getIt.registerSingletonWithDependencies<SharedPreferencesHelper>(
    () => SharedPreferencesHelper(getIt<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );
  getIt.registerSingletonWithDependencies<SharedPreferencesRepository>(
    () => SharedPreferencesRepository(getIt<SharedPreferencesHelper>()),
    dependsOn: [SharedPreferencesHelper],
  );

  // --- Network ---
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton(() => SecureStorageService());
  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  getIt.registerLazySingleton(() => NetworkInfo(getIt<InternetConnectionChecker>()));
  getIt.registerLazySingleton(() => ApiInterceptor());
  getIt.registerLazySingleton(() => Dio()..interceptors.add(getIt<ApiInterceptor>()));
  getIt.registerLazySingleton(() => ApiHelper(getIt<Dio>()));

  // --- Repositories ---
  getIt.registerLazySingleton<ServiceRepository>(() => ServiceRepositoryImpl());
  getIt.registerLazySingleton(() => AuthRepository());

  // --- BLoCs ---
  getIt.registerLazySingleton(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory(() => HomeBloc(getIt<ServiceRepository>()));
  // registerLazySingleton = BLoC persists across screens (auth, user session)
  // registerFactory = new BLoC instance per screen (home, listing pages)
}
```

### 3.4 BLoC — Events

```dart
// file: lib/features/<feature>/bloc/<feature>_event.dart
sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class SubmitPhoneNumberEvent extends AuthEvent {
  final String phoneNumber;
  const SubmitPhoneNumberEvent({required this.phoneNumber});
  @override
  List<Object?> get props => [phoneNumber];
}

class SubmitVerificationCodeEvent extends AuthEvent {
  final String verificationCode;
  const SubmitVerificationCodeEvent({required this.verificationCode});
  @override
  List<Object?> get props => [verificationCode];
}

class StartTimerEvent extends AuthEvent {
  const StartTimerEvent();
}

class ResendCodeEvent extends AuthEvent {
  final String phoneNumber;
  const ResendCodeEvent({required this.phoneNumber});
  @override
  List<Object?> get props => [phoneNumber];
}
```

### 3.5 BLoC — State (Single State with copyWith) — use for forms/auth

```dart
// file: lib/features/<feature>/bloc/<feature>_state.dart
class AuthState extends Equatable {
  final String phoneNumber;
  final String verificationCode;
  final bool isLoading;
  final String? error;
  final int remainingSeconds;
  final bool isTimerActive;

  const AuthState({
    this.phoneNumber = '',
    this.verificationCode = '',
    this.isLoading = false,
    this.error,
    this.remainingSeconds = 120,
    this.isTimerActive = false,
  });

  bool get canResendCode => !isTimerActive && remainingSeconds == 0;

  String get formattedTimer {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  AuthState copyWith({
    String? phoneNumber,
    String? verificationCode,
    bool? isLoading,
    String? error,
    int? remainingSeconds,
    bool? isTimerActive,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationCode: verificationCode ?? this.verificationCode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isTimerActive: isTimerActive ?? this.isTimerActive,
    );
  }

  @override
  List<Object?> get props => [phoneNumber, verificationCode, isLoading, error, remainingSeconds, isTimerActive];
}
```

### 3.6 BLoC — State (Multiple State Classes) — use for data loading

```dart
// file: lib/features/<feature>/bloc/<feature>_state.dart
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  const HomeLoaded({required this.categories});
  @override
  List<Object?> get props => [categories];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});
  @override
  List<Object?> get props => [message];
}
```

### 3.7 BLoC — Bloc Class

```dart
// file: lib/features/<feature>/bloc/<feature>_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final verificationCodeController = TextEditingController();
  Timer? _timer;

  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<SubmitPhoneNumberEvent>(_onSubmitPhoneNumber);
    on<SubmitVerificationCodeEvent>(_onSubmitVerificationCode);
    on<StartTimerEvent>(_onStartTimer);
    on<TimerTickEvent>(_onTimerTick);
    on<ResendCodeEvent>(_onResendCode);
  }

  Future<void> _onSubmitPhoneNumber(SubmitPhoneNumberEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, phoneNumber: event.phoneNumber));
    try {
      final response = await _authRepository.login(event.phoneNumber);
      emit(state.copyWith(isLoading: false));
      appRouter.push(AppRoute.verificationCode.path, extra: {"phone": event.phoneNumber});
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      AppToast.error(message: e.toString());
    }
  }

  Future<void> _onSubmitVerificationCode(SubmitVerificationCodeEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _authRepository.verifyOtp(state.phoneNumber, event.verificationCode);
      if (response.status) {
        await getIt.get<SharedPreferencesRepository>().onLoginUser(response);
        emit(state.copyWith(isLoading: false));
        appRouter.go(AppRoute.home.path);
      } else {
        emit(state.copyWith(isLoading: false));
        AppToast.error(message: response.message ?? 'Verification failed');
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      AppToast.error(message: e.toString());
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    phoneNumberController.dispose();
    verificationCodeController.dispose();
    return super.close();
  }
}
```

### 3.8 BLoC — Bloc Class (Multiple States Pattern)

```dart
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ServiceRepository _serviceRepository;

  HomeBloc(this._serviceRepository) : super(HomeInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final categories = await _serviceRepository.loadCategories();
      emit(HomeLoaded(categories: categories));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
```

### 3.9 Repository — Direct API calls

```dart
// file: lib/features/<feature>/repository/<feature>_repository.dart
class AuthRepository {
  final ApiHelper apiHelper = getIt.get<ApiHelper>();

  Future<ApiResponse<LoginModel>> login(String phoneNumber) async {
    final response = await apiHelper.post<LoginModel>(
      ApiUrl.login,
      {"phone": phoneNumber},
      passToken: false,
      fromJson: (json) => LoginModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<VerifyOtpModel>> verifyOtp(String phone, String otp) async {
    final response = await apiHelper.post<VerifyOtpModel>(
      ApiUrl.verifyOtp,
      {"phone": phone, "otp": otp},
      passToken: false,
      fromJson: (json) => VerifyOtpModel.fromJson(json),
    );
    return response;
  }
}
```

### 3.10 Repository — Interface-based (for testability)

```dart
// file: lib/features/<feature>/repository/<feature>_repository.dart
abstract class ServiceRepository {
  Future<List<CategoryModel>> loadCategories();
}

class ServiceRepositoryImpl implements ServiceRepository {
  @override
  Future<List<CategoryModel>> loadCategories() async {
    final jsonStr = await rootBundle.loadString('assets/json/product.json');
    final Map<String, dynamic> map = json.decode(jsonStr);
    final cats = (map['categories'] as List?) ?? [];
    return cats.map((e) => CategoryModel.fromJson(e)).toList();
  }
}
```

### 3.11 Model — Manual JSON serialization

```dart
// file: lib/features/<feature>/model/<name>_model.dart
class UserModel {
  String? userId;
  String? phone;
  String? email;
  String? fullName;
  String? profilePhotoUrl;
  String? createdAt;
  String? status;
  bool? kycVerified;

  UserModel({this.userId, this.phone, this.email, this.fullName,
    this.profilePhotoUrl, this.createdAt, this.status, this.kycVerified});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    phone = json['phone'];
    email = json['email'];
    fullName = json['fullName'];
    profilePhotoUrl = json['profilePhotoUrl'];
    createdAt = json['createdAt'];
    status = json['status'];
    kycVerified = json['kycVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['phone'] = phone;
    data['email'] = email;
    data['fullName'] = fullName;
    data['profilePhotoUrl'] = profilePhotoUrl;
    data['createdAt'] = createdAt;
    data['status'] = status;
    data['kycVerified'] = kycVerified;
    return data;
  }
}
```

### 3.12 Model — Nested/Composed model

```dart
class VerifyOtpModel {
  UserModel? user;
  String? token;

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    token = json['token'];
  }
}
```

### 3.13 API Layer — ApiHelper (centralized HTTP client)

```dart
// file: lib/core/api/api_helper.dart
class ApiHelper {
  final Dio _dio;
  ApiHelper(this._dio);

  Future<ApiResponse<T>> post<T>(
    String url,
    Map<String, dynamic>? body, {
    bool passToken = true,
    bool isFormData = false,
    T Function(dynamic)? fromJson,
  }) async {
    if (!await NetworkService.checkConnectivity()) {
      return ApiResponse.error(NetworkService.getNoConnectionMessage());
    }
    try {
      final headers = await RequestBuilder.buildHeaders(passToken: passToken);
      final data = isFormData ? RequestBuilder.buildFormData(body) : body;
      final response = await _dio.post(url, data: data, options: Options(headers: headers));
      final responseJson = ResponseHandler.handleResponse(response);
      return ApiResponse<T>.fromJson(responseJson, fromJsonT: fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(e.message ?? 'Network error');
    }
  }

  // Same pattern for: get<T>, put<T>, delete<T>
}
```

### 3.14 API Layer — ApiResponse wrapper

```dart
// file: lib/core/api/api_response.dart
class ApiResponse<T> {
  final bool status;
  final bool isShowMessage;
  final String? message;
  final T? data;
  final int? statusCode;

  ApiResponse({required this.status, this.isShowMessage = true,
    this.message, this.data, this.statusCode});

  factory ApiResponse.fromJson(Map<String, dynamic> json,
      {T Function(dynamic)? fromJsonT}) {
    return ApiResponse<T>(
      status: json['status'] ?? true,
      isShowMessage: json['isShowMessage'] ?? true,
      message: json['message'] ?? json['error'],
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data']) : null,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse<T>(status: false, message: message);
  }
}
```

### 3.15 API Layer — URL constants

```dart
// file: lib/core/api/api_url.dart
class ApiUrl {
  static const String baseUrl = "https://your-api.com";
  static const String api = "$baseUrl/api";
  static const String apiVersion = "$api/v1";

  // Auth
  static const String login = "$apiVersion/user/login-with-phone";
  static const String verifyOtp = "$apiVersion/user/verify-login";

  // Services
  static const String category = "$apiVersion/service-category/list";
}
```

### 3.16 API Layer — Response handler

```dart
// file: lib/core/api/response_handler.dart
class ResponseHandler {
  static dynamic handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
        _handleUnauthorized();
        return response.data;
      case 403:
        throw UnauthorizedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException('Error: ${response.statusCode}');
    }
  }
}
```

### 3.17 API Layer — Exception classes

```dart
// file: lib/core/api/api_exception.dart
class ApiException implements Exception {
  final String message;
  final String prefix;
  ApiException([this.message = "", this.prefix = ""]);
  @override
  String toString() => "$prefix$message";
}

class FetchDataException extends ApiException {
  FetchDataException([String message = ""])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends ApiException {
  BadRequestException([String message = ""])
      : super(message, "Invalid Request: ");
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = ""])
      : super(message, "Unauthorized: ");
}
```

### 3.18 API Layer — Request builder

```dart
// file: lib/core/api/request_builder.dart
class RequestBuilder {
  static Future<Map<String, String>> buildHeaders({
    bool passToken = true,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = <String, String>{"Content-Type": 'application/json'};
    if (passToken) {
      final token = getIt.get<SharedPreferencesRepository>().token;
      if (token != '') {
        headers["X-API-KEY"] = token.trim();
      }
    }
    if (additionalHeaders != null) headers.addAll(additionalHeaders);
    return headers;
  }

  static FormData? buildFormData(Map<String, dynamic>? body, {File? imageFile}) {
    final formData = FormData.fromMap(body ?? {});
    if (imageFile != null) {
      formData.files.add(MapEntry('profilePicture',
        MultipartFile.fromFileSync(imageFile.path)));
    }
    return formData;
  }
}
```

### 3.19 Routing — Route paths enum

```dart
// file: lib/routes/app_route_path.dart
enum AppRoute {
  splash(path: "/splash"),
  login(path: "/login"),
  verificationCode(path: "/verification-code/:phoneNumber"),
  home(path: "/home"),
  booking(path: "/booking"),
  chat(path: "/chat"),
  profile(path: "/profile"),
  subCategory(path: "/sub-category"),
  cart(path: "/cart"),
  checkOutCart(path: "/check-out-cart");

  final String path;
  const AppRoute({required this.path});
}
```

### 3.20 Routing — GoRouter with ShellRoute

```dart
// file: lib/routes/app_route_conf.dart
final appRouter = GoRouter(
  initialLocation: AppRoute.splash.path,
  routes: [
    // Standalone routes
    GoRoute(path: AppRoute.splash.path, builder: (_, __) => const SplashScreen()),
    GoRoute(path: AppRoute.login.path, builder: (_, __) => const LoginScreen()),

    // Route with extra data
    GoRoute(
      path: AppRoute.verificationCode.path,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>;
        return VerificationCodeScreen(phoneNumber: extra["phoneNumber"] ?? "");
      },
    ),

    // Route passing a model object
    GoRoute(
      path: AppRoute.subCategory.path,
      builder: (_, state) => SubCategoryScreen(category: state.extra as CategoryModel),
    ),

    // Bottom navigation shell
    ShellRoute(
      builder: (_, __, child) => BottomNavWrapper(child: child),
      routes: [
        GoRoute(path: AppRoute.home.path, builder: (_, __) => const HomeScreen()),
        GoRoute(path: AppRoute.booking.path, builder: (_, __) => const BookingScreen()),
        GoRoute(path: AppRoute.chat.path, builder: (_, __) => const ChatScreen()),
        GoRoute(path: AppRoute.profile.path, builder: (_, __) => const ProfileScreen()),
      ],
    ),
  ],
);
```

### 3.21 Screen — Using BLoC with BlocProvider + BlocBuilder

```dart
// file: lib/features/<feature>/screens/<name>_screen.dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeBloc = getIt.get<HomeBloc>();

    return BlocProvider(
      create: (_) => homeBloc..add(LoadCategoriesEvent()),
      child: SafeScaffold(
        appBar: CustomAppBar(title: "Home"),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is HomeLoaded) {
              return ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(state.categories[i].name ?? ""),
                  onTap: () => appRouter.push(
                    AppRoute.subCategory.path,
                    extra: state.categories[i],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

### 3.22 Screen — Using BLoC with copyWith state (forms)

```dart
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Scaffold(
      body: Form(
        key: getIt.get<AuthBloc>().formKey,
        child: Column(
          children: [
            CommonTextField(
              controller: phoneController,
              validator: (value) => Validation.mobileValidation(value),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return CommonButton(
                  onPressed: () {
                    if (getIt.get<AuthBloc>().formKey.currentState!.validate()) {
                      getIt.get<AuthBloc>().add(
                        SubmitPhoneNumberEvent(phoneNumber: phoneController.text),
                      );
                    }
                  },
                  text: 'Continue',
                  isLoading: state.isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 4. KEY RULES FOR TRANSFORMATION

### Feature Creation Checklist

For EACH feature in the old project, follow these steps:

1. Create `lib/features/<feature>/bloc/<feature>_bloc.dart`
2. Create `lib/features/<feature>/bloc/<feature>_event.dart`
3. Create `lib/features/<feature>/bloc/<feature>_state.dart`
4. Create `lib/features/<feature>/model/<name>_model.dart` (one per API response)
5. Create `lib/features/<feature>/repository/<feature>_repository.dart`
6. Move screens to `lib/features/<feature>/screens/`
7. Move feature-specific widgets to `lib/features/<feature>/screens/widget/`
8. Register repository in `injector_conf.dart`
9. Register BLoC in `injector_conf.dart`
10. Add BLoC to `MultiBlocProvider` in `app.dart` (if global)
11. Add routes to `app_route_path.dart` and `app_route_conf.dart`

### State Management Rules

- Use `sealed class` for events (Dart 3+)
- Use `copyWith` single-state pattern for forms/auth (state with many fields)
- Use multiple state classes pattern for data loading (Initial -> Loading -> Loaded -> Error)
- BLoC constructor registers handlers: `on<EventType>(_handler)`
- Handler methods are private: `_onEventName`
- Always emit loading state before async operations
- Catch errors and emit error state / show toast
- Access BLoC via `getIt.get<BlocType>()` (NOT `context.read<>()`)

### API Integration Rules

- All API calls go through `ApiHelper` (never direct Dio calls)
- Repositories return `ApiResponse<T>` with typed data
- Pass `fromJson` callback for deserialization
- Use `passToken: false` for auth endpoints
- Check `response.status` before using data
- Add new endpoints as constants in `ApiUrl`

### Navigation Rules

- Use `appRouter.push()` for forward navigation
- Use `appRouter.go()` for replacement (e.g., login -> home)
- Pass data via `extra` parameter
- Define all paths in `AppRoute` enum
- Use `ShellRoute` for bottom navigation tabs

### Widget Rules

- Shared widgets go in `lib/widgets/`
- Feature-specific widgets go in `lib/features/<feature>/screens/widget/`
- All screens use `SafeScaffold` wrapper
- Use `CommonButton`, `CommonTextField`, `CustomAppBar` from shared widgets
- Use `BlocBuilder` for reactive UI updates

### Theme Rules

- Colors in `AppColors` (static const Color)
- Text styles in `AppTextStyles` (GoogleFonts.montserrat based, 12-level Material 3 scale)
- Full theme in `AppTheme.lightTheme` (Material 3 with `useMaterial3: true`)
- Use `context.h1`, `context.body1` etc. via context extensions
- Use `.w`, `.h`, `.sp`, `.r` extensions for responsive sizing

### DI Registration Order (in injector_conf.dart)

1. SharedPreferences (async singleton)
2. SharedPreferencesHelper (depends on SharedPreferences)
3. SharedPreferencesRepository (depends on Helper)
4. Network services (Connectivity, InternetConnectionChecker, NetworkInfo)
5. Dio + ApiInterceptor
6. ApiHelper (depends on Dio)
7. Repositories (lazySingleton)
8. BLoCs (lazySingleton for global, factory for per-screen)

### JSON Serialization Rules

- Manual `fromJson` / `toJson` (NO code generation, NO freezed, NO json_serializable)
- All model fields are nullable (`String?`, `bool?`, etc.)
- Named constructor: `ModelName.fromJson(Map<String, dynamic> json)`
- Method: `Map<String, dynamic> toJson()`
- Nested models: `json['key'] != null ? Model.fromJson(json['key']) : null`
- Lists: `(json['key'] as List?)?.map((e) => Model.fromJson(e)).toList()`



claude --resume 38e65787-6046-4e67-9538-981f8531d7be