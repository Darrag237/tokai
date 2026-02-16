# Tokai (TokTok) — Flutter App (Copy‑Ready)

هذا المشروع تنفيذ Flutter كامل مبني على صور الشاشات داخل `assets/screens/` مع محاولة مطابقة التصميم قدر الإمكان وربط تدفق التنقل.

> **مهم:** بيئة التوليد هنا لا تحتوي على Flutter SDK، لذلك تم بناء كود Flutter + هيكلة المشروع + الاعتماديات بشكل كامل.  
> لتشغيله على جهازك (Android/iOS) نفّذ الخطوات أدناه.

---

## التشغيل

```bash
flutter pub get
flutter run
```

### ملاحظة عن ملفات المنصات (android/ios)
إذا واجهت أن المشروع لا يحتوي ملفات المنصة كاملة (أو كانت لديك مشاكل Gradle/Xcode)، نفّذ مرة واحدة داخل مجلد المشروع:

```bash
flutter create . --platforms=android,ios
```

ثم أعد تشغيل:

```bash
flutter pub get
flutter run
```

---

## إعداد Firebase

المشروع يستخدم:
- Firebase Auth (Email/Password)
- Cloud Firestore

### 1) ربط Firebase

استخدم FlutterFire:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

ثم تأكد أن:
- `firebase_options.dart` تم توليده داخل `lib/` (FlutterFire يقوم بذلك)
- `google-services.json` في `android/app/`
- `GoogleService-Info.plist` في `ios/Runner/`

> الكود يقوم بمحاولة `Firebase.initializeApp()`، وإذا لم تكن Firebase مهيأة سيظل التطبيق يعمل ولكن ميزات Firestore/Auth ستفشل برسالة مناسبة.

---

## Firestore Schema

### 1) Chatbot Knowledge Base
Collection: `faq`

Fields:
- `question` (string)
- `answer` (string)
- `tags` (array<string>)
- `updatedAt` (timestamp)

### 2) Reservations
Collection: `reservations`

Fields:
- `userId` (string)
- `pickupText` (string)
- `dropoffText` (string)
- `scheduledAt` (timestamp)
- `repeatType` (string: none/daily/weekly/custom)
- `repeatDays` (array<int>)
- `notes` (string | null)
- `status` (string: scheduled/cancelled/done)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

### 3) User Emergency Settings
Collection: `user_settings` (docId = userId)

Fields:
- `emergencyMessageTemplate` (string)
- `emergencyTargets` (array<string>)
- `updatedAt` (timestamp)

### 4) User Profile (اختياري)
Collection: `user_profiles` (docId = userId)

Fields:
- `name` (string)
- `phone` (string | null)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

## Seed بيانات FAQ (للبوت)

أضف Documents داخل `faq` يدويًا من Firebase Console.

مثال Document:

```json
{
  "question": "ازاي اعمل حجز مسبق؟",
  "answer": "من الرئيسية اضغط (حجز) ثم (إنشاء حجز مسبق)...",
  "tags": ["الحجز", "reservation"],
  "updatedAt": "<timestamp>"
}
```

> البحث داخل البوت **بسيط**: contains + matching tags على جانب العميل مع fallback آمن (بدون هلوسة).

---

## Features المطلوبة

### Feature 1 — Chatbot
- شاشة `سألنا` ضمن BottomNavigation.
- يعتمد على Firestore collection `faq`.
- حالة المحادثة + التحميل/الخطأ عبر Riverpod.

### Feature 2 — Reservation (Pre‑booking)
- المسار: `الحجوزات المسبقة`.
- شاشات: List → Create → Confirm → Save.
- Validations:
  - pickup & dropoff مطلوبين
  - scheduledAt في المستقبل
  - custom repeatDays غير فارغ
- **TODO:** Stub لإشعارات محلية (تم وضع تعليق في الكود).

### Feature 3 — Emergency Button (SMS)
- زر طوارئ واضح داخل Home (FAB أحمر) + شاشة إعدادات.
- BottomSheet (اختيار سريع) + اختيار جهات متعددة.
- تخزين الإعدادات في Firestore `user_settings`.
- إرسال SMS عبر `url_launcher` بصيغة:
  - `sms:<number>?body=<encoded>`
- fallback: لو الجهاز لا يدعم SMS تظهر رسالة خطأ.

---

## Routing + Guards
- `Splash → Onboarding → Welcome → Auth → Main Shell`
- Guards عبر FirebaseAuth login state.
- Routing باستخدام `go_router`.

---

## Responsive + RTL
- `flutter_screenutil` مفعّل.
- RTL مفروض عبر `Directionality(textDirection: TextDirection.rtl)`.

---

## Project Structure

Feature-first Clean Architecture (مبسطة):

```
lib/
  app.dart
  main.dart
  core/
    routing/
    theme/
    utils/
    widgets/
    services/
    errors/
  features/
    auth/
    chatbot/
    reservation/
    emergency/
    home/
    offers/
    wallet/
    profile/
    menu/
assets/
  screens/
```

---

## Assumptions (من الصور)

1) التصميم يحتوي شاشات OTP/Phone OTP — لكنها لا تتوافق مباشرة مع Firebase Email/Password. لذلك تم تنفيذ OTP كـ **خطوة UI فقط** للمطابقة البصرية، ثم الانتقال لإكمال الملف الشخصي.
2) بعض الشاشات (Notifications/Search/Location/Settings/Help/Complain/About) تم عرضها كـ **Image-based screens** مع إمكانية التكبير، إلى أن تتضح متطلبات UX بشكل أدق.
3) زر المحفظة يظهر في التصميم كعنصر عائم؛ تم وضعه كزر داخل بطاقة البحث في Home + Route مستقل `/wallet`.

---

## Notes
- تأكد من إضافة Index لـ Firestore عند الحاجة (قد يطلب Firestore index عند `orderBy` + `where`).
- لو احتجت Arabic fonts أو ARB localization: يمكن إضافتها لاحقاً بسهولة.

