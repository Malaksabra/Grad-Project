# معايير الكود

القواعد دي بتطبّق على كل الكود في المشروع، وهدفها إن الكود يبقى واضح وسهل على أي حد في الفريق يقرأه ويعدّل فيه.

## التسمية (Naming)

- **الملفات والفولدرات:** حروف صغيرة وشرطة سفلية، زي `daily_routines` و`routine_screen.dart`.
- **الـ Classes:** كل كلمة بحرف كبير، زي `RoutineScreen`.
- **المتغيرات والدوال والثوابت:** أول كلمة بحرف صغير وباقي الكلمات بحرف كبير، زي `routineSteps` و`appName`.
- **المتغيرات المنطقية (true/false):** تبدأ بـ `is` أو `has`، زي `isCompleted`.
- الاسم لازم يوضّح الغرض من غير اختصارات مبهمة. `routineStep` أحسن من `rs`.

## Clean Code

- **الدالة تعمل حاجة واحدة بس** وتبقى قصيرة.
- **الـ Widget الكبير يتقسم** لـ Widgets أصغر، كل واحد في Class مستقل.
- **ممنوع تكرار الكود (DRY).** لو حاجة اتكررت في أكتر من feature، تروح لـ `shared/`.
- **ممنوع الأرقام والنصوص السحرية.** الألوان من `AppColors`، والخطوط من `AppFonts`، والاسم من `AppConstants`، ومحدش يكتب لون أو خط جوه الشاشة مباشرة.
- **التعليقات بتشرح "ليه"** مش "إيه". واللي مش مستخدم أو متحوّل لتعليق بيتمسح.

## SOLID (بشكل مبسّط)

- **S - مسؤولية واحدة:** كل Class وكل ملف مسؤول عن حاجة واحدة. الشاشة مسؤولة عن العرض بس، والمنطق في مكان تاني.
- **O - مفتوح للإضافة:** لما نضيف نوع جديد (زي نشاط جديد)، نضيف كود جديد من غير ما نعدّل في القديم.
- **L - الاستبدال:** الـ Class الابن لازم يشتغل مكان الأب من غير ما يبوّظ حاجة.
- **I - واجهات صغيرة:** نفضّل أجزاء صغيرة ومحددة على واجهة كبيرة فيها كل حاجة.
- **D - الاعتماد على التجريد:** الشاشة متنادّيش على الداتا أو الخدمات مباشرة، تعدّي من طبقة وسيطة.

مش مطلوب تعقيد زيادة. الأولوية للكود البسيط الواضح، وبنطبّق المبادئ دي بقدر ما بتخدم المشروع.

## قبل أي Pull Request

من جوه فولدر `mobile`:

```bash
dart format .
flutter analyze
flutter test
```

## برومبت للذكاء الاصطناعي

الصقوه في أول المحادثة مع أي أداة AI قبل ما تطلبوا كود:

```text
I'm working on a Flutter (Dart) graduation project: an Arabic, right-to-left (RTL) learning app for children with autism. Follow these rules in all code you write:

Structure:
- Feature-first folders under mobile/lib/features/<feature_name>/ (screens, widgets, models only when needed).
- Shared code goes in lib/shared/, app-wide setup in lib/core/.
- Only change files inside the feature I name. Tell me before touching core/, shared/, app.dart or pubspec.yaml.
- Do not add packages without asking me first.

Naming (Dart conventions):
- Files and folders: lowercase_with_underscores.
- Classes: UpperCamelCase.
- Variables, functions and constants: lowerCamelCase.
- Booleans start with is/has. Names must be clear, with no vague abbreviations.

Clean code:
- Each function does one thing and stays short.
- Split big widgets into small widget classes, not helper methods that return widgets.
- No duplicated code. No magic numbers or strings.
- Use AppColors, AppFonts, AppConstants and Theme.of(context). Never hardcode colors or fonts in screens.
- Comments explain why, not what. No unused or commented-out code.

SOLID, kept simple:
- One responsibility per class and file.
- UI does not call data or services directly.
- Extend by adding new code, not by editing working code.
- Do not over-engineer: keep it as simple as the task allows.

UI and language:
- The app is RTL and Arabic. Do not hardcode left/right alignment; use start/end.
- Child-friendly: large touch targets and clear, simple layouts.

When you answer: keep changes small, explain briefly why you structured it that way, and make sure the code would pass flutter analyze.
```