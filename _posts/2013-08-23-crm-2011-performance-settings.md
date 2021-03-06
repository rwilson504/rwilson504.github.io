---
layout: post
title: CRM 2011 Performance Settings
date: '2013-08-23T08:51:00.001-04:00'
author: Rick Wilson
tags:
- SQL
- CRM 2011
- performance
- registry
- IIS
modified_time: '2016-10-27T15:18:47.669-04:00'
thumbnail: http://lh5.ggpht.com/-kzd_tA7fTL4/VKGA0gg916I/AAAAAAAAMr8/DNMflAiKPCs/s72-c/image_thumb%25255B2%25255D.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6398459909746927767
blogger_orig_url: https://www.richardawilson.com/2013/08/crm-2011-performance-settings.html
---


#### REGISTRY
**Disable Loopback check**
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
           New DWORD Value: DisableLoopbackCheck = 1 (Decimal)
**CRM Settings**
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSCRM
          New DWORD Value: OLEDBTimeout = 86400 (Decimal)
          New DWORD Value: ExtendedTimeout = 1000000 (Decimal)
          New DWORD Value: NormalTimeout = 300000 (Decimal)
          New DWORD Value: AsyncRemoveCompletedWorkflows = 1 (Decimal)
          New DWORD Value: AsyncRemoveCompletedJobs = 1 (Decimal)
**TCP/IP Settings**
HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip\Parameters
          New DWORD Value: MaxUserPort = 65534 (Decimal)
          New DWORD Value: TcpTimedWaitDelay = 260 (Decimal)

#### SQL
**Max Degree of Parallelism and Other SQL Settings**

    exec sp_configure 'show adv', 1;
    RECONFIGURE WITH OVERRIDE;
    --reduces locking by ensureing queries are only run against a single processor
    exec sp_configure 'max degree', 1;
    RECONFIGURE WITH OVERRIDE;
    --reduces ASYNC_NETWORK_IO locks that occur 
    --when large queries hog all the memory on a machine
    --and the machine can no longer access the IO.
    --The value of this setting should be modified based 
    --upon the amount of ram on your machine.
    exec sp_configure 'max server memory', 8192;
    RECONFIGURE WITH OVERRIDE;
    --Enable SQL CLR which can increase timezone conversion
    --on advanced find
    exec sp_configure 'clr enabled', '1';
    RECONFIGURE WITH OVERRIDE;
    exec sp_configure;

**Read Snapshot Isolation**

How to check to see if it’s already turned on:

    SELECT name, is_read_committed_snapshot_on FROM sys.databases

How to turn it on for a specific database:

    DECLARE @DBNAME VARCHAR(100);
    SET @DBNAME = 'Default_MSCRM'; --Update this based upon your database name
    
    DECLARE @query varchar(max);
    SET @query = 'ALTER DATABASE {DATABASE} SET SINGLE_USER WITH ROLLBACK IMMEDIATE;' +
    'ALTER DATABASE {DATABASE} SET ALLOW_SNAPSHOT_ISOLATION ON;' +
    'ALTER DATABASE {DATABASE} SET READ_COMMITTED_SNAPSHOT ON;' +
    'ALTER DATABASE {DATABASE} SET MULTI_USER;'
    SET @query = REPLACE(@query, '{DATABASE}', @DBNAME);
    exec(@query);

**SqlCommandTimeout**

    USE MSCRM_CONFIG
    UPDATE DeploymentProperties
    SET IntColumn = 9000
    WHERE ColumnName = 'SqlCommandTimeout'
    

### IIS

**WCF/SOAP Compression**

Open a command promp 'As Administrator' and run the following command:

    %SYSTEMROOT%\system32\inetsrv\appcmd.exe set config -section:system.webServer/httpCompression /+"dynamicTypes.[mimeType='application/soap%u002bxml; charset=utf-8',enabled='true']" /commit:apphost

**JSON Compression**

Open a command promp 'As Administrator' and run the following command:

    %SYSTEMROOT%\system32\inetsrv\appcmd.exe set config -section:system.webServer/httpCompression /+"dynamicTypes.[mimeType='application/json; charset=utf-8',enabled='true']" /commit:apphost

[http://blogs.msdn.com/b/crminthefield/archive/2011/12/29/enable-wcf-compression-to-improve-crm-2011-network-performance.aspx](http://blogs.msdn.com/b/crminthefield/archive/2011/12/29/enable-wcf-compression-to-improve-crm-2011-network-performance.aspx)

**Static Content Caching**

This will help ensure that some static content files used by CRM will also be cached.  It ensures that the Response Header is not set to * but instead to Accept-Encoding.

- Open IIS Manager 
- Click on Microsoft Dynamics CRM Website 
- Click on Configuration Editor 
- Navigate to system.web/caching/outputCache 
- Switch omitVaryStart to True and click the Apply button.

[![image](http://lh5.ggpht.com/-kzd_tA7fTL4/VKGA0gg916I/AAAAAAAAMr8/DNMflAiKPCs/image_thumb%25255B2%25255D.png?imgmax=800)](http://lh3.ggpht.com/-a7JioS-s56A/VKGAz_i6aiI/AAAAAAAAMr0/zzeixtbgnjA/s1600-h/image%25255B4%25255D.png)

[http://blogs.msdn.com/b/crminthefield/archive/2014/12/19/static-content-not-cached-properly-in-dynamics-crm-due-to-vary-header.aspx](http://blogs.msdn.com/b/crminthefield/archive/2014/12/19/static-content-not-cached-properly-in-dynamics-crm-due-to-vary-header.aspx)

**Kerberos and Windows Auth**

Update setting to reduce 401 responses when using Kerberos and Windows Auth at the same time. This will not hurt anything if they are only using windows auth. 

- Run a command prompt As Administrator
- At the command prompt, type the following commands, and then press ENTER:

    cd %SystemRoot%\System32\inetsrv
    appcmd set config /section:windowsAuthentication /authPersistNonNTLM:true

[http://support.microsoft.com/kb/954873](http://support.microsoft.com/kb/954873)

.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/*white-space: pre;*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }

