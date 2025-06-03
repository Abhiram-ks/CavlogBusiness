import 'package:barber_pannel/core/themes/colors.dart';
import 'package:barber_pannel/core/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cavlog/auth/presentation/provider/cubit/icon_cubit/icon_cubit.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPasswordField;
  final TextEditingController controller;
  final String? Function(String? value) validate;
  final bool enabled;
  final Color? borderClr;
  final Color? suffixIconColor;
  final Color? fillClr;
  final ValueChanged<String>? onChanged;
  final IconData? suffixIconData;
  final VoidCallback? suffixIconAction;

  const TextFormFieldWidget(
      {super.key,
      required this.label,
      required this.hintText,
      required this.prefixIcon,
      this.isPasswordField = false, required this.controller,required this.validate, 
      this.enabled = true,
      this.borderClr,
      this.fillClr,
      this.suffixIconColor,
      this.onChanged,
      this.suffixIconData,
      this.suffixIconAction,
      });

    @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IconCubit(),
      child: Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 5),
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            BlocSelector<IconCubit, IconState, bool>(
              selector: (state) {
                if (state is PasswordVisibilityUpdated) {
                  return state.isVisible;
                }
                return false;
              },
              builder: (context, isVisible) {
                return TextFormField(
                  controller: controller,
                  validator: validate,
                  obscureText: isPasswordField ? !isVisible : false,
                  style: const TextStyle(fontSize: 16),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: enabled,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    filled: fillClr != null,
                    fillColor: fillClr,
                    hintText: hintText,
                    hintStyle: TextStyle(color: AppPalette.hintClr),
                    prefixIcon: Icon(
                      prefixIcon,
                      color: const Color.fromARGB(255, 52, 52, 52),
                    ),
                    suffixIcon: suffixIconData != null || isPasswordField ?  GestureDetector(
                            onTap: () {
                              if (isPasswordField) {
                              context.read<IconCubit>().togglePasswordVisibility(isVisible);
                              } 
                              if (suffixIconData != null) {
                                suffixIconAction?.call();  
                              }
                            },
                            child: isPasswordField ?
                            Icon(
                              isVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black,
                            ) : Icon(suffixIconData)

                          )
                        : null,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color:borderClr ?? AppPalette.hintClr, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppPalette.hintClr, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppPalette.redClr,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppPalette.redClr,
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
            ConstantWidgets.hight10(context),
          ],
        );
      }),
    );
  }
}