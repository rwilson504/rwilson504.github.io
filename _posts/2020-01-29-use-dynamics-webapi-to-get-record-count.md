---
layout: post
title: Use Dynamics WebAPI to get Record Count
date: '2020-01-29T12:18:00.002-05:00'
author: Rick Wilson
tags:
- webapi
- Dynamics
modified_time: '2020-01-29T12:18:56.536-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1827183675893110112
blogger_orig_url: https://www.richardawilson.com/2020/01/use-dynamics-webapi-to-get-record-count.html
---

When working in an environment where tools like XrmToolbox are not available or allowed getting a total record count can be a real pain sometimes.  One way of doing it just using the browser involves using the Dynamics WebAPI.  This came in handy last time we were doing a data load on our production system and wanted to see the status of how many records had been imported.

## Small Data Set ( < 5k)

If you are trying to get the count for 5,000 or less records. you can do a simple count on the data.

### Format

```/api/data/v9.0/<Entity Set Name>/?$count=true```

### Example

```/api/data/v9.0/contacts/?$count=true```

### Data Returned

```{"@odata.context":"https://org.crm.dynamics.com/api/data/v9.0/$metadata#contacts",```**```"@odata.count":3```**```,"value":```

## Large Data Set ( > 5k & < 50k)

If your record set will have 5k or more you can utilize the webapi by creating a FetchXml aggregate query, this does have a limitation of 50k records.

### Query Format

```/api/data/v9.0/<Entity Set Name>?fetchXml=<FetchXml query that has been URI encoded>```

### FetchXml Format

```<fetch version="1.0" mapping="logical" aggregate="true"> <entity name="contact"> <attribute name="contactid" aggregate="count" alias="count" /> </entity> </fetch>```

### Encoding FetchXml

To encode the FetchXml you can open the Console window in your browser and utilize the encodeURI JavaScript function.

```encodeURI('<fetch version="1.0" mapping="logical" aggregate="true"><entity name="contact"><attribute name="contactid" aggregate="count" alias="count" /></entity></fetch>')```

### Example

```/api/data/v9.0/contacts?fetchXml=%3Cfetch%20version=%221.0%22%20mapping=%22logical%22%20aggregate=%22true%22%3E%3Centity%20name=%22contact%22%3E%3Cattribute%20name=%22contactid%22%20aggregate=%22count%22%20alias=%22count%22%20/%3E%3C/entity%3E%3C/fetch%3E```

### Data Returned

```{"@odata.context":"https://org6744e6cd.crm.dynamics.com/api/data/v9.0/$metadata#contacts","value":```**```[{"count":3}]}```**

