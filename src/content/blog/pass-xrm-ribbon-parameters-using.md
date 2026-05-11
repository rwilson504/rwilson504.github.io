---
title: "Pass XRM Ribbon Parameters Using JavaScript Array"
description: "Trying to pass the list of selected items from a grid using query parameters has limitations due to restrictions on the size of a URL.…"
pubDate: 2014-03-05
heroImage: "/heroes/pass-xrm-ribbon-parameters-using.png"
heroImageAlt: "image"
category: power-apps
tags:
  - "crm-2011"
draft: false
originalBloggerUrl: /2014/03/pass-xrm-ribbon-parameters-using.html
---

Trying to pass the list of selected items from a grid using query parameters has limitations due to restrictions on the size of a URL.  Instead use JavaScript to pass Ribbon parameters to a variable on the XRM page and grab the data in the popup window.

Ribbon Command Setup  
Here we pass the SelectedControlSelectedItemIds which will pass an object array of all the record ids that are selected on the home grid.

**Ribbon JavaScript Web Resource**The web resource will data the ids and post them to a new variable in the main XRM window then opens a popup window.

[![image](/images/pass-xrm-ribbon-parameters-using/01-img.png "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiDFQbFZAsk4DDqd7ck_lVVOaU0yQ6VZHN-jkiVqMsQq-XB5GBpRyK1WC0PtRenNbK7XTPW3a7r9f6z4f_X9SHTPHJygzlOxB4jIZRKMvRoAXJ7Haff571UJBeT135wVduldoblHFE9yz8/s1600-h/image%25255B7%25255D.png)

**AddApplicantsToCourse.htm**  
This popup page will get the ids from the page that opened it.  In order to do so we need to do the following:  
  
-Include jQuery  
-declare the array to hold the id values  
-copy the values from the object in the parent page to the array you created

[![image](/images/pass-xrm-ribbon-parameters-using/02-img.png "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjiq2Y7PJrlaRm_GNam3-Qcp9IrHO2wWy4I0IPWp8F8WI90O5GtlLddLYqGg1HRLZaj5TnW5Slyi2_KCeMvWdZC6VUJ0seM3RzyxueUl6pzB2koGZpQ3m8Sp1obRP4qdmZwI0Pl3Ub7klY/s1600-h/image%25255B19%25255D.png)
