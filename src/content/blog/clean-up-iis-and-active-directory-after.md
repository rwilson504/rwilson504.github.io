---
title: "Clean Up IIS and Active Directory After ADFS 2.0 Uninstall"
description: "The following is taken from the following KB article: <http://support.microsoft.com/kb/982813>. I have had to do this so many times though I found it easier to post it here :)"
pubDate: 2010-10-24
category: power-apps
tags:
  - "active-directory"
  - "adfs-2"
  - "iis"
  - "powershell"
draft: false
originalBloggerUrl: /2010/10/clean-up-iis-and-active-directory-after.html
---

The following is taken from the following KB article: <http://support.microsoft.com/kb/982813>.  I have had to do this so many times though I found it easier to post it here :)  
  
The Active Directory Federation Services 2.0(AD FS 2.0) uninstallation wizard uninstalls AD FS 2.0 from your computer. However, you may still have to manually restore or cleanup settings in either of the following situations:  
  
  

- When you uninstall AD FS 2.0 from a federation server or federation server proxy computer, the uninstall wizard does not restore IIS to its original state.
- When you uninstall AD FS 2.0 from the last added federation server in a federation server farm, the uninstall process does not delete the certificate sharing container that was created in Active Directory.

**Restore IIS on a federation server or federation server proxy computer**  
  
When AD FS 2.0 is installed on a computer that is configured for the federation server or federation server proxy role, it will create the /adfs and /adfs/ls virtual directories in IIS. AD FS 2.0 will also create a new application pool named **ADFSAppPool**. When you uninstall AD FS 2.0 from a federation server or federation server proxy computer, these virtual directories are not removed. Additionally, the application pool is not removed. This can create problems if AD FS 2.0 is installed again on the same computer.  
  
To manually remove these directories from the decommissioned federation server or federation server proxy computer, follow these steps:  
  

1. Click Start, select Administrative Tools, and then select IIS Manager.
2. Expand the server name node, expand Sites, and then select Default Web Site.
3. In the Actions pane, select View Applications.   
     
   Note: You should see the following two virtual directories associated with AD FS 2.0:  
   /adfs   
   /adfs/ls
4. Right-click the AD FS 2.0 application that is in each virtual directory, and then click Remove.
5. In the Actions pane, select Application Pools.  
     
   Note: You should see an application pool named ADFSAppPool.
6. Right-click ADFSAppPool, and then select Remove.  
     
   Note: The next two steps show how to remove the \adfs directory from the "inetpub" directory. If you have made custom changes to the content within this directory, we recommend that you back up this content to another location before removing the directory.
7. In Windows Explorer, browse to the "inetpub" directory. This directory is usually located in the following path:  
   %systemdrive%\inetpub
8. Right-click the Adfs directory, and then click Delete

**Delete the certificate sharing container in Active Directory**  
  
When you install AD FS 2.0 and use the Federation Server Configuration Wizard to create a new Federation Server in a new Federation Server farm, the wizard will create a certificate sharing container in Active Directory. This container is used by all the federation servers in the farm. When you uninstall AD FS 2.0 from the last added federation server in a farm, this container is not deleted from Active Directory.  
  
To manually delete this container in Active Directory, follow these steps:  
  

1. Before you remove AD FS 2.0 from the last federation server in the farm, run the following PowerShell commands on the AD FS 2.0 STS to determine the location of the certificate sharing container in Active Directory:

- Add-PsSnapin Microsoft.Adfs.Powershell
- Get-AdfsProperties

2. Note: the CertificateSharingContainer property in the output from the previous step.
3. Log on to a server where the ADSIEdit tool (ADSIEdit.msc) is installed.
4. Click Start, click Run, type ADSIEdit.msc, and then press ENTER.
5. In the ADSIEdit tool, connect to the Default naming context by following these steps:

1. Right-click ADSI Edit, and then click Connect to.
2. Under Connection Point, click Select a well-known Naming Context, and then select Default naming context.
3. Click OK.

6. Expand the following node:  
   **Default naming context, {your domain partition}, CN=Program Data, CN=Microsoft, CN=ADFS**  
   Note: Under CN=ADFS, you see a container named CN={GUID} for each AD FS 2.0 farm that you have deployed, where {GUID} matches the CertificateSharingContainer property that you captured by using the Get-AdfsProperties PowerShell command in step 1.
7. Right-click the appropriate {GUID} container, and then select Delete.
