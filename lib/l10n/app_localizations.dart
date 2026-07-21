import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'SOTKonya'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @news.
  ///
  /// In ar, this message translates to:
  /// **'الأخبار'**
  String get news;

  /// No description provided for @events.
  ///
  /// In ar, this message translates to:
  /// **'الفعاليات'**
  String get events;

  /// No description provided for @housing.
  ///
  /// In ar, this message translates to:
  /// **'السكنات'**
  String get housing;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get signup;

  /// No description provided for @adminLogin.
  ///
  /// In ar, this message translates to:
  /// **'دخول المسؤول'**
  String get adminLogin;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @name.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get name;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get resetPassword;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get error;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noData;

  /// No description provided for @welcomeBack.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك'**
  String get welcomeBack;

  /// No description provided for @guest.
  ///
  /// In ar, this message translates to:
  /// **'زائر'**
  String get guest;

  /// No description provided for @latestNews.
  ///
  /// In ar, this message translates to:
  /// **'أحدث الأخبار'**
  String get latestNews;

  /// No description provided for @latestEvents.
  ///
  /// In ar, this message translates to:
  /// **'أحدث الفعاليات'**
  String get latestEvents;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات حالياً'**
  String get noNotifications;

  /// No description provided for @markAllRead.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل كمقروء'**
  String get markAllRead;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف الشخصي'**
  String get editProfile;

  /// No description provided for @personalInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الشخصية'**
  String get personalInfo;

  /// No description provided for @academicInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الأكاديمية'**
  String get academicInfo;

  /// No description provided for @additionalInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات إضافية'**
  String get additionalInfo;

  /// No description provided for @gender.
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get male;

  /// No description provided for @female.
  ///
  /// In ar, this message translates to:
  /// **'أنثى'**
  String get female;

  /// No description provided for @age.
  ///
  /// In ar, this message translates to:
  /// **'العمر'**
  String get age;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الجوال'**
  String get phone;

  /// No description provided for @university.
  ///
  /// In ar, this message translates to:
  /// **'الجامعة'**
  String get university;

  /// No description provided for @faculty.
  ///
  /// In ar, this message translates to:
  /// **'الكلية'**
  String get faculty;

  /// No description provided for @major.
  ///
  /// In ar, this message translates to:
  /// **'التخصص'**
  String get major;

  /// No description provided for @studyYear.
  ///
  /// In ar, this message translates to:
  /// **'المستوى الدراسي'**
  String get studyYear;

  /// No description provided for @studentNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطالب الجامعي'**
  String get studentNumber;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @turkish.
  ///
  /// In ar, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @notificationsSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الإشعارات'**
  String get notificationsSettings;

  /// No description provided for @enableNotifications.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الإشعارات'**
  String get enableNotifications;

  /// No description provided for @newsNotifications.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات الأخبار'**
  String get newsNotifications;

  /// No description provided for @eventsNotifications.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات الفعاليات'**
  String get eventsNotifications;

  /// No description provided for @userManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المستخدمين'**
  String get userManagement;

  /// No description provided for @administration.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الجامعة'**
  String get administration;

  /// No description provided for @aboutApp.
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get aboutApp;

  /// No description provided for @shareApp.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة التطبيق'**
  String get shareApp;

  /// No description provided for @version.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار'**
  String get version;

  /// No description provided for @addNews.
  ///
  /// In ar, this message translates to:
  /// **'إضافة خبر جديد'**
  String get addNews;

  /// No description provided for @editNews.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الخبر'**
  String get editNews;

  /// No description provided for @deleteNews.
  ///
  /// In ar, this message translates to:
  /// **'حذف الخبر'**
  String get deleteNews;

  /// No description provided for @newsTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الخبر'**
  String get newsTitle;

  /// No description provided for @newsSummary.
  ///
  /// In ar, this message translates to:
  /// **'الملخص'**
  String get newsSummary;

  /// No description provided for @newsContent.
  ///
  /// In ar, this message translates to:
  /// **'نص الخبر'**
  String get newsContent;

  /// No description provided for @newsDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الخبر'**
  String get newsDate;

  /// No description provided for @publishNews.
  ///
  /// In ar, this message translates to:
  /// **'نشر الخبر'**
  String get publishNews;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التغييرات'**
  String get saveChanges;

  /// No description provided for @addEvent.
  ///
  /// In ar, this message translates to:
  /// **'إضافة فعالية جديدة'**
  String get addEvent;

  /// No description provided for @editEvent.
  ///
  /// In ar, this message translates to:
  /// **'تعديل فعالية'**
  String get editEvent;

  /// No description provided for @deleteEvent.
  ///
  /// In ar, this message translates to:
  /// **'حذف الفعالية'**
  String get deleteEvent;

  /// No description provided for @eventTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الفعالية'**
  String get eventTitle;

  /// No description provided for @eventDescription.
  ///
  /// In ar, this message translates to:
  /// **'وصف الفعالية'**
  String get eventDescription;

  /// No description provided for @eventLocation.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get eventLocation;

  /// No description provided for @eventDateTime.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ والوقت'**
  String get eventDateTime;

  /// No description provided for @register.
  ///
  /// In ar, this message translates to:
  /// **'التسجيل'**
  String get register;

  /// No description provided for @registered.
  ///
  /// In ar, this message translates to:
  /// **'مسجل'**
  String get registered;

  /// No description provided for @registrationFull.
  ///
  /// In ar, this message translates to:
  /// **'اكتمل العدد'**
  String get registrationFull;

  /// No description provided for @saveEvent.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الفعالية'**
  String get saveEvent;

  /// No description provided for @addHousing.
  ///
  /// In ar, this message translates to:
  /// **'إضافة سكن جديد'**
  String get addHousing;

  /// No description provided for @editHousing.
  ///
  /// In ar, this message translates to:
  /// **'تعديل السكن'**
  String get editHousing;

  /// No description provided for @deleteHousing.
  ///
  /// In ar, this message translates to:
  /// **'حذف السكن'**
  String get deleteHousing;

  /// No description provided for @housingName.
  ///
  /// In ar, this message translates to:
  /// **'اسم السكن'**
  String get housingName;

  /// No description provided for @housingStatus.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get housingStatus;

  /// No description provided for @housingRent.
  ///
  /// In ar, this message translates to:
  /// **'الإيجار'**
  String get housingRent;

  /// No description provided for @noNewsYet.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم إضافة أخبار حتى الآن'**
  String get noNewsYet;

  /// No description provided for @noEventsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد فعاليات حالياً.'**
  String get noEventsYet;

  /// No description provided for @noHousingYet.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم إضافة سكنات حتى الآن'**
  String get noHousingYet;

  /// No description provided for @confirmDelete.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من الحذف؟ لا يمكن التراجع.'**
  String get confirmDelete;

  /// No description provided for @pressBackToExit.
  ///
  /// In ar, this message translates to:
  /// **'اضغط مرة أخرى للخروج من التطبيق'**
  String get pressBackToExit;

  /// No description provided for @emailVerificationSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رابط التحقق إلى بريدك الإلكتروني. يرجى التحقق قبل تسجيل الدخول.'**
  String get emailVerificationSent;

  /// No description provided for @emailNotVerified.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم التحقق من البريد الإلكتروني. يرجى التحقق من بريدك.'**
  String get emailNotVerified;

  /// No description provided for @resendVerification.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال رابط التحقق'**
  String get resendVerification;

  /// No description provided for @verificationResent.
  ///
  /// In ar, this message translates to:
  /// **'تم إعادة إرسال رابط التحقق بنجاح.'**
  String get verificationResent;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In ar, this message translates to:
  /// **'صيغة البريد الإلكتروني غير صحيحة'**
  String get invalidEmailFormat;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني مستخدم مسبقاً'**
  String get emailAlreadyExists;

  /// No description provided for @registrationSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم التسجيل بنجاح! يرجى التحقق من بريدك الإلكتروني.'**
  String get registrationSuccess;

  /// No description provided for @searchByNameOrEmail.
  ///
  /// In ar, this message translates to:
  /// **'بحث بالاسم أو الإيميل'**
  String get searchByNameOrEmail;

  /// No description provided for @makeAdmin.
  ///
  /// In ar, this message translates to:
  /// **'جعله أدمن'**
  String get makeAdmin;

  /// No description provided for @removeAdmin.
  ///
  /// In ar, this message translates to:
  /// **'إزالة صلاحية أدمن'**
  String get removeAdmin;

  /// No description provided for @blockUser.
  ///
  /// In ar, this message translates to:
  /// **'حظر المستخدم'**
  String get blockUser;

  /// No description provided for @unblockUser.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الحظر'**
  String get unblockUser;

  /// No description provided for @deleteUser.
  ///
  /// In ar, this message translates to:
  /// **'حذف المستخدم'**
  String get deleteUser;

  /// No description provided for @enterName.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال الاسم'**
  String get enterName;

  /// No description provided for @selectGenderUniversityYear.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار الجنس والجامعة وسنة الدراسة'**
  String get selectGenderUniversityYear;

  /// No description provided for @savedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ التعديلات بنجاح'**
  String get savedSuccessfully;

  /// No description provided for @savingChanges.
  ///
  /// In ar, this message translates to:
  /// **'جاري الحفظ...'**
  String get savingChanges;

  /// No description provided for @eventDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الفعالية'**
  String get eventDetails;

  /// No description provided for @aboutEvent.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عن الفعالية'**
  String get aboutEvent;

  /// No description provided for @eventSchedule.
  ///
  /// In ar, this message translates to:
  /// **'جدول الفعالية'**
  String get eventSchedule;

  /// No description provided for @location.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get location;

  /// No description provided for @fee.
  ///
  /// In ar, this message translates to:
  /// **'الأجرة'**
  String get fee;

  /// No description provided for @whatsappConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد التسجيل والدفع عبر واتساب'**
  String get whatsappConfirm;

  /// No description provided for @viewRequests.
  ///
  /// In ar, this message translates to:
  /// **'عرض طلبات التسجيل'**
  String get viewRequests;

  /// No description provided for @loginFirst.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخول أولاً لإرسال طلب التسجيل'**
  String get loginFirst;

  /// No description provided for @requestSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الطلب (بانتظار المراجعة)'**
  String get requestSent;

  /// No description provided for @requestExists.
  ///
  /// In ar, this message translates to:
  /// **'لديك طلب قيد المراجعة بالفعل'**
  String get requestExists;

  /// No description provided for @alreadyApproved.
  ///
  /// In ar, this message translates to:
  /// **'أنت مسجل بالفعل (تمت الموافقة مسبقاً)'**
  String get alreadyApproved;

  /// No description provided for @requestRejected.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض طلبك سابقاً. تواصل مع الإدارة'**
  String get requestRejected;

  /// No description provided for @registrationDisabled.
  ///
  /// In ar, this message translates to:
  /// **'التسجيل غير مفعّل لهذه الفعالية'**
  String get registrationDisabled;

  /// No description provided for @eventNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على الفعالية'**
  String get eventNotFound;

  /// No description provided for @addAdminMember.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عضو إدارة'**
  String get addAdminMember;

  /// No description provided for @editAdminMember.
  ///
  /// In ar, this message translates to:
  /// **'تعديل عضو إدارة'**
  String get editAdminMember;

  /// No description provided for @deleteAdminMember.
  ///
  /// In ar, this message translates to:
  /// **'حذف عضو الإدارة'**
  String get deleteAdminMember;

  /// No description provided for @namePosition.
  ///
  /// In ar, this message translates to:
  /// **'الاسم / المنصب'**
  String get namePosition;

  /// No description provided for @job.
  ///
  /// In ar, this message translates to:
  /// **'الوظيفة'**
  String get job;

  /// No description provided for @aboutMember.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عنه'**
  String get aboutMember;

  /// No description provided for @contactInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات التواصل'**
  String get contactInfo;

  /// No description provided for @noAdminMembers.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم اختيار الإداريين بعد لقسم الإدارة'**
  String get noAdminMembers;

  /// No description provided for @noRegistrationRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد طلبات تسجيل حالياً لهذا النشاط.'**
  String get noRegistrationRequests;

  /// No description provided for @pendingReview.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get pendingReview;

  /// No description provided for @approved.
  ///
  /// In ar, this message translates to:
  /// **'تم القبول'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get rejected;

  /// No description provided for @website.
  ///
  /// In ar, this message translates to:
  /// **'الموقع الإلكتروني'**
  String get website;

  /// No description provided for @readMore.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ المزيد'**
  String get readMore;

  /// No description provided for @eventFullMessage.
  ///
  /// In ar, this message translates to:
  /// **'عذراً، اكتمل العدد المطلوب لهذه الفعالية.'**
  String get eventFullMessage;

  /// No description provided for @requestPending.
  ///
  /// In ar, this message translates to:
  /// **'طلبك قيد المراجعة...'**
  String get requestPending;

  /// No description provided for @paidEventPendingInfo.
  ///
  /// In ar, this message translates to:
  /// **'سيتم تأكيد تسجيلك فور دفع الرسوم. يمكنك التواصل مع المشرف لتسريع العملية.'**
  String get paidEventPendingInfo;

  /// No description provided for @requestApproved.
  ///
  /// In ar, this message translates to:
  /// **'تم قبول طلبك بنجاح! ننتظرك بالفعالية.'**
  String get requestApproved;

  /// No description provided for @whatsappInquiryPrefix.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً، أرسل هذا الاستفسار بخصوص فعالية'**
  String get whatsappInquiryPrefix;

  /// No description provided for @contactAdminWhatsApp.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع المشرف (واتساب)'**
  String get contactAdminWhatsApp;

  /// No description provided for @loginRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تسجيل الدخول أولاً'**
  String get loginRequired;

  /// No description provided for @requestSentSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلبك بنجاح'**
  String get requestSentSuccess;

  /// No description provided for @paidEventFeeInfo.
  ///
  /// In ar, this message translates to:
  /// **'هذه الفعالية مأجورة. تكلفة التسجيل: '**
  String get paidEventFeeInfo;

  /// No description provided for @requestPaidRegistration.
  ///
  /// In ar, this message translates to:
  /// **'طلب تسجيل (مأجور)'**
  String get requestPaidRegistration;

  /// No description provided for @registerNow.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الآن'**
  String get registerNow;

  /// No description provided for @viewRegistrationRequests.
  ///
  /// In ar, this message translates to:
  /// **'عرض طلبات التسجيل'**
  String get viewRegistrationRequests;

  /// No description provided for @role.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحية'**
  String get role;

  /// No description provided for @admin.
  ///
  /// In ar, this message translates to:
  /// **'مسؤول'**
  String get admin;

  /// No description provided for @blocked.
  ///
  /// In ar, this message translates to:
  /// **'محظور'**
  String get blocked;

  /// No description provided for @user.
  ///
  /// In ar, this message translates to:
  /// **'مستخدم'**
  String get user;

  /// No description provided for @removeAdminRole.
  ///
  /// In ar, this message translates to:
  /// **'إزالة صلاحية مسؤول'**
  String get removeAdminRole;

  /// No description provided for @addNewEvent.
  ///
  /// In ar, this message translates to:
  /// **'إضافة فعالية جديدة'**
  String get addNewEvent;

  /// No description provided for @dateTime.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ والوقت'**
  String get dateTime;

  /// No description provided for @selectDateTime.
  ///
  /// In ar, this message translates to:
  /// **'اختر تاريخ ووقت الفعالية'**
  String get selectDateTime;

  /// No description provided for @registrationLinkOptional.
  ///
  /// In ar, this message translates to:
  /// **'رابط التسجيل (اختياري)'**
  String get registrationLinkOptional;

  /// No description provided for @websiteLinkOptional.
  ///
  /// In ar, this message translates to:
  /// **'رابط الموقع (اختياري)'**
  String get websiteLinkOptional;

  /// No description provided for @allowRegistration.
  ///
  /// In ar, this message translates to:
  /// **'السماح بالتسجيل على الفعالية'**
  String get allowRegistration;

  /// No description provided for @paidEvent.
  ///
  /// In ar, this message translates to:
  /// **'الفعالية مأجورة'**
  String get paidEvent;

  /// No description provided for @maxParticipantsHint.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى للمشاركين (اتركه فارغ = غير محدد)'**
  String get maxParticipantsHint;

  /// No description provided for @feeAmount.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ الأجرة'**
  String get feeAmount;

  /// No description provided for @currencyHint.
  ///
  /// In ar, this message translates to:
  /// **'العملة (مثال: ₺ أو TRY)'**
  String get currencyHint;

  /// No description provided for @adminWhatsAppHint.
  ///
  /// In ar, this message translates to:
  /// **'رقم واتساب الأدمن لتأكيد الدفع (مثال: +905xxxxxxxxx)'**
  String get adminWhatsAppHint;

  /// No description provided for @selectDateTimePrompt.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ ووقت الفعالية'**
  String get selectDateTimePrompt;

  /// No description provided for @enterValidFeePrompt.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال مبلغ أجرة صحيح'**
  String get enterValidFeePrompt;

  /// No description provided for @enterAdminWhatsAppPrompt.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رقم واتساب الأدمن للفعاليات المأجورة'**
  String get enterAdminWhatsAppPrompt;

  /// No description provided for @housingDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل السكن'**
  String get housingDetails;

  /// No description provided for @status.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get status;

  /// No description provided for @rent.
  ///
  /// In ar, this message translates to:
  /// **'الإيجار'**
  String get rent;

  /// No description provided for @contactRoomsInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات التواصل / نوع الغرف'**
  String get contactRoomsInfo;

  /// No description provided for @googleMapsLink.
  ///
  /// In ar, this message translates to:
  /// **'رابط خرائط Google'**
  String get googleMapsLink;

  /// No description provided for @aboutHousing.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عن السكن'**
  String get aboutHousing;

  /// No description provided for @saveHousing.
  ///
  /// In ar, this message translates to:
  /// **'حفظ السكن'**
  String get saveHousing;

  /// No description provided for @addNewNews.
  ///
  /// In ar, this message translates to:
  /// **'إضافة خبر جديد'**
  String get addNewNews;

  /// No description provided for @summary.
  ///
  /// In ar, this message translates to:
  /// **'الملخص'**
  String get summary;

  /// No description provided for @selectNewsDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر تاريخ الخبر'**
  String get selectNewsDate;

  /// No description provided for @selectImages.
  ///
  /// In ar, this message translates to:
  /// **'اختر صور'**
  String get selectImages;

  /// No description provided for @enterNewsTitlePrompt.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال عنوان الخبر'**
  String get enterNewsTitlePrompt;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد؟ لا يمكن التراجع عن هذه العملية.'**
  String get deleteConfirmMessage;

  /// No description provided for @currentImages.
  ///
  /// In ar, this message translates to:
  /// **'الصور الحالية:'**
  String get currentImages;

  /// No description provided for @addNewImages.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صور جديدة'**
  String get addNewImages;

  /// No description provided for @viewOnMap.
  ///
  /// In ar, this message translates to:
  /// **'عرض على الخريطة'**
  String get viewOnMap;

  /// No description provided for @housingDetailsButton.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل السكن'**
  String get housingDetailsButton;

  /// No description provided for @viewDetailsAndRegister.
  ///
  /// In ar, this message translates to:
  /// **'عرض التفاصيل والتسجيل'**
  String get viewDetailsAndRegister;

  /// No description provided for @housingDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل السكن'**
  String get housingDetailsTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
