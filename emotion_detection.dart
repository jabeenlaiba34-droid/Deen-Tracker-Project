import 'dart:io';
import 'package:deentracker/utils/widgets/app_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../../../../utils/widgets/app_colors.dart';
import '../controller/emotion_detection_controller.dart';

class QuranAyatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuranController());

    return WillPopScope(
      onWillPop: () async {
        await controller.disposeCamera();
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: AppColors.white),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await controller.disposeCamera();
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_ios_new_outlined),
                            Text(
                              'Emotions Detection',
                              style: AppStyle.regularBlack20.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => controller.capturedImagePath.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.refresh,
                            color: AppColors.black, size: 28.sp),
                        onPressed: controller.resetAnalysis,
                      )
                          : SizedBox.shrink()),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                    child: Obx(() {
                      if (controller.showCamera.value) {
                        return _buildCameraView(controller);
                      } else {
                        return _buildResultView(controller);
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraView(QuranController controller) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (!controller.isCameraActive.value) {
              await controller.enableCamera();
            }
          },
          child: Container(
            height: 450.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Obx(() {
                if (controller.isCameraActive.value &&
                    controller.cameraController != null &&
                    controller.cameraController!.value.isInitialized) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CameraPreview(controller.cameraController!),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 280.w,
                          height: 350.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(140.r),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5.h,
                        left: 20.w,
                        right: 20.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'Position your face within the frame',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,
                              size: 60.sp, color: Colors.grey[600]),
                          SizedBox(height: 16.h),
                          Text(
                            'Tap to enable camera',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Or use gallery below',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
        ),
        SizedBox(height: 60.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: AppColors.white,
                  onPressed: controller.pickImageFromGallery,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Obx(() => _buildActionButton(
                  icon: Icons.camera_alt,
                  label: 'Capture',
                  color: controller.isCameraActive.value
                      ? AppColors.white
                      : Colors.grey,
                  onPressed: controller.isCameraActive.value
                      ? controller.captureImage
                      : () async {
                    await controller.enableCamera();
                  },
                )),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Tap camera area to enable, then capture or select an image to get personalized Quranic verses',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView(QuranController controller) {
    return Obx(() {
      if (controller.isAnalyzing.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.secondary),
                  strokeWidth: 3,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Analyzing your emotion...',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Please wait a moment',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.capturedImagePath.isNotEmpty)
              Container(
                height: 450.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14159),
                    child: Image.file(
                      File(controller.capturedImagePath.value),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20.h),
            if (controller.currentEmotion.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildEmotionCard(controller),
              ),
            SizedBox(height: 20.h),
            if (controller.suggestedAyats.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSuggestedHeader(controller),
              ),
            SizedBox(height: 12.h),
            if (controller.suggestedAyats.isEmpty)
              _buildEmptyState()
            else
              ListView.builder(
                shrinkWrap: true,          // ✅ important for scroll
                physics: NeverScrollableScrollPhysics(), // ✅ disable inner scroll
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                itemCount: controller.suggestedAyats.length,
                itemBuilder: (context, index) {
                  return _buildAyatCard(controller.suggestedAyats[index], index);
                },
              ),
          ],
        ),
      );
    });
  }

  Widget _buildEmotionCard(QuranController controller) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getEmotionColor(controller.currentEmotion.value).withOpacity(0.1),
            _getEmotionColor(controller.currentEmotion.value).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _getEmotionColor(controller.currentEmotion.value).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Detected Emotion',
                style:AppStyle.regularWhite22.copyWith(color: AppColors.white.withOpacity(0.6))
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getEmotionColor(controller.currentEmotion.value).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getEmotionIcon(controller.currentEmotion.value),
                      color: AppColors.DarkYellow,
                      size: 40.sp,
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    controller.currentEmotion.value,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: _getEmotionColor(controller.currentEmotion.value),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedHeader(QuranController controller) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.auto_stories, color: AppColors.secondary, size: 20.sp),
        ),
        SizedBox(width: 10.w),
        Text(
          'Suggested Ayats & Surrah',
          style: AppStyle.regularWhite16
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            '${controller.suggestedAyats.length}',
            style: AppStyle.regularWhite14
          ),
        ),
      ],
    );
  }

  Widget _buildAyatCard(String ayat, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                ayat,
                style: TextStyle(
                  fontSize: 15.5.sp,
                  height: 2.2,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied, size: 80.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              'No face detected',
              style: AppStyle.regularGrey14
            ),
            SizedBox(height: 8.h),
            Text(
              'Please try again with a clear image',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.secondary, size: 24.sp),
            SizedBox(width: 10.w),
            Text(
              label,
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return AppColors.green;
      case 'sad':
        return AppColors.blue;
      case 'tense':
        return AppColors.DarkYellow;
      case 'neutral':
        return AppColors.darkgrey;
      default:
        return AppColors.grey;
    }
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_very_dissatisfied;
      case 'tense':
        return Icons.sentiment_neutral;
      case 'neutral':
        return Icons.sentiment_satisfied;
      default:
        return Icons.face;
    }
  }
}