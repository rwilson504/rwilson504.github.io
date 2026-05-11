---
title: "Xrm.Page.ui Not Available on Primary Grid"
description: "While developing an EnableRule for some new functionality I decided to use an Async call. Here is a great link on how to use Async calls with EnableRule."
pubDate: 2011-09-01
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhxPuFE8VibSMUU8k2a6068DxASsmK2Uqke_APclUz_0-QSX_T_oolkDiQzrvBgzuOqOcwyLHOg-4z6FapMr6nfGct6eOy9HMG2TPxx2yoJE55x66HWDM6OFnbiReaX9Ha48cwQbugU7Sc/?imgmax=800"
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
[![test](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhxPuFE8VibSMUU8k2a6068DxASsmK2Uqke_APclUz_0-QSX_T_oolkDiQzrvBgzuOqOcwyLHOg-4z6FapMr6nfGct6eOy9HMG2TPxx2yoJE55x66HWDM6OFnbiReaX9Ha48cwQbugU7Sc/?imgmax=800 "test")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEixVmPO3uhQit_maHY4Pce5nbdvrUIImpjq-JCM1Y4h9Corj6lbLSuIKnlUQGppVTJ-eFpeFJCt4FiHhBV8CpDhapoUddsm5qgsi1DeHmrazDiqp8Eaz3DYDj23Gz-WGFWbNGxybNasRjg/s1600-h/test%25255B4%25255D.png)

Consider that Microsoft sees this as the “proper way” to do things you might think that they would provide the necessary methods to complete this, that would only be half correct.

All of this works if you are on an entity form because Xrm.Page.ui.refreshRibbon() is available.  Unfortunately if you are in a grid such as the one displayed below, Xrm.Page.ui is null, which means you cannot call the refreshRibbon() method.

[![test2](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgWbPPIUl_9SBlVoSuI62-k7RCTlQeQaFtvovX_ZWVofhHqGQGFpty7WSVu5O5qwl-yP8c_JSNe_aRqkctGed7ajl2ge-2P0V32tMXBerRR9DgWPz9ejGxID7DH66YCO8OJ7zIiUKOjyRc/?imgmax=800 "test2")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEibQYZwcOcd9wVu2fM5yPKrO0qYHHBNx2YCRuPhTnuYcYdje6yt1jL0oIf0Zu2ZjIH8RzvGrr7h0B1aDpSvbKlSXSxgxoGIrZF3zX2Eay46d3RtzKtNQTOQwGFOx0dnT00CPRsVDJncgSg/s1600-h/test2%25255B5%25255D.png)

DAGGER!!!!!!

If anyone knows a way in which to get around this please leave a comment ![Smile](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi4lmhX8SUlEpI1tAQ2OxCrWgW49s8SB1Ei2dBcM8lDPk5ssPToBiq0gFo2xoqb0F5DPUpHLHpfOyuW10ncER5vTq9cvW46hWrph6ODQSAYto66g1YbO6DL-NrZgV-q8d2cHPxiS5CqNug/?imgmax=800)
