

import 'package:event_app/Usefull/Colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {


  @override
  Widget build(BuildContext context) {

    const StringA ='Ibento is developed to bring people together as a social network so they can discover and share events that align with their interests. This service is provided by Team ASPER and is intended for use as is.\n\n'
        'This page is used to inform visitors regarding our policies regarding the collection, use, and disclosure of personal information while using our services.\n\n'
        'If you choose to use our service, then you agree to the collection and use of information in relation to this policy. The personal information that is collected is used for providing and improving the service. We will not use or share your information with anyone except as described in this privacy policy.\n\n'
        'Unless otherwise defined, the terms used in this privacy policy have the same meaning as in our Terms and Conditions, which are accessible at Ibento.';

    const StringB ='For a better experience, while using our service, we may require you to provide us with certain personally identifiable information, including but not limited to storage and Internet. The information that is requested will be retained on your device and is not collected by us in any way.\n\n'
                   'The app does use third-party services that may collect information used to identify you. Link to the privacy policies of third-party service providers used by the app link daalna yaha pe';
    const StringC ='This is to inform you that whenever you use our service, in the event of an error in the app, we collect data and information (through third-party products) on your phone called "Log Data.\n\n'
                   'This log data may include information such as your devices Internet Protocol ("IP") address, device name, operating system version, the configuration of the app when utilizing our service, the time and date of your use of the service, and other statistics.';
    const StringD = 'Cookies are small files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your devices internal memory. This service does not use these "cookies" explicitly. However, the app may use third-party code and libraries that use "cookies" to collect information and improve their services.\n\n'
                    'You have the option to either accept or refuse these cookies, and you will know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this service.';
    const StringE = 'We may employ third-party companies and individuals due to the following reasons\n'
                     '  To facilitate our service\n'
                     '  To provide the service on our behalf\n'
                     '  To perform service-related services\n'
                     '  To assist us in analyzing how our service is used\n\n'
                     'We want to inform users of this service that these third parties have access to your personal information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.';
    const StringF = 'We value your trust in providing us with your personal information, so we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.';
    const StringG = 'This service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, it is strongly advised to review the privacy policies of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.';
    const StringH = 'These services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that I will be able to take the necessary actions.';
    const StringI = 'We may update our privacy policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.';



    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation:0,
        backgroundColor:Colors.transparent,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Iconsax.arrow_left_2,color: Colors.white,),
        ),
      ),
        body:SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              mainTextFAQS("Privacy Policy", textColor, 20.0, FontWeight.bold, 10),
              SizedBox(height: 20.0,),
              mainTextFAQS(StringA, textColor, 15.0, FontWeight.normal, 30),
              SizedBox(height: 10.0,),
              mainTextFAQS(StringB, textColor, 15.0, FontWeight.normal, 30),
              SizedBox(height: 10.0,),
              mainTextFAQS(StringC, textColor, 15.0, FontWeight.normal, 30),
              SizedBox(height: 10.0,),

              mainTextFAQS(StringD, textColor, 15.0, FontWeight.normal, 30),
              SizedBox(height: 10.0,),
              mainTextFAQS(StringE, textColor, 15.0, FontWeight.normal, 30),
              SizedBox(height: 10.0,),
              mainTextFAQS(StringF, textColor, 15.0, FontWeight.normal, 30),
              SizedBox(height: 10.0,),
              mainTextFAQS(StringG, textColor, 15.0, FontWeight.normal, 30),
             SizedBox(height: 10.0,),
              mainTextFAQS(StringH, textColor, 15.0, FontWeight.normal, 30),
            SizedBox(height: 10.0,),
               mainTextFAQS(StringI, textColor, 15.0, FontWeight.normal, 30),
                              SizedBox(height: 10.0,),

          ]
          ),
        ),

    );
  }
}

