import 'package:flutter/material.dart';

class RoutineStep {
  final String title;
  final int seconds;
  final String? imagePath;
  final IconData? iconData;

  RoutineStep({
    required this.title,
    required this.seconds,
    this.imagePath,
    this.iconData,
  });
}

class RoutineData {
  final String id;
  final String title;
  final String totalTimeString;
  final IconData icon;
  final List<RoutineStep> steps;

  RoutineData({
    required this.id,
    required this.title,
    required this.totalTimeString,
    required this.icon,
    required this.steps,
  });
}

// قائمة بيانات الروتينات الستة مظبوطة بالكامل والصور والأوقات لكل خطوة
final List<RoutineData> morningRoutinesData = [
  // 1. أرتّب سريري (5 دقائق)
  RoutineData(
    id: 'bed',
    title: 'أرتّب سريري',
    totalTimeString: '5:00',
    icon: Icons.bed_rounded,
    steps: [
      RoutineStep(title: 'أصحى من النوم', seconds: 45, imagePath: 'assets/images/daily_routines/image5.png'),
      RoutineStep(title: 'أنفض الملاية', seconds: 75, imagePath: 'assets/images/daily_routines/image7.png'),
      RoutineStep(title: 'أشد ملاية السرير وارتبها', seconds: 120, imagePath: 'assets/images/daily_routines/image6.png'),
      RoutineStep(title: 'أبص على السرير وأخلص!', seconds: 60, iconData: Icons.verified_rounded),
    ],
  ),

  // 2. الحمام (7 دقائق)
  RoutineData(
    id: 'bathroom',
    title: 'الحمام',
    totalTimeString: '7:00',
    icon: Icons.bathtub_rounded,
    steps: [
      RoutineStep(title: 'أدخل الحمام', seconds: 45, imagePath: 'assets/images/daily_routines/image27.png'),
      RoutineStep(title: 'أعمل اللي محتاجه', seconds: 240, imagePath: 'assets/images/daily_routines/image9.png'),
      RoutineStep(title: 'أشد السيفون', seconds: 45, imagePath: 'assets/images/daily_routines/image10.png'),
      RoutineStep(title: 'أغسل إيدي بالصابون', seconds: 75, imagePath: 'assets/images/daily_routines/image12.png'),
      RoutineStep(title: 'أنشّف إيدي', seconds: 45, imagePath: 'assets/images/daily_routines/image13.png'),
    ],
  ),

  // 3. ألبس هدومي (15 دقيقة) - تم تحديث تسريح الشعر لتستخدم image49.png
  RoutineData(
    id: 'clothes',
    title: 'ألبس هدومي',
    totalTimeString: '15:00',
    icon: Icons.checkroom_rounded,
    steps: [
      RoutineStep(title: 'أختار هدومي', seconds: 120, imagePath: 'assets/images/daily_routines/image14.png'),
      RoutineStep(title: 'ألبس البنطلون', seconds: 180, imagePath: 'assets/images/daily_routines/image15.png'),
      RoutineStep(title: 'ألبس التيشيرت', seconds: 180, imagePath: 'assets/images/daily_routines/image16.png'),
      RoutineStep(title: 'ألبس الشراب', seconds: 120, imagePath: 'assets/images/daily_routines/image17.png'),
      RoutineStep(title: 'ألبس الجزمة', seconds: 180, imagePath: 'assets/images/daily_routines/image18.png'),
      RoutineStep(title: 'أسرح شعري', seconds: 120, imagePath: 'assets/images/daily_routines/image49.png'),
    ],
  ),

  // 4. أفطر (15 دقيقة)
  RoutineData(
    id: 'breakfast',
    title: 'أفطر',
    totalTimeString: '15:00',
    icon: Icons.breakfast_dining_rounded,
    steps: [
      RoutineStep(title: 'أقعد على الترابيزة', seconds: 60, imagePath: 'assets/images/daily_routines/image24.png'),
      RoutineStep(title: 'آكل الفطار', seconds: 600, imagePath: 'assets/images/daily_routines/image21.png'),
      RoutineStep(title: 'أشرب', seconds: 120, imagePath: 'assets/images/daily_routines/image22.png'),
      RoutineStep(title: 'أشيل الأكل', seconds: 120, imagePath: 'assets/images/daily_routines/image23.png'),
    ],
  ),

  // 5. أنضف سناني (5 دقائق)
  RoutineData(
    id: 'teeth',
    title: 'أنضف سناني',
    totalTimeString: '5:00',
    icon: Icons.cleaning_services_rounded,
    steps: [
      RoutineStep(title: 'أجيب الفرشة', seconds: 45, imagePath: 'assets/images/daily_routines/image30.png'),
      RoutineStep(title: 'أحط المعجون', seconds: 45, imagePath: 'assets/images/daily_routines/image33.png'),
      RoutineStep(title: 'أنضف سناني', seconds: 120, imagePath: 'assets/images/daily_routines/image32.png'),
      RoutineStep(title: 'أشطف بالمية', seconds: 45, imagePath: 'assets/images/daily_routines/image34.png'),
      RoutineStep(title: 'أمسح وشي', seconds: 45, imagePath: 'assets/images/daily_routines/image35.png'),
    ],
  ),

  // 6. أجهز شنطي (4 دقائق)
  RoutineData(
    id: 'bag',
    title: 'أجهز شنطي',
    totalTimeString: '4:00',
    icon: Icons.backpack_rounded,
    steps: [
      RoutineStep(title: 'أفتح الشنطة', seconds: 45, imagePath: 'assets/images/daily_routines/image38.png'),
      RoutineStep(title: 'أحط الكتب', seconds: 75, imagePath: 'assets/images/daily_routines/image40.png'),
      RoutineStep(title: 'أحط المقلمة', seconds: 45, imagePath: 'assets/images/daily_routines/image41.png'),
      RoutineStep(title: 'أحط علبة الأكل', seconds: 45, imagePath: 'assets/images/daily_routines/image39.png'),
      RoutineStep(title: 'ألبس الشنطة', seconds: 30, imagePath: 'assets/images/daily_routines/image37.png'),
    ],
  ),
];