# معايير الكود (Code Standards)

القواعد دي بتتطبّق على كل الكود في المشروع، وهدفها إن الكود يبقى واضح وسهل على أي حد في الفريق يقرأه ويعدّل فيه.

## التسمية (Naming Conventions)

- **Files & Folders:** تُكتب بحروف صغيرة مع استخدام `underscore`، وده اسمه `snake_case`. مثال: `daily_routines` و`routine_screen.dart`.
- **Classes:** كل كلمة تبدأ بحرف كبير، وده اسمه `UpperCamelCase`. مثال: `RoutineScreen`.
- **Variables, Functions & Constants:** أول كلمة تبدأ بحرف صغير، وباقي الكلمات تبدأ بحرف كبير، وده اسمه `lowerCamelCase`. مثال: `routineSteps` و`appName`.
- **Boolean Variables:** بتاخد قيمة `true` أو `false`، ويُفضّل تبدأ بـ `is` أو `has`. مثال: `isCompleted`.
- **Descriptive Naming:** الاسم لازم يوضّح الغرض منه من غير اختصارات مبهمة. مثال: `routineStep` أفضل من `rs`.

## Clean Code

- **Single Responsibility:** كل `Function` تعمل مهمة واحدة بس وتكون قصيرة وواضحة.
- **Widget Decomposition:** الـ `Widget` الكبير يتقسّم إلى `Widgets` أصغر، وكل واحد ممكن يكون في `Class` مستقل.
- **Don't Repeat Yourself (DRY):** نتجنّب تكرار الكود. لو فيه كود مشترك بين أكتر من `Feature`، نحطه في `shared/`.
- **Magic Numbers & Strings:** نتجنّب كتابة الأرقام والنصوص الثابتة مباشرة في الكود. الألوان تكون من `AppColors`، والخطوط من `AppFonts`، والثوابت العامة من `AppConstants`. ونستخدم `Theme.of(context)` للاستفادة من إعدادات الـ `Theme` بدل ما نكتب الألوان والخطوط مباشرة داخل الشاشات.
- **Comments:** التعليقات تشرح السبب (Why)، مش تعيد شرح الكود (What). وأي كود غير مستخدم أو متحوّل إلى تعليق يتشال.

## SOLID Principles (بشكل مبسّط)

- **S — Single Responsibility Principle (SRP):** كل `Class` وكل ملف يكون مسؤولًا عن مهمة واحدة. الـ `Screen` مسؤولة عن العرض، والمنطق يتحط في المكان المناسب ليه.
- **O — Open/Closed Principle (OCP):** الكود يكون قابلًا للإضافة من غير تعديلات غير ضرورية على الكود الموجود. مثلًا، نقدر نضيف نوع نشاط جديد من غير ما نغيّر أجزاء شغالة بالفعل، قدر الإمكان.
- **L — Liskov Substitution Principle (LSP):** الـ `Child Class` لازم يقدر يحل محل الـ `Parent Class` من غير ما يغيّر السلوك المتوقع أو يسبّب مشاكل.
- **I — Interface Segregation Principle (ISP):** نفضّل استخدام `Interfaces` صغيرة ومحددة بدل `Interface` كبيرة بتفرض على الـ `Class` وظائف مش محتاجها.
- **D — Dependency Inversion Principle (DIP):** الـ `UI` ما تعتمدش مباشرة على تفاصيل تنفيذ الـ `Data Sources` أو الـ `Services`، لكن تتعامل معاها من خلال `Abstractions` مناسبة لما يكون ده مطلوبًا.

مش مطلوب نطبّق المبادئ دي بشكل معقّد. الأولوية للكود البسيط والواضح، ونستخدم المبادئ بالقدر اللي يخدم المشروع.

## Before Any Pull Request (PR)

من داخل فولدر `mobile`، شغّلوا الأوامر دي:

```bash
dart format .
flutter analyze
flutter test
```

- `dart format .`: تنسيق كود `Dart` تلقائيًا.
- `flutter analyze`: فحص الكود لاكتشاف الأخطاء والمشاكل المحتملة.
- `flutter test`: تشغيل الـ `Tests` الموجودة في المشروع.

## AI Prompt

حطّوا البرومبت التالي في بداية المحادثة مع أي أداة `AI` قبل طلب كتابة أو تعديل الكود.

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
- Avoid duplicated code and magic numbers or strings.
- Use AppColors, AppFonts, AppConstants and Theme.of(context). Never hardcode colors or fonts in screens.
- Comments explain why, not what. No unused or commented-out code.

SOLID, kept simple:
- One responsibility per class and file.
- UI does not call data sources or services directly.
- Extend by adding new code, not by unnecessarily modifying working code.
- Do not over-engineer: keep it as simple as the task allows.

UI and language:
- The app is RTL and Arabic. Do not hardcode left/right alignment; use start/end.
- Child-friendly: large touch targets and clear, simple layouts.

When you answer:
- Keep changes small.
- Briefly explain why you structured the code that way.
- Make sure the code is valid and would pass flutter analyze.

"
When you answer: keep changes small, explain briefly why you structured it that way, and make sure the code would pass flutter analyze.
```
