import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/widgets/app_colors.dart';
import '../../../../utils/widgets/app_style.dart';

class GhazwatVedios extends StatelessWidget {
  const GhazwatVedios({super.key});

  Future<void> launchYoutube(String url) async {
    final uri = Uri.parse(url);

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar("Error", "Could not open the link");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => Get.back(),
          child: Row(
            children: [
              const Icon(Icons.arrow_back_ios_new_outlined),
              Text(
                'Ghazwat Vedios',
                style: AppStyle.regularBlack20.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          childAspectRatio: 1,
          children: [
            _buildButton(
              title: "غزوہ تبوک",
              onTap: () => launchYoutube(
                "https://youtu.be/LOX7i-B_ptU?si=ReGbbLAppJl09Flu",
              ),
            ),
            _buildButton(
              title: "غزوہ بدر",
              onTap: () => launchYoutube(
                "https://youtu.be/ZByE9CANBTY?si=-DIiXWnok-Bzikd6",
              ),
            ),

            _buildButton(
              title: "غزوہ احد",
              onTap: () => launchYoutube(
                "https://youtu.be/tDFX0OsF5cI?si=qWR8ErucMbv5wCp0",
              ),
            ),
            _buildButton(
              title: "غزوہ حنین",
              onTap: () => launchYoutube(
                "https://youtu.be/U8iC0ieHf3c?si=sxbv9FjP-r6NtOnZ",
              ),
            ),
            _buildButton(
              title: "غزوہ خندق",
              onTap: () => launchYoutube(
                "https://youtu.be/YvVnQrTixbM?si=gaxuWDGjCzyksPzK",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            title,
            style: AppStyle.regularWhite22,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
