# UAWC Beneficiaries - iPhone/Flutter Starter V2

نسخة بداية أكثر تنظيمًا لتطبيق المستفيدين الخاص باتحاد لجان العمل الزراعي.

## الخدمات الأساسية
- تسجيل الدخول
- إضافة مستفيد
- البحث عن مستفيد
- تأكيد الاستلام
- حفظ العمليات Offline
- مزامنة العمليات عند توفر الإنترنت
- استخدام API الحالي

## Base API
`https://fm.uawc.net/public/API`

## التشغيل على Mac
```bash
flutter pub get
flutter run
```

## تجهيز TestFlight لاحقًا
```bash
flutter build ipa --release
```

ثم رفع ملف IPA عبر Xcode أو Transporter إلى App Store Connect.

## ملاحظة مهمة
هذه نسخة هيكلية قابلة للتطوير. يجب اختبار أسماء الحقول المطلوبة فعليًا من السيرفر قبل الاعتماد النهائي.
