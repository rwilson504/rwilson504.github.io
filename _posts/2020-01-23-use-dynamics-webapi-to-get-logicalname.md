---
layout: post
title: Use Dynamics WebAPI to get LogicalName or ObjectTypeCode for Entity
date: '2020-01-23T16:43:00.002-05:00'
author: Rick Wilson
tags:
- metadata
- webapi
- Dynamics
modified_time: '2020-01-23T16:43:34.558-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4746431957335408572
blogger_orig_url: https://www.richardawilson.com/2020/01/use-dynamics-webapi-to-get-logicalname.html
---

If you need to get the LogicalName or ObjectTypeCode of an entity in your Dynamics environment you can utilize the WebAPI to get the metadata.

If you have the *LogicalName* of the entity you can use this url.
Format:
```<Dynamics Url>/api/data/v<Version>/EntityDefinitions(LogicalName='<LogicalName>')?$select=ObjectTypeCode```

Example:
```https://org12345.crm.dynamics.com/api/data/v9.0/EntityDefinitions(LogicalName='account')?$select=ObjectTypeCode```

Data Returned:
```{"@odata.context":"https://org6744e6cd.crm.dynamics.com/api/data/v9.0/$metadata#EntityDefinitions(ObjectTypeCode)/$entity","ObjectTypeCode":1,"MetadataId":"70816501-edb9-4740-a16c-6a5efbc05d84"}```

If you have the *ObjectTypeCode* of the entity you can use this url.

Format:
```<Dynamics Url>/api/data/v<Version>/EntityDefinitions?$filter=ObjectTypeCode eq <ObjectTypeCode>&$select=LogicalName```

Example:
```https://org12345.crm.dynamics.com/api/data/v9.0/EntityDefinitions?$filter=ObjectTypeCode eq 1&$select=LogicalName```

Data Returned:
```{"@odata.context":"https://org6744e6cd.crm.dynamics.com/api/data/v9.0/$metadata#EntityDefinitions(LogicalName)","value":[{"LogicalName":"account","MetadataId":"70816501-edb9-4740-a16c-6a5efbc05d84"}]}```

