import 'package:flutter/material.dart';
import 'package:myapp/USER/Screen/LoginScreen.dart';

class Createscreen extends StatelessWidget {
//Sign Up
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(      
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(243, 162, 11, 1),
                Color.fromARGB(255, 19, 16, 21),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
            ),
          ),

//create account
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Create Your\nAccount',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

//box putih
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), 
                  topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),  //jarak kanan kiri tulisan
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
//kolom nama
                      
                      const TextField(
                        decoration: InputDecoration(
                            label: Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                
//kolom email            
                      const TextField(
                        decoration: InputDecoration(
                            label: Text(
                          'Gmail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                 
//kolom password             
                      const TextField(
                        decoration: InputDecoration(
                            label: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                    
//kolom confirm password                
                      const TextField(
                        decoration: InputDecoration(
                            label: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      
//tombol Sign In                  
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(243, 162, 11, 1),
                              Color.fromARGB(255, 19, 16, 21),
                              ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),                  
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
