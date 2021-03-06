---
layout: post
title: ADFS 2.0 Default Claims Provider
date: '2012-06-07T16:31:00.001-04:00'
author: Rick Wilson
tags:
- Web Application
- Web.Config
- ADFS 2.0
- Authentication
modified_time: '2012-06-07T16:40:52.914-04:00'
thumbnail: http://lh6.ggpht.com/-0K1jNUeoDeQ/T9EPbD-g7iI/AAAAAAAAHN4/c8smf8X4Wis/s72-c/image_thumb19.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4593242165240338288
blogger_orig_url: https://www.richardawilson.com/2012/06/adfs-20-default-claims-provider.html
---


 

In situation where you have multiple Claims Providers the HomeRealDiscovery.aspx page may confuse users.

[![image](http://lh6.ggpht.com/-0K1jNUeoDeQ/T9EPbD-g7iI/AAAAAAAAHN4/c8smf8X4Wis/image_thumb19.png?imgmax=800)](http://lh4.ggpht.com/-EB7VihmXSqs/T9ERwF3mrfI/AAAAAAAAHNw/S-mbO-oePo0/s1600-h/image39.png)

As you can see here I have created a second claims provider called test. User may not know which one to use.

[![image](http://lh3.ggpht.com/-bAbvD3cDDUI/T9EPbwNWKaI/AAAAAAAAHOA/TNkEzsNzygs/image_thumb20.png?imgmax=800)](http://lh3.ggpht.com/-NIFlFpkgEEo/T9EPbhDDPuI/AAAAAAAAHN8/sDq_hV4-oHM/s1600-h/image40.png)

**FIX 1** – Well not really a fix as much as a way to reduce this issue.

One way to help with this confusion is by setting the **persistIdentityProviderInformation** enabled value to true and the lifetimeInDays value to something like 30 in the web.config located at **C:\inetpub\adfs\ls**.  This will allow users to only have to select their claim provider every 30 days.

[![image](http://lh3.ggpht.com/-tD5Q_n4y4jU/T9EPc6CaVkI/AAAAAAAAHME/fw954K6gwHs/image_thumb%25255B8%25255D.png?imgmax=800)](http://lh5.ggpht.com/-Yac2jycl_dA/T9EPcQ8y8WI/AAAAAAAAHL8/rfss_TMkAO4/s1600-h/image%25255B18%25255D.png)

**FIX 2** – Update your web application to allow for WHR parameter

Another way to allows users to divert the HomeRealDiscovery page is by adding functionality to your web application that allows the whr parameter to determine which claim provider will be used when doing the redirect to ADFS.  Again this code all goes into your web application and does not require any additional work on the ADFS website.

Add a reference to the Microsoft.IdentityModel in your web application

[![image](http://lh4.ggpht.com/-F6MXdqcjmJ8/T9EPduZYclI/AAAAAAAAHMU/y_oIYMLNBfw/image_thumb.png?imgmax=800)](http://lh4.ggpht.com/-Slr7LFObDkY/T9EPdOWyRiI/AAAAAAAAHMM/E-HBf4GmlDo/s1600-h/image%25255B2%25255D.png)

If you don’t already have a Global.asax file in your web application add a new item and select Global Application Class.

![](http://www.siue.edu/~dbock/cmis460/Module%2008%20--%20Manage%20State/Module08-ManageState_files/image011.jpg)

You will need to add an additional handler to the code behind of the Global.asax file.

[![image](http://lh5.ggpht.com/-wssucqlfeWA/T9EPeVH6MMI/AAAAAAAAHOI/tn9E-wsc2To/image_thumb21.png?imgmax=800)](http://lh3.ggpht.com/-yq2Wu68qgO8/T9EPd5m-6xI/AAAAAAAAHOE/ImcjRSh5rrA/s1600-h/image41.png)

    
        void WSFederationAuthenticationModule_RedirectingToIdentityProvider(object sender, RedirectingToIdentityProviderEventArgs e)
        
    
    
        {
        
    
    
              e.SignInRequestMessage.HomeRealm = Request["whr"];
        
    
    
        }
    
    

What’s great is that the Identity Model already knows what to do with this method, there is no more code to write.

Now just add the ?whr=identityID parameter to your applications url and you will no longer see the HomeRealDiscovery page but be automatically directed to the authentication method.

Let’s look at two example of how to use this.  For both of these my web application will be located at:

[https://mywebapp.contoso.com](https://mywebapp.contoso.com)

My STS (ADFS) server will be located at:

[https://sts.contoso.com](https://sts.contoso.com)

**EXAMPLE 1:** Using the build in Active Directory Claims Provider

-First we will need to get the entityID of our claims provider.  To get this we will go to the FederationMetadata on the STS (ADFS) server at the following url:

[https://sts.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml](https://sts.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml)

**NOTE**: Depending on your IE Version this page may come up blank.  If you do not see the XML on the page hit the compatibility view button in IE.
[![image](http://lh5.ggpht.com/-6niGUtv9l9g/T9EPfH0_pFI/AAAAAAAAHM0/hf-OkYDArbo/image_thumb%25255B11%25255D.png?imgmax=800)](http://lh3.ggpht.com/-KNRkRK3_ykg/T9EPeqzX3wI/AAAAAAAAHMs/jYKE33DilXI/s1600-h/image%25255B25%25255D.png)

The entityID for the default provider is in the first line:

[![image](http://lh5.ggpht.com/-ZRTq9SEKzjc/T9EPf1iEQPI/AAAAAAAAHOQ/eZQ4V58NdLI/image_thumb23.png?imgmax=800)](http://lh3.ggpht.com/-lCkgB_xIXwo/T9EPfRkUcuI/AAAAAAAAHOM/UadWb9OPmNI/s1600-h/image43.png)

Copy the value for the entity ID and add it as the value for the whr parameter in your application url.

[https://mywebapp.contoso.com/?whr=https://sts.contoso.com/adfs/services/trust](https://mywebapp.contoso.com/?whr=https://sts.contoso.com/adfs/services/trust)

**NOTE**: Make sure you copy the entityID parameter exactly, case does matter on this one so no mixing upper case and lower case letters.

**EXAMPLE 2**: Using a custom Claims Provider

This one is actually easier than getting the information for the default claims provider since you can access it from the ADFS 2.0 GUI. Open the properties for the Claims Provider Trust you want to access.

[![image](http://lh5.ggpht.com/-s0duH3l1YKc/T9EPggjp1cI/AAAAAAAAHOY/8WfWL60r2MA/image_thumb24.png?imgmax=800)](http://lh4.ggpht.com/-S_sKSCNrkzM/T9EPgB1erPI/AAAAAAAAHOU/7lOi8gUgnL0/s1600-h/image44.png)

On the Identifiers page copy the “Claims provider identifier”

[![image](http://lh3.ggpht.com/-PK0sk21c348/T9EPhdKoWoI/AAAAAAAAHOg/ADreMctJ1bw/image_thumb25.png?imgmax=800)](http://lh6.ggpht.com/-mACWPChNXD0/T9EPhIwQ60I/AAAAAAAAHOc/05U2N53jhjA/s1600-h/image45.png)

Add the value for the whr parameter in your application url.

[https://mywebapp.contoso.com/?whr=urn:federation:test](https://mywebapp.contoso.com/?whr=urn:federation:test)

**NOTE**: Make sure you copy the Claims provider identifier exactly, case does matter on this one so no mixing upper case and lower case letters.

**IIS REDIRECT**

In order to force users to a specific claims provider you can set up an IIS Redirect which will tag on the whr parameter you want to use.  That way if user go to [https://mywebapp.contoso.com](https://mywebapp.contoso.com) it will auto add the whr parameter.

