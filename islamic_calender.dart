import 'package:deentracker/utils/widgets/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../utils/widgets/app_colors.dart';
import '../controller/islamic_controller.dart';

class CalendarScreen extends StatelessWidget {
  final IslamicCalendarController controller = Get.put(
    IslamicCalendarController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          title: Center(child: Text('Islamic Calendar'))),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          children: [
            Obx(() {
              return Container(
                height: 385.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: AppColors.primary, width: 2.r),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: controller.today.value,
                  selectedDayPredicate: (day) =>
                      isSameDay(controller.today.value, day),
                  onDaySelected: (selectedDay, focusedDay) {},
                  availableGestures: AvailableGestures.none,
                  calendarStyle: CalendarStyle(

                    todayDecoration: BoxDecoration(
                      color: Colors.green.shade300,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 0,
                  ),
                  headerStyle:  HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Colors.white, // Text color inside header
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary, // Your header background color
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(13.r), // Optional rounded corners
                      ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 8.h),
            Expanded(
              child: Obx(() {
                final events = controller.getAllEvents();
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      color: AppColors.primary,
                      elevation: 2,
                      margin: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: ListTile(
                        leading:  Icon(Icons.event, color: AppColors.white),
                        title: Text(
                          event['title'],
                          style: AppStyle.regularWhite16,
                        ),
                        subtitle: Text(event['description'],style: AppStyle.regularGrey13,),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
