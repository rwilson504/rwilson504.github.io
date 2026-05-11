---
title: "CRM 2011 Ribbon XML Tips"
description: "foreach (EntityMetadata em in resp.EntityMetadata) { if (em.IsCustomEntity == true) { entRibReq.EntityName = em.LogicalName; if (em.IsIntersect == true) //check to see if the entity is a M2M…"
pubDate: 2011-04-15
category: power-apps
tags:
  - "crm-2011"
  - "ribbon"
draft: false
originalBloggerUrl: /2011/04/crm-2011-ribbon-xml-tips.html
---

- SharePoint 2010 uses the same ribbon xml schema and there are a lot of resources which are also applicable to CRM 2011. So if a google search using 'CRM 2011 Ribbon' doesn't work try 'SharePoint 2010 Ribbon'.
- In order to determine sequence numbers you first need to determine the sequence of items currently on the form. You can do this using a tool in the SDK which will allow you do download the ribbon definitions for all of the entities. C:\CRM SDK RC\samplecode\cs\client\ribbon\exportribbonxml\
NOTE:If you have Many to Many relationships within your custom entities make sure to update the SDK ExportRibbonXML utility to look enture the IsIntersect property is false or the export will fail.

```
//<snippetExportRibbonXml5>
//Check for custom entities
RetrieveAllEntitiesRequest raer = new RetrieveAllEntitiesRequest()
{EntityFilters = EntityFilters.Entity};
RetrieveAllEntitiesResponse resp = (RetrieveAllEntitiesResponse)_serviceProxy.Execute(raer);

foreach (EntityMetadata em in resp.EntityMetadata)
{
  if (em.IsCustomEntity == true)
  {
  entRibReq.EntityName = em.LogicalName;
    if (em.IsIntersect == true) //check to see if the entity is a M2M relationship table
    {
      Console.WriteLine("M2M Entity, " + entRibReq.EntityName + ", will not be exported.");
    }
    else
    {
      RetrieveEntityRibbonResponse entRibResp = (RetrieveEntityRibbonResponse)_serviceProxy.Execute(entRibReq);
      System.String entityRibbonPath = Path.GetFullPath(@"..\..\..\ExportRibbonXml\ExportedRibbonXml\" + 
        em.LogicalName + "Ribbon.xml");
      File.WriteAllBytes(entityRibbonPath, unzipRibbon(entRibResp.CompressedEntityXml));
      //Write the path where the file has been saved.
      Console.WriteLine(entityRibbonPath);
    }
  }
}
```

- When creating a group only the MaxSize element is required under Scaling unless you want the button to change size based upon the size of the screen.
- Sequences are extremely important, for example in the following section you will see that a MaxSize has come after a Scale element. This will break the ribbon XML so make sure to look back at the exported ribbon XML from the tool in the SDK to make sure you have all the sequence number correct.
- Although MaxSize and Scale elements both go underneath the Scaling element you cannot add more than one element at a time under the Scaling element.
Example:

```
<CustomAction Id="Mscrm.Form.MainTab.Help.Scaling" 

Location="Mscrm.Form.{!EntityLogicalName}.MainTab.Scaling._children" 

Sequence="180"> 

<CommandUIDefinition> 

<Scaling Id="Mscrm.Form.{!EntityLogicalName}.MainTab.Help.Scaling"> 

<MaxSize Id="Mscrm.Form.{!EntityLogicalName}.MainTab.Help.MaxSize" Sequence="200" GroupId="Mscrm.Form.{!EntityLogicalName}.MainTab.Help" Size="Large" /> 
<Scale Id="Mscrm.Form.{!EntityLogicalName}.MainTab.Help.Scale.Medium" Sequence="300" GroupId="Mscrm.Form.{!EntityLogicalName}.MainTab.Help" Size="Medium" /> 
<Scale Id="Mscrm.Form.{!EntityLogicalName}.MainTab.Help.Scale.Small" Sequence="310" GroupId="Mscrm.Form.{!EntityLogicalName}.MainTab.Help" Size="Small" /> 
<Scale Id="Mscrm.Form.{!EntityLogicalName}.MainTab.Help.Scale.Popup" Sequence="320" GroupId="Mscrm.Form.{!EntityLogicalName}.MainTab.Help" Size="Popup" /> 

</Scaling> 

</CommandUIDefinition> 

</CustomAction>
```

If you try to import this customization you will get an error in the trace log such as "Crm Exception: Message: The import file is invalid. XSD validation failed with the following error: 'The element 'CommandUIDefinition' has invalid child element 'Scale'.'."
Instead what you need to do is break this out into 4 separate Custom Actions

```
<CustomAction Id="Mscrm.Form.MainTab.Help.MaxSize" Location="Mscrm.Form.{!EntityLogicalName}.MainTab.Scaling._children" Sequence="500"> 

<CommandUIDefinition> 

<MaxSize Id="Mscrm.Form.{!EntityLogicalName}.MainTab.Help.MaxSize" Sequence="71" GroupId="Mscrm.Form.{!EntityLogicalName}.MainTab.Help" Size="Large" /> 

</CommandUIDefinition> 

</CustomAction> 

<CustomAction Id="Mscrm.Form.MainTab.Help.Scaling.Medium" Location="Mscrm.Form.{!EntityLogicalName}.MainTab.Scaling._children" Sequence="501"> 

<CommandUIDefinition> 

<MaxSize Id="Mscrm.Form.{!EntityLogicalName}.MainTab.Help.Medium" Sequence="72" GroupId="Mscrm.Form.{!EntityLogicalName}.MainTab.Help" Size="Medium" /> 

</CommandUIDefinition> 

</CustomAction> 

<CustomAction Id="Mscrm.Form.MainTab.Help.Scaling.Small" Location="Mscrm.Form.{!EntityLogicalName}.MainTab.Scaling._children" Sequence="502"> 

<CommandUIDefinition> 

<MaxSize Id="Mscrm.Form.{!EntityLogicalName}.MainTab.Help.Small" Sequence="73" GroupId="Mscrm.Form.{!EntityLogicalName}.MainTab.Help" Size="Small" /> 

</CommandUIDefinition> 

</CustomAction> 

<CustomAction Id="Mscrm.Form.MainTab.Help.Scaling.Popup" Location="Mscrm.Form.{!EntityLogicalName}.MainTab.Scaling._children" Sequence="503"> 

<CommandUIDefinition> 

<MaxSize Id="Mscrm.Form.{!EntityLogicalName}.MainTab.Help.Popup" Sequence="74" GroupId="Mscrm.Form.{!EntityLogicalName}.MainTab.Help" Size="Popup" /> 

</CommandUIDefinition> 

</CustomAction>
```

- RuleDefinitions must have the following elements/attributes. Even if there are no rules defined or you are not even adding a Tab they all must be there.
