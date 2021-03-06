---
layout: post
title: Dynamics Multi Entity Search (Global Search) Entity Selection Using C#
date: '2019-03-19T12:47:00.002-04:00'
author: Rick Wilson
tags: 
modified_time: '2019-03-19T12:47:52.533-04:00'
thumbnail: https://2.bp.blogspot.com/-Y3zHfvtVCac/XJEcNdJu38I/AAAAAAABEEA/VUZS-Wv4csY0fRIlrpdsPqBa3KbX5tfHQCLcBGAs/s72-c/SettingsButton.PNG
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4810961908430880788
blogger_orig_url: https://www.richardawilson.com/2019/03/dynamics-multi-entity-search-global.html
---

While coming up with deployment scripts i was tasked to ensure that the Dynamics Global Search had specific entities selected.  By utilizing one the undocumented SDK message i was able to set this data. ([list of undocumented messages](https://community.dynamics.com/crm/b/bettercrm/archive/2017/08/02/list-of-undocumented-sdk-messages))

The manual way of updating these settings
1. Navigate to Settings -> Administration -> System Settings
2. Click on the button for Select entities for categories search

[![](https://2.bp.blogspot.com/-Y3zHfvtVCac/XJEcNdJu38I/AAAAAAABEEA/VUZS-Wv4csY0fRIlrpdsPqBa3KbX5tfHQCLcBGAs/s320/SettingsButton.PNG)](https://2.bp.blogspot.com/-Y3zHfvtVCac/XJEcNdJu38I/AAAAAAABEEA/VUZS-Wv4csY0fRIlrpdsPqBa3KbX5tfHQCLcBGAs/s1600/SettingsButton.PNG)
3. Add/Remove the entities you want utilizing the selection screen.

[![](https://1.bp.blogspot.com/-ymSGP66UIhE/XJEcXuVjenI/AAAAAAABEEI/Jn8EPFPrLrcbb4UeDSqIoUL3XBwGNxFmwCLcBGAs/s320/EntitySelection.PNG)](https://1.bp.blogspot.com/-ymSGP66UIhE/XJEcXuVjenI/AAAAAAABEEI/Jn8EPFPrLrcbb4UeDSqIoUL3XBwGNxFmwCLcBGAs/s1600/EntitySelection.PNG)

How to do it utilizing code:

    
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
    

