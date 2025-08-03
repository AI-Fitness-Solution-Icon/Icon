import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'app_print.dart';

/// Utility class for handling image picking and processing
class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  static Future<File?> pickImageFromGallery({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      AppPrint.printInfo('Picking image from gallery...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );

      if (image != null) {
        AppPrint.printInfo('Image picked from gallery: ${image.path}');
        return File(image.path);
      } else {
        AppPrint.printInfo('No image selected from gallery');
        return null;
      }
    } catch (e) {
      AppPrint.printError('Failed to pick image from gallery: $e');
      return null;
    }
  }

  /// Take a photo using the camera
  static Future<File?> takePhotoWithCamera({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      AppPrint.printInfo('Taking photo with camera...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );

      if (image != null) {
        AppPrint.printInfo('Photo taken with camera: ${image.path}');
        return File(image.path);
      } else {
        AppPrint.printInfo('No photo taken with camera');
        return null;
      }
    } catch (e) {
      AppPrint.printError('Failed to take photo with camera: $e');
      return null;
    }
  }

  /// Pick multiple images from gallery
  static Future<List<File>> pickMultipleImagesFromGallery({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      AppPrint.printInfo('Picking multiple images from gallery...');
      
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );

      final List<File> files = images.map((image) => File(image.path)).toList();
      AppPrint.printInfo('Picked ${files.length} images from gallery');
      
      return files;
    } catch (e) {
      AppPrint.printError('Failed to pick multiple images from gallery: $e');
      return [];
    }
  }

  /// Pick a video from gallery
  static Future<File?> pickVideoFromGallery({
    Duration? maxDuration,
  }) async {
    try {
      AppPrint.printInfo('Picking video from gallery...');
      
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: maxDuration,
      );

      if (video != null) {
        AppPrint.printInfo('Video picked from gallery: ${video.path}');
        return File(video.path);
      } else {
        AppPrint.printInfo('No video selected from gallery');
        return null;
      }
    } catch (e) {
      AppPrint.printError('Failed to pick video from gallery: $e');
      return null;
    }
  }

  /// Record a video using the camera
  static Future<File?> recordVideoWithCamera({
    Duration? maxDuration,
  }) async {
    try {
      AppPrint.printInfo('Recording video with camera...');
      
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: maxDuration,
      );

      if (video != null) {
        AppPrint.printInfo('Video recorded with camera: ${video.path}');
        return File(video.path);
      } else {
        AppPrint.printInfo('No video recorded with camera');
        return null;
      }
    } catch (e) {
      AppPrint.printError('Failed to record video with camera: $e');
      return null;
    }
  }

  /// Resize an image to specified dimensions
  static Future<File?> resizeImage(
    File imageFile, {
    required int maxWidth,
    required int maxHeight,
    int quality = 85,
  }) async {
    try {
      AppPrint.printInfo('Resizing image...');
      
      final Uint8List bytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      
      if (image == null) {
        AppPrint.printError('Failed to decode image');
        return null;
      }

      final img.Image resizedImage = img.copyResize(
        image,
        width: maxWidth,
        height: maxHeight,
        interpolation: img.Interpolation.linear,
      );

      final Uint8List resizedBytes = img.encodeJpg(resizedImage, quality: quality);
      
      // Create a temporary file for the resized image
      final String tempPath = '${imageFile.path}_resized.jpg';
      final File resizedFile = File(tempPath);
      await resizedFile.writeAsBytes(resizedBytes);
      
      AppPrint.printInfo('Image resized successfully');
      return resizedFile;
    } catch (e) {
      AppPrint.printError('Failed to resize image: $e');
      return null;
    }
  }

  /// Compress an image
  static Future<File?> compressImage(
    File imageFile, {
    int quality = 85,
  }) async {
    try {
      AppPrint.printInfo('Compressing image...');
      
      final Uint8List bytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      
      if (image == null) {
        AppPrint.printError('Failed to decode image');
        return null;
      }

      final Uint8List compressedBytes = img.encodeJpg(image, quality: quality);
      
      // Create a temporary file for the compressed image
      final String tempPath = '${imageFile.path}_compressed.jpg';
      final File compressedFile = File(tempPath);
      await compressedFile.writeAsBytes(compressedBytes);
      
      AppPrint.printInfo('Image compressed successfully');
      return compressedFile;
    } catch (e) {
      AppPrint.printError('Failed to compress image: $e');
      return null;
    }
  }

  /// Convert image to base64 string
  static Future<String?> imageToBase64(File imageFile) async {
    try {
      AppPrint.printInfo('Converting image to base64...');
      
      final Uint8List bytes = await imageFile.readAsBytes();
      final String base64String = base64Encode(bytes);
      
      AppPrint.printInfo('Image converted to base64 successfully');
      return base64String;
    } catch (e) {
      AppPrint.printError('Failed to convert image to base64: $e');
      return null;
    }
  }

  /// Get image information (dimensions, size, etc.)
  static Future<Map<String, dynamic>?> getImageInfo(File imageFile) async {
    try {
      AppPrint.printInfo('Getting image information...');
      
      final Uint8List bytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      
      if (image == null) {
        AppPrint.printError('Failed to decode image');
        return null;
      }

      final int fileSize = await imageFile.length();
      final double fileSizeInMB = fileSize / (1024 * 1024);

      final info = {
        'width': image.width,
        'height': image.height,
        'file_size_bytes': fileSize,
        'file_size_mb': fileSizeInMB,
        'aspect_ratio': image.width / image.height,
        'format': imageFile.path.split('.').last.toLowerCase(),
      };

      AppPrint.printInfo('Image information retrieved successfully');
      return info;
    } catch (e) {
      AppPrint.printError('Failed to get image information: $e');
      return null;
    }
  }

  /// Show image picker dialog
  static Future<File?> showImagePickerDialog(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final File? image = await pickImageFromGallery();
                  if (image != null) {
                    Navigator.of(context).pop(image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final File? image = await takePhotoWithCamera();
                  if (image != null) {
                    Navigator.of(context).pop(image);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Validate image file
  static bool isValidImageFile(File file) {
    final String extension = file.path.split('.').last.toLowerCase();
    const List<String> validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return validExtensions.contains(extension);
  }

  /// Validate video file
  static bool isValidVideoFile(File file) {
    final String extension = file.path.split('.').last.toLowerCase();
    const List<String> validExtensions = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'];
    return validExtensions.contains(extension);
  }

  /// Get file size in human readable format
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
} 