import 'dart:async';
import 'package:flutter/material.dart';
import 'package:khind/components/gradient_button.dart';
import 'package:khind/themes/text_styles.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailCT = new TextEditingController();
  TextEditingController firstNameCT = new TextEditingController();
  TextEditingController lastNameCT = new TextEditingController();
  TextEditingController mobileNoCT = new TextEditingController();
  TextEditingController dobCT = new TextEditingController();
  TextEditingController passwordCT = new TextEditingController();
  TextEditingController confirmPasswordCT = new TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailCT.dispose();
    passwordCT.dispose();
    super.dispose();
  }

  Widget _renderHeader() {
    return Container(
        alignment: Alignment.center,
        child: Image(
            image: AssetImage('assets/images/logo.png'),
            height: MediaQuery.of(context).size.width * 0.2));
  }

  Widget _renderForm() {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          TextFormField(
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
            controller: emailCT,
            onFieldSubmitted: (val) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            decoration: InputDecoration(
                hintText: 'eg: khind@gmail.com',
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter first name';
              }
              return null;
            },
            controller: firstNameCT,
            onFieldSubmitted: (val) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            decoration: InputDecoration(
                hintText: 'First Name',
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter last name';
              }
              return null;
            },
            controller: lastNameCT,
            onFieldSubmitted: (val) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            decoration: InputDecoration(
                hintText: 'Last Name',
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter mobile number';
              }
              return null;
            },
            controller: mobileNoCT,
            onFieldSubmitted: (val) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            decoration: InputDecoration(
                hintText: 'Mobile Number',
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter date of birth';
              }
              return null;
            },
            controller: dobCT,
            onFieldSubmitted: (val) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            decoration: InputDecoration(
                hintText: 'Date of Birth',
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 5),
          Stack(children: [
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: !showPassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              controller: passwordCT,
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5))),
            ),
            Positioned(
                right: 15,
                top: 10,
                child: InkWell(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Icon(showPassword ? Icons.visibility : Icons.visibility_off)))
          ]),
          SizedBox(height: 5),
          Stack(children: [
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: !showConfirmPassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter confirm password';
                }
                return null;
              },
              controller: confirmPasswordCT,
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: InputDecoration(
                  hintText: 'Retype Password',
                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5))),
            ),
            Positioned(
                right: 15,
                top: 10,
                child: InkWell(
                    onTap: () {
                      setState(() {
                        showConfirmPassword = !showConfirmPassword;
                      });
                    },
                    child: Icon(showConfirmPassword ? Icons.visibility : Icons.visibility_off)))
          ]),
          SizedBox(height: 30),
          GradientButton(
              height: 40,
              child: Text("Sign Up", style: TextStyles.textW500),
              gradient: LinearGradient(
                  colors: <Color>[Colors.white, Colors.grey[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              onPressed: () {})
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[300]!,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.blue[500],
              size: 40,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Sign Up", style: TextStyle(color: Colors.black)),
          titleSpacing: -10),
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(bottom: 20, left: 50, right: 50, top: 10),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(height: 50),
                _renderHeader(),
                SizedBox(height: 50),
                _renderForm(),
                SizedBox(height: 50)
              ]))),
    );
  }
}
