---
layout: post
title: Plugin Set to Use Offline but Entity Offline Settings Not Configured
date: '2011-06-28T12:01:00.001-04:00'
author: Rick Wilson
tags:
- CRM 2011
- Plugin Development
modified_time: '2011-06-28T13:12:35.660-04:00'
thumbnail: http://lh6.ggpht.com/-B5OfwAC6HFQ/Tgn6734Fb6I/AAAAAAAAGWo/wnh0FHVDA6k/s72-c/image_thumb4.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6189898835950192551
blogger_orig_url: https://www.richardawilson.com/2011/06/plugin-set-to-use-offline-but-entity.html
---


While attempting to deploy a solution to CRM 2011 I received the following error during the import.

[![image](http://lh6.ggpht.com/-B5OfwAC6HFQ/Tgn6734Fb6I/AAAAAAAAGWo/wnh0FHVDA6k/image_thumb4.png?imgmax=800)](http://lh3.ggpht.com/-Sas7uOR-IrY/Tgn67q6L4kI/AAAAAAAAGWk/Vj5MM1vYyQ8/s1600-h/image8.png)

0x80040203 - Supported deployment does not agree with message availability

After reviewing the code for the plugin I realized that it was attempting to register the plugin for both Server and Offline.

[System.ComponentModel.AmbientValue("CrmPluginStepDeployment=2")]

The problem there was that the Entity was not set for Offline mode.

[![offlinesettings](http://lh6.ggpht.com/-UC2xoy5vKWk/Tgn68p9e4lI/AAAAAAAAGWw/FUg-tLJq4Og/offlinesettings_thumb%25255B1%25255D.png?imgmax=800)](http://lh6.ggpht.com/-Eulxsh_M-0I/Tgn68K8c7wI/AAAAAAAAGWs/bCk1Ey6WYHI/s1600-h/offlinesettings%25255B4%25255D.png)

One the entity was updated the solution installed correctly.

