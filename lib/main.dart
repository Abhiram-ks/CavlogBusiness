
import 'package:barber_pannel/cavlog/app/data/repositories/delete_post_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_barberdata_repo.dart';
import 'package:barber_pannel/cavlog/app/data/repositories/fetch_servicedata_repo.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_service_bloc/fetch_service_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetchbarber/fetch_barber_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/gemini_chat_bloc/gemini_chat_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/delete_post_cubit/delete_post_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/emoji_cubit.dart/emoji_cubit_bloc.dart';
import 'package:barber_pannel/cavlog/auth/presentation/provider/cubit/buttonProgress/button_progress_cubit.dart';
import 'package:barber_pannel/core/ai_integration/gemini_confi.dart';
import 'package:barber_pannel/core/cloudinary/cloudinary_config.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/theme_manager.dart';
import 'package:barber_pannel/firebase_options.dart';
import 'package:barber_pannel/cavlog/auth/presentation/provider/bloc/RegisterSubmition/register_submition_bloc.dart';
import 'package:barber_pannel/cavlog/auth/presentation/provider/bloc/splash/splash_bloc.dart';
import 'package:barber_pannel/cavlog/auth/presentation/provider/cubit/timerCubit/timer_cubit_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'cavlog/app/presentation/provider/cubit/booking_generate_cubit/slote_delete_privious_bloc/slot_delete_privious_cubit.dart';
import 'cavlog/auth/presentation/provider/cubit/Checkbox/checkbox_cubit.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'cavlog/auth/presentation/provider/cubit/icon_cubit/icon_cubit.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  CloudinaryConfig.initialize();
  GeminiConfig.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
 );
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SlotDeletePriviousCubit()),
        BlocProvider(create: (_) => SplashBloc(FirebaseFirestore.instance)..add(StartSplashEvent())),
        BlocProvider(create: (_) => RegisterSubmitionBloc()),
        BlocProvider(create: (_) => FetchBarberBloc(FetchBarberRepositoryImpl())),
        BlocProvider(create: (_) => IconCubit()),
        BlocProvider(create: (_) => ButtonProgressCubit()),
        BlocProvider(create: (_) => TimerCubitCubit()),
        BlocProvider(create: (_) => CheckboxCubit()),
        BlocProvider(create: (_) => FetchServiceBloc(ServiceRepositoryImpl())..add(FetchServiceRequst())),
        BlocProvider(create: (_) => EmojiPickerCubit()),
        BlocProvider(create: (_) => GeminiChatBloc(Gemini.instance)),
        BlocProvider(create: (_) => DeletePostCubit(DeletePostRepositoryImpl()))
      ],
      child: MaterialApp(
          title: 'Cavlog-Business',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
          ), 
    );
  }
}


