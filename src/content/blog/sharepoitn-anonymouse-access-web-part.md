---
title: "SharePoint Anonymouse Access Web Part Targeting"
description: "LoginView Control"
pubDate: 2010-04-22
updatedDate: 2010-08-10
category: power-apps
tags:
  - "security"
  - "sharepoint-2007-administration"
  - "sharepoint-2007-development"
draft: false
originalBloggerUrl: /2010/04/sharepoitn-anonymouse-access-web-part.html
---

**LoginView Control**

This control can be used to show content based upon if a users is anonymous or logged in.    In the case below the word “test” would be shown for anonymous users.

Advantages:

-This would just need to be added to the layout page which is being used for the main portal page.

Issues:

-You cannot put a web part or webpart zone within the control only html which mean you could not use to target web parts to users only html code.

-You cannot edit the content within the browser any updates to your content need to be done in a text editor and pushed to the server during a release.

```
<tr ID="TopRow">
 <td valign="top" ID="TopCell" width="100%" colspan="3">
  <asp:LoginView id="LoginView1" runat="server">               
   <AnonymousTemplate>
    <div>Show to Anonymous User</div>
   </AnonymousTemplate>
   <LoggedInTemplate>
    <div>Show to Logged In User</div>
   </LoggedInTemplate>
  </asp:LoginView>
 </td>
</tr>
```

  

**SP Security Trimmed Control**

This control is great for hiding webparts from anonymous users but not from hiding them from logged in users.

Advantages:

-This would just need to be added to the layout page which is being used for the main portal page.

Issues:

-Does not hide webparts from logged in users.

```
<sharepoint:spsecuritytrimmedcontrol runat="server" permissionsstring="CreateSSCSite">
<webpartpages:webpartzone runat="server" frametype="TitleBarOnly" id="Left" title="loc:Left">
<zonetemplate>
<webpartpages:imagewebpart runat="server" verticalalignment="Middle" allowedit="True" allowconnect="True" connectionid="00000000-0000-0000-0000-000000000000" title="Site Image" isincluded="True" dir="Default" backgroundcolor="transparent" isvisible="True" alternativetext="Microsoft Windows SharePoint Services Logo" allowminimize="True" exportcontrolledproperties="True" zoneid="Left" id="g_60b6aa26_dd7b_4973_aaa0_ece2f2110920" horizontalalignment="Center" imagelink="/_layouts/images/thumbsup.jpg" exportmode="All" allowhide="True" suppresswebpartchrome="False" chrometype="None" framestate="Normal" missingassembly="Cannot import this Web Part." allowremove="True" helpmode="Modeless" frametype="None" allowzonechange="True" partorder="1" description="Use to display pictures and photos." __markuptype="vsattributemarkup" __webpartid="{60B6AA26-DD7B-4973-AAA0-ECE2F2110920}" webpart="true"></webpartpages:imagewebpart>
</zonetemplate>
</webpartpages:webpartzone>
</sharepoint:spsecuritytrimmedcontrol>
```

**SharePoint Anonymous Audience Feature**

<http://features.codeplex.com/>

This is a feature build for SharePoint which adds a check box under the audience settings in all webparts to allow you to directly target them to anonymous users.

Advantages:

-Is automatically integrated into all webparts so it can be used everywhere.

-Web part configuration is done through the browser which means changing a webpart does not require a redeployment.

-When you are logged in and viewing the page in design mode you can still see the webparts that are targeted to anonymous which you are unable to do with the other solutions.

Issues:

Because it is a coded solution it may require review by a Change Control Board before deploying to server.
