# دليل الشغل على GitHub

الدليل ده للفريق كله، وخطواته مكتوبة بالترتيب. لو حصل أي لبس، اسألوا الفريق قبل ما تمسحوا أو تعدّلوا حاجة.

## أول مرة بس (إعداد الجهاز)

1. اقبلوا دعوة الريبو اللي وصلتكم على الإيميل.
2. عرّفوا Git باسمكم (بالإنجليزي، وإيميل GitHub بتاعكم):

```bash
git config --global user.name "Your Name"
git config --global user.email "your-github-email@example.com"
```

3. نزّلوا المشروع على جهازكم:

```bash
git clone https://github.com/Malaksabra/Grad-Project.git
cd Grad-Project/mobile
flutter pub get
```

## كل مرة هتبدأوا مهمة جديدة

**1. حدّثوا نسختكم من `main`:**

```bash
git checkout main
git pull
```

**2. اعملوا فرع (Branch) للمهمة.** الاسم بحروف صغيرة وشرطة، وبيبدأ بـ `feature/`:

```bash
git checkout -b feature/communication-first-screen
```

**3. اشتغلوا في فولدر الـ feature بتاعكم بس**، جوه `mobile/lib/features/`.

**4. اتأكدوا إن الكود سليم قبل الحفظ** (من جوه فولدر `mobile`):

```bash
flutter analyze
flutter test
```

**5. احفظوا شغلكم (Commit) وابعتوه (Push):**

```bash
git add .
git commit -m "Add communication first screen"
git push -u origin feature/communication-first-screen
```

رسالة الـ commit تكون قصيرة وواضحة وتبدأ بفعل، زي `Add` أو `Fix`.

**6. افتحوا Pull Request على GitHub:**

- افتحوا صفحة الريبو، هيظهر شريط أصفر فيه زرار **Compare & pull request**، دوسوا عليه.
- اكتبوا سطرين عن اللي عملتوه، ودوسوا **Create pull request**.

**7. زميل يراجع ويدمج:** حد تاني من الفريق يفتح الـ Pull Request، يقرأ التعديلات، ويدوس **Merge pull request** لو كله تمام.

**8. بعد الدمج، ارجعوا لـ `main` وحدّثوه:**

```bash
git checkout main
git pull
```

## قواعد لازم نلتزم بيها

- **محدش يرفع على `main` مباشرة.** كل شغل يعدّي من فرع و Pull Request.
- **كل واحد في فولدر الـ feature بتاعه.** لو محتاجين نعدّل في `core/` أو `shared/` أو `app.dart` أو `pubspec.yaml`، نقول للفريق الأول.
- **الأسماء بالإنجليزي وحروف صغيرة**، والملفات والفولدرات بشرطة سفلية زي `daily_routines`.
- **متحطوش في الريبو:** كلمات سر، مفاتيح، أو فولدر `build/`.

## لو حصلت مشكلة

- **`git push` رفض وقال إن فيه تعديلات جديدة على الريبو:** اكتبوا `git pull` وبعدين `git push` تاني.
- **ظهرت رسالة فيها كلمة `conflict`:** متمسحوش حاجة. ابعتوا الرسالة للفريق وهنحلها سوا.
- **عملتوا commit على `main` بالغلط:** متعملوش push. قولوا للفريق الأول.
- **مش عارفين إنتو على أنهي فرع:** اكتبوا `git status`، السطر الأول بيقولكم.