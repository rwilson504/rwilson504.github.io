---
title: "Custom Flow Connector For Parsing Address"
description: "While working on a demo of the Business Cards Scanner component for PowerApps I found that the component only returns the address as a single line and not as parsed address components (UPDATE: The…"
pubDate: 2019-08-21
updatedDate: 2019-12-11
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjEyqC_VYacwu2mSCi8rvK_DbWHKtyQMqWqIexY1v8i18qdTlteAhvi5r7U7mOOVfFju8g11kxiTW53Kt_QtvPwGqa9YfdVgdTOwbDvk0P-QZk6wmah56Q5TPBQLnNeDr_ki6WVDvyZMhc/s640/addresslabs.png"
category: power-apps
tags:
  - "cds"
  - "connectors"
  - "flow"
  - "power-apps"
  - "power-platform"
draft: false
originalBloggerUrl: /2019/08/custom-flow-connector-for-parsing.html
---

While working on a demo of the Business Cards Scanner component for PowerApps I found that the component only returns the address as a single line and not as parsed address components (**UPDATE**: The Business Card Scanner does not split the address fields into the same level of detail as the Contact/Account entities).  After looking around for flow connectors that could parse the data I only found one from Pitney Bowes.  Looking around there are a lot APIs available for address parsing but they are not currently available on Flow so I decided to build my first custom Flow connector to utilize one of these APIs.  
  
Address Labs (<http://www.addresslabs.com/>) does not require an API key to use and since I'm only doing a few calls for my demos it worked well for me.  You can also check out their document on GitHub (<https://github.com/addresslabs/api-docs/blob/master/README.md>).  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjEyqC_VYacwu2mSCi8rvK_DbWHKtyQMqWqIexY1v8i18qdTlteAhvi5r7U7mOOVfFju8g11kxiTW53Kt_QtvPwGqa9YfdVgdTOwbDvk0P-QZk6wmah56Q5TPBQLnNeDr_ki6WVDvyZMhc/s640/addresslabs.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjEyqC_VYacwu2mSCi8rvK_DbWHKtyQMqWqIexY1v8i18qdTlteAhvi5r7U7mOOVfFju8g11kxiTW53Kt_QtvPwGqa9YfdVgdTOwbDvk0P-QZk6wmah56Q5TPBQLnNeDr_ki6WVDvyZMhc/s1600/addresslabs.png)

  
One of the easiest ways to create a custom connector to flow is to use a Postman collection.  
  
After downloading Postman create a new request. (<https://www.getpostman.com/downloads/>)  
  
Change the request type to **POST** and enter the example url that is provided by Address Labs.  
  
Set a Header value for **"Content-Type": "application/json"**.  
  
Send the request to test it.  
  
After you have tested the call export the Collection in v1 format. (This is the only format currently allowed for custom connectors)  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj58kEIbMaCAcS8CwttgZjZqcPc8_Dp9P65Exx73lYG6szxwdt-PK4zfa1lmVZCy_HLTTRbk6A3Ih02Ybz5gn4GKBthq6-WMkn9obHSvu9kjPIMRP9__qFU7RHC5oozQ5UHr9z2niVWrJU/s1600/Custom+Connector+Postman.gif)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj58kEIbMaCAcS8CwttgZjZqcPc8_Dp9P65Exx73lYG6szxwdt-PK4zfa1lmVZCy_HLTTRbk6A3Ih02Ybz5gn4GKBthq6-WMkn9obHSvu9kjPIMRP9__qFU7RHC5oozQ5UHr9z2niVWrJU/s1600/Custom+Connector+Postman.gif)

  
Navigate to the flow admin page ([https://flow.microsoft.com](https://flow.microsoft.com/)).  
  
After you log in click on the **gear icon** in the upper right hand corner and select **Custom Connectors**.  
  
In the **New custom connector** drop down select **Import a Postman collection**.  
  
Add a connection name such as Address Labs and then select the Postman collection json file you created previously.  
  
After you click continue you will be taken to the new connector **General** screen, this includes the basic information about your new connector such as the Icon, Description, Scheme, and Host address, click the **Security** button at the bottom of this screen.  
  
On the **Security** screen you can leave it set to **No Authentication** since Address Labs does not require any, click the Definition button.  The information on the **Definition** page was created using the Postman collection information you supplied, there are no changes needed but you can review the information to understand what is going on.  
  
Click on the **Create connector** button at the top of the page.  
  
Finally at the bottom of the Definition page you can click the Test button. On the Test page click the **New connection** button.  After the connection has been created the **Test operation** button will become available and you can click it to test your connection.  
  
After you have tested your connector click the **Update connector** button then the **Close** button.  We are now ready to add this connection to a Flow.  While on the Custom connectors screen you can also download your custom connection so you can save it for another environment.  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh_pRvZs5-Qw52A9_3LBUBgaB8yU653ZtS1n7yQY8K5BJvPpSehCQEx82ayjr0o0Az9Yxm1m04asme6IWNKTM6uzO9wSnJzgQ-GW6dj8PCiXcJ7gn63HzoB4pZAws6_cwMwHD8NtsNVx08/s1600/Custom+Connector+Create+Connector.gif)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh_pRvZs5-Qw52A9_3LBUBgaB8yU653ZtS1n7yQY8K5BJvPpSehCQEx82ayjr0o0Az9Yxm1m04asme6IWNKTM6uzO9wSnJzgQ-GW6dj8PCiXcJ7gn63HzoB4pZAws6_cwMwHD8NtsNVx08/s1600/Custom+Connector+Create+Connector.gif)

Next we will build a flow to utilize the response from the service.  This will be demonstrated using a manual flow which will add a Contact record in a CDS database.  
  
On the Flow admin page click **My Flows** and the **New** button.  For this demonstration choose **Instant-from blank** to fire it manually.  
  
Enter a name for the Flow and choose **From Microsoft Flow** as the trigger.  Click the **Create** button.  
  
Add a New step after the trigger and select the Custom tab, you will see the new Address Labs connector you created, click on the icon and select the Get Address action.  You can change the address field here if you want or leave it as the default for our test.  
  
Add another step to the Flow using the **Parse JSON** action.  The content for the action will be the Body of the Get Address Action.  Click the Use sample payload to generate the schema and copy in the Result from the Postman request you completed earlier.  Additional you can use the json file i have included here ([Address Labs Schema](https://drive.google.com/file/d/1YwdvC9g1yqPXODbj1Hn2Zov4KTBye9gP/view?usp=sharing)) which includes additional fields that are not part of the sample address.  
  
Finally add a step to **Create a new record** in the **Common Data Services** area.  You can utilize the dynamic output from the Parse JSON action to add data to the record.  
  
After you are done you can test your Flow using the **Test** button in the upper right hand corner then browse to your CDS instance to see the data.  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiQB8laI29Q2RkjMLYZWexyRn96JjUPQG34AttOrvOL_5cVUfXnm0eW7WKrTX4kKlK087TjZXmC4M3oJqM0dksBL87_Wv850v3RH1fSqfPL9Y6G7encmW1rkEduCamx3mIibCBmIMf5uVg/s1600/Custom+Connector+Create+Flow.gif)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiQB8laI29Q2RkjMLYZWexyRn96JjUPQG34AttOrvOL_5cVUfXnm0eW7WKrTX4kKlK087TjZXmC4M3oJqM0dksBL87_Wv850v3RH1fSqfPL9Y6G7encmW1rkEduCamx3mIibCBmIMf5uVg/s1600/Custom+Connector+Create+Flow.gif)
