import 'package:bookgraph/home_page.dart';
import 'package:bookgraph/model/user.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isVisible = true;
  bool isLogin = false;
  bool isLoading = false;

  void login() async{          
    for (var i = 0; i < userList.length; i++) {
      if (_usernameController.text == userList[i].username && _passwordController.text == userList[i].password) {        
        await Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomePage(user: userList[i])
        ));
        isLogin = true;        
      }
    }    
    if (!isLogin) {      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username atau password salah!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        )
      );      
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // ------------------- Tittle ----------------------  //
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 50, bottom: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Book",
                      style: TextStyle(color: Colors.cyan[900], fontSize: 26)
                    ),
                    TextSpan(
                      text: "Graph",
                      style: TextStyle(
                        color: Colors.cyan[900],
                        fontSize: 26,
                        fontWeight: FontWeight.bold)
                    )
                  ])
                ),
              ),
              // ------------------- Tittle (end) ----------------------  //
              // ------------------- Image ----------------------  //
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Image.asset('assets/images/login.png'),
                ),
              ),
              // ------------------- Image (end) ----------------------  //
              // ------------------- Text Field ----------------------  //
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username'
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: isVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                        icon: Icon(
                          isVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => isVisible = !isVisible)),
                      ),
                    )
                  ],
                ),
              ),
              // ------------------- Text Field (end) ----------------------  //
              // ------------------- Button ----------------------  //
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: InkWell(                
                  onTap: () {
                    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Username atau password tidak boleh kosong!'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                        )
                      );
                    }else{
                      setState(() => isLoading = true);
                      login();
                    }                    
                  },
                  child: !isLoading? Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.cyan[900],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ): Center(child: CircularProgressIndicator()),
                ),
              )
              // ------------------- Button (end) ----------------------  //
            ],
          ),
        ),
      ),
    );
  }  
}
