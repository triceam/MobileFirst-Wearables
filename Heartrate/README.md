#Heartrate
The **Heartrate** app is a modified version of the [Microsoft Band SDK][band_sdk] Heartrate sample application.   This app will measure the user's heart rate from the Microsoft Band perhiperal/wearabe device for a duration of 45 seconds.  

The app has been configured to use [Bluemix Mobile Client Access][ama_url] for operational analytics and user authentication using [Facebook][facebook_auth] as the identity provider, and it uses the [Cloudant Sync][cloudant_sync] SDK for an offline-first architecture.  In this case, the data is first saved on the local device using [Cloudant Sync][cloudant_sync] and data is automatically saved  up on the [IBM Cloudant][cloudant] cloud database whenver a network connection is present.

![Microsft Band on wrist with iPhone in Background](./github_content/heartrate.jpg)
 
 Once data is saved in the cloud, we can view it online via the Node.js app infrastructure.  Check out some *real* sample data at: http://bluemixheartratemonitor.mybluemix.net 
 
![Heartrate data displayed on the web](./github_content/heartrate-web.jpg)

*Yes, that is really my heartrate while I was working on the demo assets.*

---

### Bluemix Services Used

1. [Mobile Client Access][ama_url] - Capture analytics and logs from mobile apps running on devices
2. [IBM Cloudant][cloudant] - IBM NoSQL Database as a Service

---

### Setting Up The Bluemix Backend


1. Create a Bluemix Account

    [Sign up][bluemix_signup_url] for Bluemix, or sign in using an existing account.
	
2. From the Bluemix Dashboard, click on the "Create App" link, then select the "Mobile" template and walk through the process of creating your app infrastructure.  *Remember the app namel you are going to need it later.*

3. Download and install the [Cloud-foundry CLI][cloud_foundry_url] tool.  This will be used to deploy your Node.js back end.

4. Clone the app to your local environment from your terminal using the following command

  ```
  git clone https://github.com/triceam/MobileFirst-Wearables/tree/master/Heartrate.git
  ```

5. Back in the command line termianl, cd into this newly created directory, then go into the /server directory.

6. Connect to Bluemix in the command line tool and follow the prompts to log in.

  ```
  $ cf api https://api.ng.bluemix.net
  $ cf login
  ```

7. Push it to Bluemix. This will automatically deploy the back end app and start the Node.js instance.  Replace "AppName" with the name of your app on Bluemix.

  ```
  $ cf push AppName
  ```
  
8. Voila! You now have your very own API instance up and running on Bluemix.  Next we need to configure the Mobile Client application.  You can test your Node.js app deployment at https://yourapp.mybluemix.net *(use your actual app route)*.  You can view my live API deployment [here](http://bluemixheartratemonitor.mybluemix.net).

---

### Setting Up The Mobile App

The native iOS application requires **Xcode 6.4** running on a Mac to compile and deploy on either the iOS Simulator or on a development device.  Xcode 6.4 is required to target Apple WatchOS 1.0.

1. If you do not already have it, download and install [CocoaPods][cocoapods_url].

2. In a terminal window, cd into the /client directory (from your local project directory).

3. Run the *pod install* command to setup the Xcode project and download all dependencies.

  ```
  $ pod install
  ```

4. This will create an Xcode Workspace file.  Open the **Bluemix-MicrosoftBand.xcworkspace** file in Xcode.
 
5. Configure Facebook as the identity provider.  This configuration requires settings both on the Mobile Client Access service and in the native code project (inside the "client" directory for this project).   In the local project, be sure to follow the instructions for both sections: [configuring the Facebook SDK][facebook_sdk_config] and [Configuring Faebook Authentication][facebook_auth]. Be sure to make the appropriate changes inside of Info.plist.

6. Open the "**AppDelegate.m**" file.  Update the connection to Bluemix on line 35 to include your app's route and GUID.   

  ```
  [imfClient initializeWithBackendRoute:@"bluemix app route"
                             backendGUID:@"bluemix app guid"];
  ```
 
  You can access the route and app GUID under "Mobile Options" on the app dashboard.
  
  ![Contacts App on Apple Watch](./github_content/mobile-options.jpg)

8. Now you are all set!  Launch the app on a device that has been paired with a Microsoft Band.  Tap on the "Start Heart Rate Sensor" button to start capturing data.  After the heartate capture is complete, data will be saved locally and replicated up to Cloudant.  You will be able to see your data in the web interface once that data has been replicated successfully to Cloudant.   
 

---

### Troubleshooting

To troubleshoot your the server side of your Bluemix app the main useful source of information is the logs. To see them, run:

  ```
  $ cf logs <application-name> --recent
  ```
  
  
[bluemix_signup_url]: https://ibm.biz/IBM-Bluemix
[bluemix_dashboard_url]: https://ibm.biz/Bluemix-Dashboard
[cloud_foundry_url]: https://github.com/cloudfoundry/cli
[download_node_url]: https://nodejs.org/download/
[cocoapods_url]: https://cocoapods.org/
[ama_url]: https://ibm.biz/Bluemix-AdvancedMobileAccess
[band_sdk]: https://developer.microsoftband.com/
[facebook_auth]: https://www.ng.bluemix.net/docs/services/mobileaccess/security/facebook/t_fb_config.html
[facebook_sdk_config]: https://www.ng.bluemix.net/docs/services/mobileaccess/security/facebook/t_fb_sdkroute.html
[cloudant]: https://ibm.biz/IBM-Cloudant
[cloudant_sync]: http://ibm.biz/CloudantSync