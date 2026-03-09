import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/widgets/app_colors.dart';
import '../../../../utils/widgets/app_style.dart';

class GhazwatHawala extends StatelessWidget {
  const GhazwatHawala({super.key});

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
                'Ghazwat Hawalajat',
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
                "https://ur.wikipedia.org/wiki/%D8%BA%D8%B2%D9%88%DB%81_%D8%AA%D8%A8%D9%88%DA%A9#%D8%B1%D9%88%D9%85%DB%8C_%D9%84%D8%B4%DA%A9%D8%B1_%DA%88%D8%B1_%DA%AF%DB%8C%D8%A7",
              ),
            ),
            _buildButton(
              title: "غزوہ بدر",
              onTap: () => launchYoutube(
                "https://ur.wikipedia.org/wiki/%D8%BA%D8%B2%D9%88%DB%81_%D8%A8%D8%AF%D8%B1",
              ),
            ),

            _buildButton(
              title: "غزوہ احد",
              onTap: () => launchYoutube(
                "https://ur.wikipedia.org/wiki/%D8%BA%D8%B2%D9%88%DB%81_%D8%A7%D8%AD%D8%AF",
              ),
            ),
            _buildButton(
              title: "غزوہ حنین",
              onTap: () => launchYoutube(
                "https://ur.wikipedia.org/wiki/%D8%BA%D8%B2%D9%88%DB%81_%D8%AD%D9%86%DB%8C%D9%86",
              ),
            ),
            _buildButton(
              title: "غزوہ خندق",
              onTap: () => launchYoutube(
                "https://ur.wikipedia.org/wiki/%D8%BA%D8%B2%D9%88%DB%81_%D8%AE%D9%86%D8%AF%D9%82",
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
