---
title: "Xrm.Page.ui Not Available on Primary Grid"
description: "While developing an EnableRule for some new functionality I decided to use an Async call. Here is a great link on how to use Async calls with EnableRule."
pubDate: 2011-09-01
heroImage: "/heroes/xrmpageui-not-available-on-primary-grid.png"
heroImageAlt: "test"
category: power-apps
tags:
  - "crm-2011"
  - "javascript"
  - "ribbon"
draft: false
originalBloggerUrl: /2011/09/xrmpageui-not-available-on-primary-grid.html
---

While developing an EnableRule for some new functionality I decided to use an Async call.  Here is a great link on how to use Async calls with EnableRule.

<http://myencounterwithcrm.wordpress.com/2011/06/09/walkthrough-of-asynchronous-call-from-customrule-ribbondiff/>

Microsoft even notes this strategy in the SDK documentation: 

Consider that Microsoft sees this as the “proper way” to do things you might think that they would provide the necessary methods to complete this, that would only be half correct.

All of this works if you are on an entity form because Xrm.Page.ui.refreshRibbon() is available.  Unfortunately if you are in a grid such as the one displayed below, Xrm.Page.ui is null, which means you cannot call the refreshRibbon() method.

[![test2](/images/xrmpageui-not-available-on-primary-grid/01-img.png "test2")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEibQYZwcOcd9wVu2fM5yPKrO0qYHHBNx2YCRuPhTnuYcYdje6yt1jL0oIf0Zu2ZjIH8RzvGrr7h0B1aDpSvbKlSXSxgxoGIrZF3zX2Eay46d3RtzKtNQTOQwGFOx0dnT00CPRsVDJncgSg/s1600-h/test2%25255B5%25255D.png)

DAGGER!!!!!!

If anyone knows a way in which to get around this please leave a comment ![Smile](/images/xrmpageui-not-available-on-primary-grid/02-img.png)
