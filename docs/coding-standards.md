# معايير الكود (Code Standards)

القواعد دي بتتطبّق على كل الكود في المشروع، وهدفها إن الكود يبقى واضح وسهل على أي حد في الفريق يقرأه ويعدّل فيه.

## التسمية (Naming Conventions)

- **Files & Folders:** حروف صغيرة وunderscore (`snake_case`)، زي `daily_routines` و`routine_screen.dart`.
- **Classes:** كل كلمة تبدأ بحرف كبير (`UpperCamelCase`)، زي `RoutineScreen`.
- **Variables, Functions & Constants:** أول كلمة تبدأ بحرف صغير، وباقي الكلمات تبدأ بحرف كبير (`lowerCamelCase`)، زي `routineSteps` و`appName`.
- **Boolean Variables (true/false):** تبدأ بـ `is` أو `has`، زي `isCompleted`.
- الاسم لازم يوضّح الغرض من غير اختصارات مبهمة. `routineStep` أحسن من `rs`.

## Clean Code

- **Single Responsibility:** كل Function تعمل حاجة واحدة بس وتبقى قصيرة.
- **Widget Decomposition:** الـ `Widget` الكبير يتقسّم لـ `Widgets` أصغر، وكل واحد في `Class` مستقل.
- **Don't Repeat Yourself (DRY):** ممنوع تكرار الكود. لو حاجة اتكررت في أكتر من `Feature`، تروح لـ `shared/`.
- **Magic Numbers & Strings:** ممنوع استخدام الأرقام والنصوص السحرية. الألوان تكون من `AppColors`، والخطوط من `AppFonts`، والأسماء من `AppConstants`، ومحدش يكتب لون أو خط جوه الشاشة مباشرة.
- **Comments:** التعليقات تشرح "ليه" مش "إيه". وأي كود مش مستخدم أو متحوّل لتعليق يتمسح.

## SOLID Principles (بشكل مبسّط)

- **S — Single Responsibility Principle (SRP):** كل `Class` وكل ملف مسؤول عن حاجة واحدة. الشاشة مسؤولة عن العرض بس، والمنطق في مكان تاني.
- **O — Open/Closed Principle (OCP):** الكود يكون مفتوح للإضافة ومقفول أمام التعديل. لما نضيف نوع جديد، زي نشاط جديد، نضيف كود جديد من غير ما نعدّل في القديم.
- **L — Liskov Substitution Principle (LSP):** الـ `Child Class` لازم يشتغل مكان الـ `Parent Class` من غير ما يبوّظ حاجة.
- **I — Interface Segregation Principle (ISP):** نفضّل `Interfaces` صغيرة ومحددة على `Interface` كبيرة فيها كل حاجة.
- **D — Dependency Inversion Principle (DIP):** الشاشة متنادّيش على الـ `Data Sources` أو الـ `Services` مباشرة؛ تتعامل معاها من خلال طبقة وسيطة أو `Abstraction`.

مش مطلوب تعقيد زيادة. الأولوية للكود البسيط والواضح، وبنطبّق المبادئ دي بقدر ما بتخدم المشروع.

## Before Any Pull Request (PR)

من جوه فولدر `mobile`، شغّلوا الأوامر دي:

```bash
dart format .
flutter analyze
flutter test
```

- `dart format .`: تنسيق الكود تلقائيًا.
- `flutter analyze`: فحص الكود واكتشاف المشاكل المحتملة.
- `flutter test`: تشغيل الاختبارات.

## AI Prompt

حطوا البرومبت ده في بداية المحادثة مع أي أداة `AI` قبل ما تطلبوا منها كتابة كود:

"

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