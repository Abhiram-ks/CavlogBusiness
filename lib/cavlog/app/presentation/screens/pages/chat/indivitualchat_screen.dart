import 'package:barber_pannel/cavlog/app/data/repositories/fetch_users_repo.dart';
import 'package:barber_pannel/cavlog/app/domain/usecases/imageuploadon_cloud_usecase.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/send_message_bloc/send_message_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/provider/cubit/requst_chatstatus_cubit/requst_chatstatus_cubit.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/chat_widgets/chat_window_widget/chat_custom_appbar.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/chat_widgets/chat_window_widget/chat_window_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/cloudinary/cloudinary_service.dart';
import '../../../../data/datasources/firebase_chat_datasource.dart';
import '../../../../data/repositories/image_picker_repo.dart';
import '../../../../data/repositories/request_chatupdate_repo.dart';
import '../../../../domain/usecases/image_picker_usecase.dart';
import '../../../provider/bloc/image_picker/image_picker_bloc.dart';

class IndividualChatScreen extends StatefulWidget {
  final String userId;
  final String barberId;

  const IndividualChatScreen({
    super.key,
    required this.userId,
    required this.barberId,
  });

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FetchUserBloc(FetchUserRepositoryImpl())),
        BlocProvider(create: (_) => ImagePickerBloc(PickImageUseCase(ImagePickerRepositoryImpl(ImagePicker())))),
        BlocProvider(create: (_) => SendMessageBloc(chatRemoteDatasources: ChatRemoteDatasourcesImpl(),cloudinaryService: CloudinaryService(),repo: ImageUploaderMobile(CloudinaryService()))),
        BlocProvider(create: (_) => StatusChatRequstDartCubit(RequestForChatupdateRepoImpl())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return Scaffold(
              appBar: ChatAppBar(
                userId: widget.userId,
                screenWidth: screenWidth,
              ),
              body: ChatWindowWidget(
                userId: widget.userId,
                barberId: widget.barberId,
                controller: controller,
              ));
        },
      ),
    );
  }
}






