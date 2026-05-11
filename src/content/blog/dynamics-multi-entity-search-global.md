---
title: "Dynamics Multi Entity Search (Global Search) Entity Selection Using C#"
description: "While coming up with deployment scripts i was tasked to ensure that the Dynamics Global Search had specific entities selected.…"
pubDate: 2019-03-19
category: power-apps
tags: []
draft: false
originalBloggerUrl: /2019/03/dynamics-multi-entity-search-global.html
---

While coming up with deployment scripts i was tasked to ensure that the Dynamics Global Search had specific entities selected.  By utilizing one the undocumented SDK message i was able to set this data. ([list of undocumented messages](https://community.dynamics.com/crm/b/bettercrm/archive/2017/08/02/list-of-undocumented-sdk-messages))  
  
The manual way of updating these settings  
1. Navigate to Settings -> Administration -> System Settings  
2. Click on the button for Select entities for categories search  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiZfFbf3dC1DfjlBKsbYicNJLXG1yMJ_f3JbFDtbZ094Bs-KSqaH_caaSLKMqG3wHGBBUv7inJsfVaKl4NmoIgGMl_9_7tyQeRdpq9_4aGHqNuKpPO06492jAa6QNCTrKQU_s06q-0nUi8/s320/SettingsButton.PNG)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiZfFbf3dC1DfjlBKsbYicNJLXG1yMJ_f3JbFDtbZ094Bs-KSqaH_caaSLKMqG3wHGBBUv7inJsfVaKl4NmoIgGMl_9_7tyQeRdpq9_4aGHqNuKpPO06492jAa6QNCTrKQU_s06q-0nUi8/s1600/SettingsButton.PNG)

3. Add/Remove the entities you want utilizing the selection screen.  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgdWCd0Eq2adGdZrubf_n_EyCQ0TRVNk90Ul23FrV8dQBqRGt2sk2vJKycNs0cP7AJVOPPqlRMjWkP7nRDtcDBo8IAJQMkBC5yAg53llgEqzCVGQS9KATrHJ94hYUh_xAgmh3h1ydRGP5M/s320/EntitySelection.PNG)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgdWCd0Eq2adGdZrubf_n_EyCQ0TRVNk90Ul23FrV8dQBqRGt2sk2vJKycNs0cP7AJVOPPqlRMjWkP7nRDtcDBo8IAJQMkBC5yAg53llgEqzCVGQS9KATrHJ94hYUh_xAgmh3h1ydRGP5M/s1600/EntitySelection.PNG)

  
How to do it utilizing code:  
  
  

```
var request = new OrganizationRequest("SaveEntityGroupConfiguration");

//create a new QuickFindCofigurationCollection
var qfCollection = new QuickFindConfigurationCollection();

//add the entities you want to include in Global Search
qfCollection.Add(new QuickFindConfiguration("contact"));
qfCollection.Add(new QuickFindConfiguration("incident"));

//set the parameters for the request.  It took several hours and digging through the
//CRM Sdk dlls to find the EntityGroupName for this.
request.Parameters["EntityGroupName"] = "Mobile Client Search";
request.Parameters["EntityGroupConfiguration"] = qfCollection;

var response = _serviceProxy.Execute(request);
```
