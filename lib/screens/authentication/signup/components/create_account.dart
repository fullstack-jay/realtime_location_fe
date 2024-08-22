import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widgets/text_input_field.dart';
import 'package:flutter_application_1/screens/components/top_snackbar.dart';

import '../../../../../utils/colors.dart';
import '../../../../../utils/helpers.dart';

enum IsLoading { loading, failed, success, idle }

class CreateAccount extends StatefulWidget {
  const CreateAccount({
    Key? key,
    required this.onContinue,
  }) : super(key: key);
  final void Function() onContinue;

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  //final authService = AuthService();
  //final authState = Get.find<AuthState>();

  String? fullName;
  String? email;
  String? password;
  String? confirmPassword;
  IsLoading _isLoading = IsLoading.idle;

  void _onCreateAccount() async {
    setState(() {
      _isLoading = IsLoading.loading;
    });
    // final response =
    //     await authService.createAccount(fullName!, email!, password!);
    if (!mounted) return;
    setState(() {
      _isLoading = IsLoading.success;
    });
    // if (response == null) return;
    //authState.email.value = response["data"]["email"];
    // showMessage(
    //   message: response["data"]["email"],
    //   title: response["message"],
    //   type: MessageType.success,
    // );
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final loading = _isLoading == IsLoading.loading;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Buat Akun",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    addHorizontalSpace(5),
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                Form(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 18.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama Lengkap *".toUpperCase(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: primary.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        addVerticalSpace(8),
                        TextInputField(
                          hintText: "Nama Lengkap",
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                        ),
                        addVerticalSpace(18),
                        Text(
                          "Email*".toUpperCase(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: primary.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        addVerticalSpace(8),
                        TextInputField(
                          hintText: "Email",
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        Text(
                          " Harap diingat Anda akan diminta untuk memverifikasi email ini",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10.sp,
                          ),
                        ),
                        addVerticalSpace(18),
                        Text(
                          "Password*".toUpperCase(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: primary.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        addVerticalSpace(8),
                        TextInputField(
                          hintText: "password",
                          obsecureText: true,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        addVerticalSpace(18),
                        Text(
                          "Konfirmasi Password*".toUpperCase(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: primary.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        addVerticalSpace(8),
                        TextInputField(
                          hintText: "password lagi",
                          obsecureText: true,
                          onChanged: (value) {
                            setState(() {
                              confirmPassword = value;
                            });
                          },
                        ),
                        addVerticalSpace(30),
                        Center(
                          child: Directionality(
                            textDirection:
                                loading ? TextDirection.ltr : TextDirection.rtl,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (fullName == null ||
                                    email == null ||
                                    password == null ||
                                    confirmPassword == null) {
                                  showMessage(
                                    message:
                                        "Semua kolom wajib diisi, silakan isi setiap kolom teks di bawah",
                                    title: "Validasi Gagal",
                                    type: MessageType.error,
                                  );
                                  return;
                                }
                                if (fullName!.isEmpty ||
                                    email!.isEmpty ||
                                    password!.isEmpty ||
                                    confirmPassword!.isEmpty) {
                                  showMessage(
                                    message:
                                        "Semua kolom wajib diisi, silakan isi setiap kolom teks di bawah",
                                    title: "Validasi Gagal",
                                    type: MessageType.error,
                                  );
                                  return;
                                }
                                if (password != confirmPassword) {
                                  showMessage(
                                    message:
                                        "Kata sandi dan konfirmasi kata sandi harus sama",
                                    title: "Konfirmasi Password",
                                    type: MessageType.error,
                                  );
                                  return;
                                }
                                _onCreateAccount();
                              },
                              style: ElevatedButton.styleFrom(
                                disabledBackgroundColor: lightPrimary,
                                disabledForegroundColor: white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30.w,
                                  vertical: 7.h,
                                ),
                              ),
                              icon: loading
                                  ? LoadingAnimationWidget.inkDrop(
                                      color: white, size: 18.sp)
                                  : Icon(
                                      CupertinoIcons.arrow_right,
                                      color: const Color(0xFF9fcdf5),
                                      size: 24.sp,
                                    ),
                              label: Text(
                                loading ? " LOADING..." : "BUAT AKUN",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
