import 'package:digital_ktp/card_data.dart';
import 'package:digital_ktp/my_card.dart';
import 'package:flutter/cupertino.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
                itemBuilder: (context, index){
                  return MyCard(
                    card: myCards[index],
                  );
                },
                separatorBuilder: (context, index){
                  return const SizedBox(height: 20,);
                },
                itemCount: myCards.length,
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }
}

