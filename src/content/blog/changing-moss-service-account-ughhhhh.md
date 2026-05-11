---
title: "Changing the MOSS Service Account.... ughhhhh"
description: "Bad Idea... Changing the password of the SharePoint service account used to set up and run everything SharePoint. If you have done this read the next paragraph before touching your keyboard again."
pubDate: 2009-09-01
category: power-apps
tags:
  - "sharepoint-2007-administration"
draft: false
originalBloggerUrl: /2009/09/changing-moss-service-account-ughhhhh.html
---

**Bad Idea...** Changing the password of the SharePoint service account used to set up and run everything SharePoint. If you have done this read the next paragraph before touching your keyboard again.  
  
**Worse Idea...** Trying to change the password back to what it was, but when confronted with domain password policies that do not allow you to change the password to one you have used recently you delete the user. Then you go in and recreate the user and assign him the old password. **IMPORTANT**: If you go into the Active Directory Users and Computers under the Administrator tools and you are a domain administrator you can reset the password of any user to whatever you want. Domain policies be damned. So if you have not deleted the service account yet just change the password in the way I just described. Then reset your sharepoint machine and be thankful that you don't have to read the rest of this article.  
  
Now lets say you decided to do these two things..... ughhhh. Why doesn't recreating the user in Active Directory and setting it to the old password work. Because each user account is given it's own Security Identifier also called a SID. The SID is unique every time you create a user. That means even though you created the user with the same name the SID is going to be new. Think of it like looking at identical twins, sure they may look exactly the same from far away but get close enough and you start to find some diferences. Why is that important???? Because SharePoint, SQL, and just about every other Microsoft server software identifies users by their SID and not their user name. This is especially true for SharePoint.  
  
**Here is how to fix your problems:**  
  
-Create a new active directory user. call the user something differenct than what you called you original SharePoint service account. In your naming also try to change it to something that won't confuse you as to which one is the new and which was is the old users.  
  
**Example**: If you original SharePoint service account was call MOSSService call the new one something like SharePointService  
  
-Add your new user into the **Local Administrators** security group on the box that is hosting SharePoint.  
  
-Add your new user into the **Local Administrators** security group on the box that is hosting SQL.  
  
-Open the SQL Server Management Studio and add in your new user as a login. Then assign the following SQL roles to that user: **securityadmin, dbcreator**  
  
-Now go to the linked KB article and follow the insructions. Make sure that you substitube the new SharePoint service account information for the DomainName\UserName and password fields. <http://support.microsoft.com/kb/934838>  
  
Still Having Trouble?  
  
In my specific instance of this happening I still received the "Unknown Error" message from SharePoint when trying to access the site. So here is what I had to do inaddition to everything above.  
  
-Log into the SharePoint machine using your new service account.   
  
-Hope you have a recent STSADM backup of the site.  
  
-Complete an STSADM restore of the site.  
  

```
stsadm -o restore -url https://www.something.com -file C:\Temp\Backup.bak -overwrite
```

  
-Run the following command you ran previously in the KB article:   
  

```
stsadm -o updatefarmcredentials -userlogin DomainName\UserName -password NewPassword
```

  
-Reset IIS by typing this into the command promp:   
  

```
iisreset /noforce
```

  
-Run a second command that you ran previously in the KB article:  
  

```
stsadm -o updateaccountpassword -userlogin DomainName\UserName -password NewPassword -noadmin
```

  
-Open the IIS (Internet Information Services) utility from the Administrator tools and ensure that all the Application Pools have the correct user assigned. In this case our new user was called SharePointService. If you still see the old user there change the application pool.   
  
-Reset IIS by typing this into the command promp:   
  

```
iisreset /noforce
```

  
If all else fails get in contact with me and expect to pay a lot of money to fix it.
