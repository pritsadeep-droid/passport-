// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'ระบบติดตาม KPI ทดลองงาน';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get email => 'อีเมล';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get dashboard => 'แดชบอร์ด';

  @override
  String get employees => 'พนักงาน';

  @override
  String get kpi => 'KPI';

  @override
  String get assessment => 'การประเมิน';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get probationPeriod => 'ช่วงทดลองงาน';

  @override
  String daysRemaining(int days) {
    return 'เหลืออีก $days วัน';
  }

  @override
  String get progress => 'ความคืบหน้า';

  @override
  String get complete => 'เสร็จสมบูรณ์';

  @override
  String get pending => 'รอดำเนินการ';

  @override
  String get approved => 'อนุมัติแล้ว';

  @override
  String get rejected => 'ไม่อนุมัติ';

  @override
  String get submit => 'ส่ง';

  @override
  String get save => 'บันทึก';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get loading => 'กำลังโหลด...';
}
