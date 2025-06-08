import 'package:barber_pannel/cavlog/app/data/models/post_with_barber.dart' show PostWithBarberModel;
import 'package:barber_pannel/cavlog/app/presentation/provider/bloc/fetchings/fetch_postwith_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/view_post_widget/post_card_widget.dart';
import 'package:barber_pannel/cavlog/app/presentation/widgets/view_post_widget/post_success_state_widget.dart';
import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PostScreenWidget extends StatefulWidget {
  const PostScreenWidget({
    super.key,
    required this.screenHeight,
    required this.heightFactor,
    required this.screenWidth,
  });

  final double screenHeight;
  final double heightFactor;
  final double screenWidth;

  @override
  State<PostScreenWidget> createState() => _PostScreenWidgetState();
}

class _PostScreenWidgetState extends State<PostScreenWidget> {
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchPostWithBarberBloc>().add(FetchPostWithBarberRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPostWithBarberBloc, FetchPostWithBarberState>(
      builder: (context, state) {
        if (state is FetchPostWithBarberLoaded) {
          final List<PostWithBarberModel> model = state.model;
          return postBlocSuccessStateBuilder(commentController: commentController, context: context, heightFactor: widget.heightFactor,model: model, screenHeight: widget.screenHeight, screenWidth: widget.screenWidth,state: state);
        } else if (state is FetchPostWithBarberEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_size_select_actual_outlined,
                    color: AppPalette.hintClr),
                const Text('No Posts Yet!'),
                Text('Fresh styles coming soon! Add new posts.',
                    style: TextStyle(color: AppPalette.greyClr)),
                IconButton(
                  onPressed: () {
                    context
                        .read<FetchPostWithBarberBloc>()
                        .add(FetchPostWithBarberRequest());
                  },
                  icon: Icon(Icons.refresh, color: AppPalette.blueClr),
                )
              ],
            ),
          );
        } else if (state is FetchPostWithBarberFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported_rounded,
                    color: AppPalette.hintClr),
                const Text('Something went wrong!'),
                Text('Oops! That didn’t work. Please try again',
                    style: TextStyle(color: AppPalette.greyClr)),
                IconButton(
                  onPressed: () {
                    context
                        .read<FetchPostWithBarberBloc>()
                        .add(FetchPostWithBarberRequest());
                  },
                  icon: Icon(Icons.refresh, color: AppPalette.redClr),
                )
              ],
            ),
          );
        }

        // Shimmer loader state
        return Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyClr,
          highlightColor: AppPalette.whiteClr,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return PostScreenMainWidget(
                isLiked: false,
                screenHeight: widget.screenHeight,
                heightFactor: widget.heightFactor,
                screenWidth: widget.screenWidth,
                description: 'Loading...',
                favoriteColor: AppPalette.redClr,
                favoriteIcon: Icons.favorite_border,
                likes: 0,
                likesOnTap: () {},
                commentOnTap: () {},
                location: 'Loading...',
                postUrl: '',
                profilePage: () {},
                shareOnTap: () {},
                shopName: 'Loading...',
                shopUrl: '',
                dateAndTime: '',
              );
            },
            separatorBuilder: (context, index) =>
                ConstantWidgets.hight10(context),
          ),
        );
      },
    );
  }

}
