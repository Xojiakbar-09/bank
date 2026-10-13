import 'dart:io';

enum UploudImageStatus { initial, loading, success, failure }

class UploudImageState {
  final UploudImageStatus status;
  final File? image;

  const UploudImageState({
    this.status = UploudImageStatus.initial,
    this.image,
  });
}