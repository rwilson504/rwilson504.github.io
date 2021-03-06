---
layout: post
title: Create Status Reason Values Using C#
date: '2015-07-14T09:52:00.001-04:00'
author: Rick Wilson
tags: 
modified_time: '2015-07-14T09:54:53.265-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-8307274530845348489
blogger_orig_url: https://www.richardawilson.com/2015/07/create-status-reason-values-using-c.html
---


The CRM interface no longer allows you to enter the Value for a Status Reason.  I had to update several entities to all have the same values but some of them were created way back in CRM 4.0 when you could select the value manually.  To get around this I created the values using C# and LINQPad.

 

    
    void Main()
    {
        string connectionString = "Url=[https://test.anycom.us/defenseready/XRMServices/2011/Organization.svc;";](https://test.anycom.us/defenseready/XRMServices/2011/Organization.svc;&quot;;)
        var orgService = CreateOrgService(connectionString);
        if (orgService != null)
        {    
            var entName = "test_myentity";
            InsertStatusValueRequest req = new InsertStatusValueRequest();
            req.EntityLogicalName = entName;
            req.AttributeLogicalName = "statuscode";
            req.Value = 3; //set the value here
            req.StateCode = 0;  //set the statecode here if you don’t it will default to 0 (active).
            //1033 below represents localeId for the United States and English
            req.Label = new Label("Pending", 1033);
            InsertStatusValueResponse resp = (InsertStatusValueResponse)orgService.Execute(req);
        }        
    }private IOrganizationService CreateOrgService(string connectionString)
        {
            CrmConnection connection = CrmConnection.Parse(connectionString);
            
            return new OrganizationServiceProxy(
            connection.ServiceUri,
            connection.HomeRealmUri,
            connection.ClientCredentials,
            connection.DeviceCredentials);
        }

