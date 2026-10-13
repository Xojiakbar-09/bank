import 'package:bank_card/presentation/cubit/uploud_image_cubit.dart';
import 'package:bank_card/presentation/cubit/uploud_image_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAvatarUpdateWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileAvatarUpdateWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadCubit, UploudImageState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.deepPurple, width: 3.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: state.status == UploudImageStatus.success && state.image != null
                    ? FileImage(state.image!)
                    : null,
                backgroundColor: Colors.black12,
                radius: 30,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: InkWell(
                onTap: () => context.read<UploadCubit>().pickImage(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: state.status == UploudImageStatus.loading
                      ? const CupertinoActivityIndicator(radius: 8)
                      : const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}