import 'dart:io';
import 'package:bank_card/presentation/cubit/uploud_image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UploadCubit extends Cubit<UploudImageState> {
  UploadCubit() : super(const UploudImageState(status: UploudImageStatus.initial));

  Future<void> pickImage() async {
    emit(UploudImageState(status: UploudImageStatus.loading, image: state.image));
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      File file = File(result.path);
      print("Rasm muvaffaqiyatli tanlandi: ${file.path}");
      emit(
        UploudImageState(
          status: UploudImageStatus.success,
          image: file,
        ),
      );
    } else {
      emit(
        UploudImageState(
          status: UploudImageStatus.initial,
          image: state.image,
        ),
      );
    }
  }
}