import 'package:form_field_validator/form_field_validator.dart';

// Username Validator
final usernameValidator = MultiValidator([
  RequiredValidator(errorText: "กรุณากรอกชื่อผู้ใช้"),
  MinLengthValidator(6,
      errorText: "ชื่อผู้ใช้ควรมีความยาวอย่างน้อย 6 ตัวอักษร"),
  MaxLengthValidator(16,
      errorText: "ชื่อผู้ใช้ควรมีความยาวไม่เกิน 16 ตัวอักษร"),
  PatternValidator(r'^[a-zA-Z0-9ก-๙]+$',
      errorText: 'โปรดใช้อักขระภาษาอังกฤษ หรือภาษาไทย และตัวเลขเท่านั้น')
]);

// Email Validator
final emailValidator = MultiValidator([
  EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
  RequiredValidator(errorText: "กรุณากรอกอีเมลของคุณ"),
]);

// Password Validator
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: "กรุณากรอกรหัสผ่าน"),
  RequiredValidator(errorText: "รหัสผ่านไม่ถูกต้อง"),
]);
