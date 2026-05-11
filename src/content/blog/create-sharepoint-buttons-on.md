---
title: "Create SharePoint Buttons on Administration Page"
description: "A long time ago I wrote a SharePoint administration page and had used the \"Microsoft.SharePoint.Portal.WebControls\" dll to create Ok and Cancel buttons at the bottom of the page."
pubDate: 2014-01-23
updatedDate: 2014-03-24
category: power-apps
tags:
  - "sharepoint-2010"
draft: false
originalBloggerUrl: /2014/01/create-sharepoint-buttons-on.html
---

A long time ago I wrote a SharePoint administration page and had used the "Microsoft.SharePoint.Portal.WebControls" dll to create Ok and Cancel buttons at the bottom of the page.  Well I recently had a customer who wanted to use it but only had WSS and the page was erroring out when they tried to load it instead I ended up using another solution from Karine Bosch which is below.

Link to original article: <http://karinebosch.wordpress.com/sharepoint-controls/buttonsectionascx-control/>

To include a **ButtonSection** control on an application page you have to use the following syntax:

```
<wssuc:ButtonSection runat="server" ShowStandardCancelButton="true">  
    <template_buttons>  
       <asp:PlaceHolder runat="server">                 
           <asp:Button id="SubmitButton" UseSubmitBehavior="false" runat="server" class="ms-ButtonHeightWidth"   
                       Text="OK" OnClick="SubmitButton_Click" />  
       </asp:PlaceHolder>  
    </template_buttons>  
</wssuc:ButtonSection>
```

  
.csharpcode, .csharpcode pre<br />{<br /> font-size: small;<br /> color: black;<br /> font-family: consolas, "Courier New", courier, monospace;<br /> background-color: #ffffff;<br /> /\*white-space: pre;\*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br /> background-color: #f4f4f4;<br /> width: 100%;<br /> margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />  
  

Add also a directive at the top of the page:

```
<%@ Register TagPrefix="wssuc" TagName="ButtonSection" Src="/_controltemplates/ButtonSection.ascx" %>
```

  
.csharpcode, .csharpcode pre<br />{<br /> font-size: small;<br /> color: black;<br /> font-family: consolas, "Courier New", courier, monospace;<br /> background-color: #ffffff;<br /> /\*white-space: pre;\*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br /> background-color: #f4f4f4;<br /> width: 100%;<br /> margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />  
  

Code for the **OnClick** event of the individual buttons needs to be written within a <script runat=”server” language=”C#”> tag on the application page or in the code behind class from which the application page inherits:

```
protected Button SubmitButton;          
 public void SubmitButton_Click(object sender, System.EventArgs e)  
 {  
     // TODO: must save the changes proposed on the page  
 }
```

  
.csharpcode, .csharpcode pre<br />{<br /> font-size: small;<br /> color: black;<br /> font-family: consolas, "Courier New", courier, monospace;<br /> background-color: #ffffff;<br /> /\*white-space: pre;\*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br /> background-color: #f4f4f4;<br /> width: 100%;<br /> margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />  
  

There are also a number of attributes you can set on the **ButtonSection** control:  

  
- **ShowStandardCancelButton**: if you set this property to **true**, a Cancel button is automatically added to the ButtonSection control. This cancel button will redirect the user to the previous page in the browser history.   
  - **ShowSectionLine**: set this property to **false** if you don’t want a section line to be added above the buttons. The default value is **true**.   
    - **BottomSpacing**: in case of long pages it is possible you want to add a button section at the top of the page and one at the bottom of the page. If you put a button section at the top of the page, you can set this property to a value higher than zero to add extra blank spacing between the button section and the controls that follow.   
      - **SmallSectionLine**: if you set this boolean value to true, the section line will be 1px high; if set to false, the section line will be 2px high. The default is false.
