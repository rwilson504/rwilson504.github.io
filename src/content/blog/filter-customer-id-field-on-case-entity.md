---
title: "Filter Customer Id field on Case Entity To Only Show Contacts or Accounts"
description: "Recently while working on a project where the customer was utilizing the Case entity they wanted to only allow users to enter contacts into the Customer Id field."
pubDate: 2019-03-07
category: power-apps
tags:
  - "crm"
  - "javascript"
draft: false
originalBloggerUrl: /2019/03/filter-customer-id-field-on-case-entity.html
---

Recently while working on a project where the customer was utilizing the Case entity they wanted to only allow users to enter contacts into the Customer Id field. In order to achieve this you first need ensure that the pre-search only shows contacts.  Next we need to ensure that if the user clicks the "Look up more records" link they only see the option for Contacts in the Look For drop down.  
  
**Note**: In order to change this to only show Accounts just change all the references to "contact" or "contactid" to "account" and "accountid" respectively.
  
  

```
//attach our filtering code to the customerid field
Xrm.Page.getControl("customerid").addPreSearch(filterCustomerField);

function filterCustomerField() {
  //This filter ensures that no accounts will be returned since the accountid field is never null
  var customerContactFilter = "";

  Xrm.Page.getControl("customerid").addCustomFilter(customerContactFilter, "account");\

  //This ensures that in the Look For entity drop down on the lookup you cannot select the Account entity.
  //It also make sure the default view for the lookup is set to the Contacts Lookup View 
  Xrm.Page.getControl("customerid").getAttribute().setLookupTypes(["contact"]);
}
```
