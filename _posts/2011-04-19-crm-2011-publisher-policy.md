---
layout: post
title: CRM 2011 Publisher Policy / Redirection
date: '2011-04-19T13:26:00.001-04:00'
author: Rick Wilson
tags:
- CRM 2011
- Development
- Web.Config
- IIS
modified_time: '2011-04-19T13:27:00.986-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3022191353072168976
blogger_orig_url: https://www.richardawilson.com/2011/04/crm-2011-publisher-policy.html
---

While working on a CRM 2011 application I kept getting the following error even though I was not even using the CRM 4.0 SDK file.

    ```Exception information: 
        Exception type: FileLoadException 
        Exception message: Could not load file or assembly 'Microsoft.Crm.Sdk, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35' or one of its dependencies. The located assembly's manifest definition does not match the assembly reference. (Exception from HRESULT: 0x80131040)
    ```

To get around the problem I put the following redirection binding to the CRM 2011 SDK in the web.config.  This runtime info can go anywhere directly underneath the configuration node.

    ```<configuration>
      <runtime>
         <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
           <dependentAssembly>
             <assemblyIdentity name="Microsoft.Crm.Sdk"
                               culture="neutral"
                               publicKeyToken="31bf3856ad364e35" />
             <bindingRedirect oldVersion="4.0.0.0"
                              newVersion="5.0.0.0" />
           </dependentAssembly>
         </assemblyBinding>
       </runtime>
    </configuration>
    ```

