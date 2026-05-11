---
title: "Finding Parental and Cascading Relationships In CRM using SQL"
description: "This script will find custom Parental or Cascading Relationship between entities in CRM.…"
pubDate: 2017-07-13
updatedDate: 2018-03-15
category: power-apps
tags:
  - "crm"
  - "sql"
draft: false
originalBloggerUrl: /2017/07/finding-parental-and-cascading.html
---

This script will find custom Parental or Cascading Relationship between entities in CRM.  This script was used to determine if someone had changed a relationship on a target system and if that change was causing an import to fail.  
  

```
SELECT REL.[Name]
   ,[CascadeLinkMask]
      ,Referencing_Entity.LogicalName
      ,Referencing_Attribute.LogicalName
      ,Referenced_Entity.LogicalName
      ,Referenced_Attribute.LogicalName
      ,[RelationshipType]
      ,[CascadeDelete]
      ,[CascadeAssign]
      ,[CascadeShare]
      ,[CascadeUnShare]
      ,[CascadeMerge]
      ,[CascadeReparent]
      ,[IsCustomRelationship]
  FROM [DefenseReady_MSCRM].[MetadataSchema].[Relationship] REL
  left join DefenseReady_MSCRM.MetadataSchema.Entity Referencing_Entity on REL.ReferencingEntityId = Referencing_Entity.EntityId
  left join DefenseReady_MSCRM.MetadataSchema.Entity Referenced_Entity on REL.ReferencedEntityId = Referenced_Entity.EntityId
   left join DefenseReady_MSCRM.MetadataSchema.Attribute Referencing_Attribute on REL.ReferencingAttributeId = Referencing_Attribute.AttributeId
  left join DefenseReady_MSCRM.MetadataSchema.Attribute Referenced_Attribute on REL.ReferencedAttributeId = Referenced_Attribute.AttributeId
  where IsCustomRelationship = 1
  AND CascadeLinkMask NOT IN (2,3,1099511627779,1099511627778,1)
  ORDER BY Referencing_Entity.LogicalName
  --RefRestrictDelete 1099511627779, 3
  --Referencial 1099511627778, 1,2
  --Parental 4311810305,1103823438081
  --Many To Many 1
  --Configure Cascading 4311810306, 4311810307
```
