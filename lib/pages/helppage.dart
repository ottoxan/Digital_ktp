import 'package:flutter/material.dart';


class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Help Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(

                    child: const Column(
                      children: [
                      Text('Halaman KTP', style: TextStyle(fontSize: 20)),
                      Text('Isi KTP dan detailnya'),
                    ],),
                  ),
                  const SizedBox(height: 20,),
                  const Text('Halaman Wallet', style: TextStyle(fontSize: 20)),
                  const Text('Isi Kartu SIM'),
                  const SizedBox(height: 20,),
                  const Text('Halaman Settings', style: TextStyle(fontSize: 20)),
                  const Text('Isi Account dan logout'),
                ],
              ),
            ),
            const SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}
