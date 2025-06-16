// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetEmailController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    // Form validation
    if (emailController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Email adresi boş olamaz.';
      });
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Şifre boş olamaz.';
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text.trim())) {
      setState(() {
        errorMessage = 'Geçerli bir email adresi giriniz.';
      });
      return;
    }

    try {
      setState(() {
        errorMessage = '';
      });
      await Auth().signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Başarılı giriş sonrası controller'ları temizle
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Bu email adresi ile kayıtlı kullanıcı bulunamadı.';
            break;
          case 'wrong-password':
            errorMessage = 'Yanlış şifre girdiniz.';
            break;
          case 'invalid-email':
            errorMessage = 'Geçersiz email adresi formatı.';
            break;
          case 'user-disabled':
            errorMessage = 'Bu kullanıcı hesabı devre dışı bırakılmış.';
            break;
          case 'too-many-requests':
            errorMessage =
                'Çok fazla başarısız deneme. Lütfen daha sonra tekrar deneyin.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/şifre ile giriş devre dışı.';
            break;
          case 'invalid-credential':
            errorMessage = 'Email veya şifre hatalı.';
            break;
          case 'network-request-failed':
            errorMessage = 'İnternet bağlantısını kontrol edin.';
            break;
          case 'email-not-verified':
            errorMessage = 'Email adresinizi doğrulamanız gerekiyor.';
            break;
          default:
            errorMessage = 'Giriş yapılamadı. Lütfen tekrar deneyin.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Beklenmeyen bir hata oluştu.';
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    // Form validation
    if (emailController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Email adresi boş olamaz.';
      });
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Şifre boş olamaz.';
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text.trim())) {
      setState(() {
        errorMessage = 'Geçerli bir email adresi giriniz.';
      });
      return;
    }

    if (passwordController.text.trim().length < 6) {
      setState(() {
        errorMessage = 'Şifre en az 6 karakter olmalıdır.';
      });
      return;
    }

    try {
      setState(() {
        errorMessage = '';
      });
      await Auth().createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Başarılı kayıt sonrası controller'ları temizle
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'weak-password':
            errorMessage =
                'Şifre çok zayıf. En az 6 karakter ve karmaşık olmalı.';
            break;
          case 'email-already-in-use':
            errorMessage =
                'Bu email adresi zaten başka bir hesap tarafından kullanılıyor.';
            break;
          case 'invalid-email':
            errorMessage = 'Geçersiz email adresi formatı.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/şifre ile kayıt işlemi devre dışı.';
            break;
          case 'too-many-requests':
            errorMessage =
                'Çok fazla kayıt denemesi. Lütfen daha sonra tekrar deneyin.';
            break;
          case 'network-request-failed':
            errorMessage = 'İnternet bağlantısını kontrol edin.';
            break;
          default:
            errorMessage = 'Hesap oluşturulamadı. Lütfen tekrar deneyin.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Beklenmeyen bir hata oluştu.';
      });
    }
  }

  Future<void> resetPassword() async {
    String email = resetEmailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        errorMessage = 'Email adresi boş olamaz.';
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        errorMessage = 'Geçerli bir email adresi giriniz.';
      });
      return;
    }

    try {
      await Auth().sendPasswordResetEmail(email: email);
      resetEmailController.clear();
      if (mounted) {
        Navigator.of(context).pop(); // Dialog'u kapat
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Şifre sıfırlama bağlantısı email adresinize gönderildi.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Bu email adresi ile kayıtlı kullanıcı bulunamadı.';
            break;
          case 'invalid-email':
            errorMessage = 'Geçersiz email adresi formatı.';
            break;
          case 'too-many-requests':
            errorMessage = 'Çok fazla istek. Lütfen daha sonra tekrar deneyin.';
            break;
          case 'network-request-failed':
            errorMessage = 'İnternet bağlantısını kontrol edin.';
            break;
          default:
            errorMessage = 'Şifre sıfırlama işlemi başarısız oldu.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Beklenmeyen bir hata oluştu.';
      });
    }
  }

  void showForgotPasswordDialog() {
    resetEmailController.clear();
    setState(() {
      errorMessage = '';
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Şifremi Unuttum',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineSmall?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Şifre sıfırlama bağlantısı göndermek için email adresinizi girin:',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: resetEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email Adresi',
                  hintText: 'ornek@email.com',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: resetPassword,
              child: const Text('Gönder'),
            ),
          ],
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/image/logo.png',
                      height: 200,
                      scale: 0.5,
                    )),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text('Giriş Yap',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      )),
                ),
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      'QuizVerse Hesabınızı Kullanın',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email Adresi',
                      hintText: 'ornek@email.com',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Şifre',
                      hintText: 'En az 6 karakter',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                if (isLogin) // Sadece giriş modunda göster
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: showForgotPasswordDialog,
                      child: Text(
                        'Şifremi Unuttum',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.lightBlue[300]
                              : Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    errorMessage == '' ? '' : 'Hata: $errorMessage',
                    style: TextStyle(
                      fontSize: 15,
                      color: errorMessage == ''
                          ? Colors.transparent
                          : Colors.red.withOpacity(0.8),
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: isLogin
                          ? signInWithEmailAndPassword
                          : createUserWithEmailAndPassword,
                      child: Text(isLogin ? 'Giriş' : 'Kayıt'),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      isLogin ? 'Hesabınız yok mu?' : 'Hesabın var mı?',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin ? 'Kayıt Ol' : 'Giriş Yap'),
                    )
                  ],
                ),
              ],
            )));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
    super.dispose();
  }
}
