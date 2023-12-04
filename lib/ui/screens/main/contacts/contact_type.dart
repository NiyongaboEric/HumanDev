import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';

class ContactType extends StatefulWidget {
  const ContactType({super.key});

  @override
  State<ContactType> createState() => _ContactTypeState();
}

class _ContactTypeState extends State<ContactType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColors.bgLightGreen,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          _buildContactTypeContainer('Student', Icons.person),
          const SizedBox(height: 20),
          _buildContactTypeContainer('Parent', Icons.message),
          const SizedBox(height: 20),
          _buildContactTypeContainer('Teacher', Icons.send),
          const SizedBox(height: 20),
          _buildContactTypeContainer('Supplier', Icons.money),
          const SizedBox(height: 20),
          Divider(
            color: PrimaryColors.primaryLightGreen,
            thickness: 1,
          ),
          const SizedBox(height: 20),
          _buildContactTypeContainer('Other people', Icons.sms),
          const SizedBox(height: 20),
          _buildContactTypeContainer('Other organizations', Icons.chat),
          const SizedBox(height: 10),
        ],
      )
    );
  }

  AppBar _buildAppBar (){
    return AppBar(
      backgroundColor: PrimaryColors.primaryLightGreen,
      iconTheme: IconThemeData(
        color: SecondaryColors.secondaryLightGreen,
      ),
      elevation: 0,
      title: Text(
        'Create contact',
        style: TextStyle(
          color: SecondaryColors.secondaryLightGreen,
        ),
      ),
    );
  }

  Widget _buildContactTypeContainer(String type, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: TertiaryColors.tertiaryLightGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: SecondaryColors.secondaryLightGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          title: Text(
            type,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
