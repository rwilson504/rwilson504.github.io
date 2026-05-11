---
title: "Global Context for CRM 2011"
description: "When creating htm pages as webresources in 2011 there are many times you would want to get information about CRM such as the orgname and server url.…"
pubDate: 2011-04-15
category: power-apps
tags:
  - "crm-2011"
  - "javascript"
draft: false
originalBloggerUrl: /2011/04/global-context-for-crm-2011.html
---

When creating htm pages as webresources in 2011 there are many times you would want to get information about CRM such as the orgname and server url.  This is where the ClientGlobalContext comes in to play.  
  

```
 <script src="ClientGlobalContext.js.aspx"></script>
```

  
Remember that if the web resource name has a folder name(s) before it you must include preceding "../" in front of the script name.  
  
Example 1:  
Webresource Name: mycust\_/test.htm  
Script reference:  

```
 <script src="../ClientGlobalContext.js.aspx"></script>
```

  
Example 2:  
  

Webresource Name: mycust\_/elements/test.htm

Script reference:

```
 <script src="../../ClientGlobalContext.js.aspx"></script>
```

  
By adding this reference into your htm file you will now have access to several javascript functions:   
  

```
getAuthenticationHeader: Returns the encoded SOAP header that you need to use Microsoft Dynamics CRM 4.0 Web service calls using Jscript. 

getOrgLcid: Returns the LCID value that represents the Microsoft Dynamics CRM Language Pack that is the base language for the organization.

getOrgUniqueName: Returns the unique text value of the organization’s name.

getQueryStringParameters: Returns an array of key value pairs representing the query string arguments that were passed to the page.

getServerUrl: Returns the base server URL. When a user is working offline with Microsoft Dynamics CRM for Microsoft Office Outlook, the URL is to the local Microsoft Dynamics CRM Web services.

getUserId: Returns the GUID value of the SystemUser.id for the current user.

getUserLcid: Returns the LCID value that represents the Microsoft Dynamics CRM Language Pack that is the user selected as their preferred language.

getUserRoles: Returns an array of strings that represent the GUID values of each security role that the user is associated with.
```

  
Additionally this allows for access to some CRM Global Variables:  
  

```
var USER_GUID='\x7b2CBE7DEF-1141-E011-89F6-A956C6342E5F\x7d';
var ORG_LANGUAGE_CODE=1033;
var ORG_UNIQUE_NAME='test';
var SERVER_URL='https\x3a\x2f\x2frick2011.permuta.com\x2ftest';
var USER_LANGUAGE_CODE=1033;
var USER_ROLES=['a5201165-7ebd-47dc-af91-3185fc89b077'];
var CRM2007_WEBSERVICE_NS='http\x3a\x2f\x2fschemas.microsoft.com\x2fcrm\x2f2007\x2fWebServices';
var CRM2007_CORETYPES_NS='http\x3a\x2f\x2fschemas.microsoft.com\x2fcrm\x2f2007\x2fCoreTypes';
var AUTHENTICATION_TYPE=0;
var CURRENT_THEME_TYPE='Outlook14Silver';
var CURRENT_WEB_THEME='Default';
var IS_OUTLOOK_CLIENT=false;
var IS_OUTLOOK_LAPTOP_CLIENT=false;
var IS_OUTLOOK_14_CLIENT=false;
var IS_ONLINE=true;
```
