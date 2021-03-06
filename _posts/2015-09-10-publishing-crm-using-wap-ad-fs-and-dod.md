---
layout: post
title: Publishing CRM Using WAP, AD FS and DoD PKI
date: '2015-09-10T13:58:00.001-04:00'
author: Rick Wilson
tags:
- PKI
- ADFS 3.0
- WAP
- CRM
- Authentication
modified_time: '2015-09-10T16:14:46.719-04:00'
thumbnail: http://lh3.googleusercontent.com/-5KbkB_SpD6w/VfHZkoH7SjI/AAAAAAAARIg/-nI3CazQKU4/s72-c/2015-09-10%25252013_57_58-WAP%25252BADFS%25252BKCD%25252BCRM%252520%2525281%252529.vsdx%252520-%252520Visio%252520Professional_thumb.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-2923265723451435893
blogger_orig_url: https://www.richardawilson.com/2015/09/publishing-crm-using-wap-ad-fs-and-dod.html
---

With TMG going the way of the dodo Microsoft has moved much of it's functionality into Server 2012R2.  This includes publishing applications utilizing Windows Authentication and Kerberos Constrained Delegation (KCD).  This is done through a combination of a feature called Web Application Proxy and ADFS 3.0.

# Requirements

- Windows Server 2012R2  
- The Web Application Proxy server should be joined to the domain in order to pass KCD tickets.  The WAP server actually can be in another domain but it would require additional setup not covered in this article.  
- The External DNS of CRM should point to the WAP server.  
- WAP server will need two virtual or physical network cards.  One for external communications and one for internal.  
- The Federation Service URL cannot match the machine name of the AD FS server. 

# Example Configuration

This diagram represents the configuration for our sample environment. Additional setup scenarios for load balancing the WAP and CRM server are possible but not covered in this setup guide.  

[![2015-09-10 13_57_58-WAP ADFS KCD CRM (1).vsdx - Visio Professional](http://lh3.googleusercontent.com/-5KbkB_SpD6w/VfHZkoH7SjI/AAAAAAAARIg/-nI3CazQKU4/2015-09-10%25252013_57_58-WAP%25252BADFS%25252BKCD%25252BCRM%252520%2525281%252529.vsdx%252520-%252520Visio%252520Professional_thumb.png?imgmax=800)](http://lh3.googleusercontent.com/-Xlzxmf6VuSo/VfHZj-CRXBI/AAAAAAAARIU/8VpmQsOLENg/s1600-h/2015-09-10%25252013_57_58-WAP%25252BADFS%25252BKCD%25252BCRM%252520%2525281%252529.vsdx%252520-%252520Visio%252520Professional.png)

###  

# Firewall Considerations 

If your domain controller (DC) and your Web Application Proxy will be separated by a firewall you will need to establish Active Directory and Kerberos communication between them. In order to do this you will need the following port rules.  

  

### Ports required for Active Directory communication and Kerberos 
Port/TransportProtocol443/TCPHTTPS389/TCPLDAP to Directory Service389/UDP 3268/TCPLDAP to Global Catalog Server88/TCPKerberos Authentication88/UDP 
  

# DNS Setup

The setting below describe the DNS setup using the sample setup diagram.

### External DNS

All the external DNS records should point to your Web Application Proxy external IP
URLIPUsage[https://wap-crm.raw.com](https://wap-crm.raw.com)52.4.168.181CRM Website[https://wap-fs.raw.com](https://wap-fs.raw.com)52.4.168.181AD FS Proxy Website
###  

### Internal DNS

If your WAP server will have access to internal DNS records and you have the ability to Add forward lookup zones you can utilize that within your domain DNS. Otherwise you will need to utilize the host file on the WAP machine in order to ensure that it knows the internal IP address mappings for the external Urls.  

####  

#### WAP with DNS Access

In this scenario our WAP server has access to our internal DNS system. We will add a forward lookup zone for our external domain name and add the two external URLs as A records pointing to the internal IP address for those machines.

####  

#### WAP with No DNS Access Utilizing host File

In this scenario our WAP machine is located in a DMZ with no access to our internal DNS system. The screenshot below shows the host file update we have made to point the external URLs to the internal IP addresses.  

  

# Configure CRM Server

In order for Kerberos Constrained Delegation to work correctly we must ensure that Kerberos is functioning correctly in CRM.   The following will demonstrate a basic Kerberos setup for a single CRM server. 

 

### CRM Application Pool User

Your CRM environment should be using a domain user to run the Application Pool for CRM.  We will first determine what user is running the application pool.

- Open the IIS Management Console  
- Expand the server node and select Application Pools  
- Make note of the user running the CRMAppPool

### Kernel Mode Authentication and Authentication Providers

If kernel mode authentication is being used additional setting will need to be configured to ensure that the application pool user account is being used when Kerberos tickets are issued.  Additionally make sure that the providers for windows authentication are utilizing Kerberos (Negotiate).

#### Set Kernel Mode Authentication

- Open the IIS Management Console  
- Expand the server node and the Sites node  
- Click on the Microsoft Dynamics CRM website  
- Double click on Authentication in the Feature View area  
- Select Windows Authentication in the Features View area  
- Click Advanced Settings… in the Actions area  
- Ensure that Enable Kernel-mode authentication is checked and click Ok or Cancel if it was already checked

#### Check Authentication Providers

- Open the IIS Management Console  
- Expand the server node and the Sites node  
- Click on the Microsoft Dynamics CRM website  
- Double click on Authentication in the Feature View area  
- Select Windows Authentication in the Features View area and click the Providers… link in the Actions menu.  
- The providers window should have Negotiate listed as the first provider  
- Note: If Negotiate is not listed you can add it from the Available Providers drop down.  Additional if any provider is listed above Negotiate use the Move Up and Move Down buttons to ensure Negotiate is listed as the first provider.

#### Use Application Pool Credentials

Because we are using kernel mode authentication CRM will attempt to get Kerberos tickets utilizing a build in service account.  The service account IIS will user for Kerberos is not delegated to pass the tickets.  In order to fix this issue settings will need to be adjusted on the CRM website to ensure the application pool user we identified earlier who is delegated for Kerberos will attempt to get the tickets.

- Open the IIS Management Console  
- Expand the server node and the Sites node  
- Click on the Microsoft Dynamics CRM website  
- Double click on Configuration Editor in the Feature View area  
- Change the section area to System.webServer/security/authentication/windowsAuthentication  
- Update the authPersisNonNTLM and useAppPoolCredentials to True  
- Click the Apply button in the Actions area

# Configure Domain Controller

### Install DoD Certificates

The instructions illustrated here may differ from internal processes for installing certificates within your organization.

- Download and complete the setup for InstallRoot 4.1
x64 - [http://iasecontent.disa.mil/pki-pke/InstallRoot_4.1x64.msi](http://iasecontent.disa.mil/pki-pke/InstallRoot_4.1x64.msi)
x32 - [http://iasecontent.disa.mil/pki-pke/InstallRoot_4.1x32.msi](http://iasecontent.disa.mil/pki-pke/InstallRoot_4.1x64.msi)
- Run InstallRoot  
- Click the red checkbox next to Install DoD Certificates so that it turns into a green checkmark  
- Choose Install Certificates from the Actions Menu

### Install Certificates into NTAuth Store

In order for Smart Cards (PKI) to work correctly within our domain the certificates at the root of the smart card must be installed at the Active Directory level. The instructions illustrated here may differ from internal processes for installing certificates within your organization.

- Run InstallRoot  
- Make sure you have already installed the DoD Certificates  
- Click on the Store tab  
- Click on the Active Directory NTAuth button in the ribbon 
[![image](http://lh3.googleusercontent.com/-O5p3zGX7BA8/VfHjJfid8rI/AAAAAAAARI0/E5K1ZKYAhMo/image_thumb%25255B4%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-ETmPySgqTBM/VfHjI7aeDeI/AAAAAAAARIs/AQI-qFK7pNk/s1600-h/image%25255B8%25255D.png)
- Click ok when prompted  
- Go back to the Home tab and select Install Certificates 
[![image](http://lh3.googleusercontent.com/-snF76d9Nu-A/VfHjKz8hcAI/AAAAAAAARJE/gNAVLqf6TrY/image_thumb%25255B3%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-ArCgrGAI984/VfHjKAyHz9I/AAAAAAAARI8/wQwyQuyju18/s1600-h/image%25255B7%25255D.png)
- InstallRoot will install the necessary certificates into the NTAuth store, click Ok when complete 
[![image](http://lh3.googleusercontent.com/-FVV4HcPJ5qA/VfHjMERrHNI/AAAAAAAARJU/sn0wg-AevoE/image_thumb%25255B6%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-qixsMIUKcwE/VfHjLbANu5I/AAAAAAAARJM/1vMYRNJPe2E/s1600-h/image%25255B12%25255D.png)
- Leave InstallRoot open  
- Open a command prompt  
- Run the command gpupdate /force
Note: This will update the local NTAuth store with that of the one you just updated  
- Go back to InstallRoot and click on the Store tab  
- Click on the NTAuth Comparison report button 
[![image](http://lh3.googleusercontent.com/-wGA77PFw_-A/VfHjNbfKmqI/AAAAAAAARJk/7HEe63Z18MY/image_thumb%25255B11%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-nx_Y-mC7aM0/VfHjM1un_sI/AAAAAAAARJc/29J3FY1AuUc/s1600-h/image%25255B21%25255D.png)
- The Report should show that both Active Directory and the Local store both have the DoD certificates installed, click Ok when you have verified the certificate installation

### Push Certificates Using Group Policy

In order to avoid having to install the DoD certificates on all machines utilize group policy to push the certificates down to all servers within the domain.

 

#### Export Certificates from Local Store

In order to import the certificates into the group policy object we first need to export the certificates from the local store.

 

- Open an MMC console  
- Choose Add/Remove Snap-in… from the File menu  
- Click Certificates and click Add > 
[![image](http://lh3.googleusercontent.com/-iRGXYV3ZNrM/VfHjOsVNRlI/AAAAAAAARJ0/pY7efSG7Wm8/image_thumb%25255B10%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-bU2vjz_as_U/VfHjN6PsdkI/AAAAAAAARJs/Zj9WZj6jOmk/s1600-h/image%25255B20%25255D.png)
- Choose Computer account and click Next 
[![image](http://lh3.googleusercontent.com/-hLlciNYbtm8/VfHjPjwp95I/AAAAAAAARKE/A8UBqv_0d_4/image_thumb%25255B13%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-Ppog1mqZ-bg/VfHjPIWbI0I/AAAAAAAARJ8/pphipWh1d6w/s1600-h/image%25255B25%25255D.png)
- Choose Local Computer and click Finish 
[![image](http://lh3.googleusercontent.com/-nlDVMoneGSQ/VfHjRXJsomI/AAAAAAAARKY/x8vVDaFwEPE/image_thumb%25255B15%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-XeM__LxokBI/VfHjQVPTvwI/AAAAAAAARKM/EB2AfWY_yxQ/s1600-h/image%25255B29%25255D.png)
- Expand the Trusted Root Certification Authorities and select the Certificates folder  
- Select the two DoD Root CA certificates 
[![image](http://lh3.googleusercontent.com/-MPt4qvsfMmI/VfHjTf8x6oI/AAAAAAAARKo/XynDIFbuOXc/image_thumb%25255B17%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-o8NRpvT6v-8/VfHjSyq6ElI/AAAAAAAARKg/NrL90EdgJHg/s1600-h/image%25255B33%25255D.png)
- Right click on the two certificates and choose All Tasks -> Export… 
[![image](http://lh3.googleusercontent.com/-RF8E1TPDWis/VfHjUm7KeeI/AAAAAAAARK0/dGttgFNmSxM/image_thumb%25255B19%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-VOJqXkhcSmA/VfHjT8OqkII/AAAAAAAARKw/qScQ1FjDHUM/s1600-h/image%25255B37%25255D.png)
- Click Next on the first page of the Certificate Export Wizard  
- On the file format window choose Microsoft Serialized Certificate Store (.SST) and click Next 
[![image](http://lh3.googleusercontent.com/--muysBYv9hs/VfHjVia18LI/AAAAAAAARLI/2dniyBenf0Y/image_thumb%25255B21%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-JvF-hgrMAwg/VfHjU-CpuCI/AAAAAAAARK8/kc6vGqVJKi4/s1600-h/image%25255B41%25255D.png)
- Choose a location and File name for the certificate file and click Next 
[![image](http://lh3.googleusercontent.com/-aVQu_LJ1HPk/VfHjXkJ4yyI/AAAAAAAARLU/hFlBqvJu8d0/image_thumb%25255B23%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-px_LuiZ044I/VfHjWU46oKI/AAAAAAAARLQ/Fl8lZO23kAk/s1600-h/image%25255B45%25255D.png)
- Click Finish on the Completing the Certificate Export Wizard  
- Expand the Intermediate Certification Authorities and select the Certificates folder  
- Select all of the DOD certificates 
[![image](http://lh3.googleusercontent.com/-R9TMKy-U3k8/VfHjaEH5KCI/AAAAAAAARLo/f2UhxHVH_jA/image_thumb%25255B26%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-6xgikBcE8us/VfHjY26lFMI/AAAAAAAARLg/-HDeHsLMrTo/s1600-h/image%25255B50%25255D.png)
- Right click on the selected certificates and select All Tasks -> Export… 
[![image](http://lh3.googleusercontent.com/-qze5o6yPABc/VfHjcD3560I/AAAAAAAARL4/W_wEHx5Bx8w/image_thumb%25255B28%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-9nzITrT-MX0/VfHjbCk8P9I/AAAAAAAARLw/rL9rZeaMWww/s1600-h/image%25255B54%25255D.png)
- Click Next on the first page of the Certificate Export Wizard  
- On the file format window choose Microsoft Serialized Certificate Store (.SST) and click Next 
[![image](http://lh3.googleusercontent.com/-U5CUOVNQ-_0/VfHjd5TAuGI/AAAAAAAARMI/m9e9UD3zHuU/image_thumb%25255B30%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-siwtXu6ORLw/VfHjdNHHf0I/AAAAAAAARMA/xxtO1Br_ZuY/s1600-h/image%25255B58%25255D.png)
- Choose a location and File name for the certificate file and click Next 
[![image](http://lh3.googleusercontent.com/-G3vz0HLsb3M/VfHjf-evZFI/AAAAAAAARMY/_2mSQjgxjvo/image_thumb%25255B32%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-ZgI0NMNWmJc/VfHjfAxwSnI/AAAAAAAARMQ/8mdENw4oprM/s1600-h/image%25255B62%25255D.png)
- Click Finish on the Completing the Certificate Export Wizard

#### Import Certificates into Group Policy Object

- Open the Group Policy Management snap-in  
- Expand Domains and expand your domain  
- Expand the Group Policy Objects container  
- Right click on the Default Domain Policy and select Edit…  
- Within the Group Policy Management Editor navigate to Computer Configuration -> Policies -> Window Settings -> Security Settings -> Public Key Policies 
[![image](http://lh3.googleusercontent.com/-TKK_OC5izEQ/VfHjh2leDfI/AAAAAAAARMo/8tVGjwgEgr8/image_thumb%25255B34%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-1Jmr4AXrdQ0/VfHjgqFZDWI/AAAAAAAARMc/fBHRUOJdTSw/s1600-h/image%25255B66%25255D.png)
- Expand Public Key Policies and Select the Trusted Root Certification Authorities  
- Right click on the Trusted Root Certification Authorities folder and select Import… 
[![image](http://lh3.googleusercontent.com/-PlyZQFPb8H0/VfHjjo2mBrI/AAAAAAAARM4/SHJfviJlbVw/image_thumb%25255B36%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-bWMe0kReRJw/VfHji-RUliI/AAAAAAAARMw/aiIt77rPSq8/s1600-h/image%25255B70%25255D.png)
- Click Next on the Welcome to the Certificate Import Wizard  
- Click Browse on the File to Import page  
- On the Open file dialog change the file type lookup to Microsoft Serialized Certificate Store (*.sst) and choose the DoD Root certificate sst you created earlier 
[![image](http://lh3.googleusercontent.com/-DiKJxeY0b7I/VfHjnjc-BHI/AAAAAAAARNI/pKU85Pk52TY/image_thumb%25255B40%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-KpQpKrqdfAM/VfHjkQjC0pI/AAAAAAAARNA/8wWa1r_R7ws/s1600-h/image%25255B78%25255D.png)
- After selecting the file click Next on the File to Import page 
[![image](http://lh3.googleusercontent.com/-EHnkKqMHcrE/VfHjp7bmlEI/AAAAAAAARNY/LU2ziJTXXIg/image_thumb%25255B38%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-1f3MSZ_eabA/VfHjpGZSTaI/AAAAAAAARNQ/gz_PGPMqqJ0/s1600-h/image%25255B74%25255D.png)
- The certificate store will have the Trusted Root Certification Authorities selected by default, click the Next button 
[![image](http://lh3.googleusercontent.com/-8jDQ3-n2FHs/VfHjr_hZfBI/AAAAAAAARNo/J0-3W4Vg4MU/image_thumb%25255B42%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-6pRHMhQszRc/VfHjqwmw8AI/AAAAAAAARNg/wLQXWPuYhfw/s1600-h/image%25255B82%25255D.png)
- Click the Finish button on the Completing the Certificate Import Wizard  
- Under the Public Key Policies click the Intermediate Certification Authorities folder  
- Right click on the Intermediate Certification Authorities folder and select Import… 
[![image](http://lh3.googleusercontent.com/-7_Co6N1x1Mc/VfHjtXAjzSI/AAAAAAAARN0/MZD_ywpmrqU/image_thumb%25255B44%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-Leeaq-PANCA/VfHjsqkWR2I/AAAAAAAARNs/9SZ4VWVmRmc/s1600-h/image%25255B86%25255D.png)
- Click Next on the Welcome to the Certificate Import Wizard  
- Click Browse on the File to Import page  
- On the Open file dialog change the file type lookup to Microsoft Serialized Certificate Store (*.sst) and choose the DoD Root certificate sst you created earlier 
[![image](http://lh3.googleusercontent.com/-nbhBaZArka0/VfHjusxdDWI/AAAAAAAAROI/aggNEm0Tq10/image_thumb%25255B46%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-Wyjz6aO183k/VfHjt6PdNGI/AAAAAAAARN8/P3V7SDtVh20/s1600-h/image%25255B90%25255D.png)
- After selecting the file click Next on the File to Import page 
[![image](http://lh3.googleusercontent.com/-vAXI9rc9h2E/VfHjv0y8fjI/AAAAAAAAROY/D_7uVuYUEws/image_thumb%25255B48%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-1l6dfr78C04/VfHjvdfPckI/AAAAAAAAROQ/_Upq-265gUw/s1600-h/image%25255B94%25255D.png)
- The certificate store will have the Intermediate Certification Authorities selected by default, click the Next button 
[![image](http://lh3.googleusercontent.com/-7MRR599T_Pc/VfHjxLGjzuI/AAAAAAAAROo/UMIz71tv8Cs/image_thumb%25255B50%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-U1KiqevwPDs/VfHjwlm-YqI/AAAAAAAAROc/X0PmuCt2ado/s1600-h/image%25255B98%25255D.png)
- Click the Finish button on the Completing the Certificate Import Wizard  
- In order to make sure all the other machines receive these certificates you should log into all other boxes, open a command prompt, and run the following command; 

gpupdate /force

[![image](http://lh3.googleusercontent.com/-9o7mV37Rv7A/VfHjyviBhJI/AAAAAAAARO4/j4rg8-iRdYc/image_thumb%25255B52%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-396dgNV_jGc/VfHjx-irdJI/AAAAAAAAROw/Y6y24Xx7vOY/s1600-h/image%25255B102%25255D.png)

### Create SPN Records for CRM

In order for Kerberos to work correctly Service Principal Name (SPN) records must be set for CRM.

Log in to any machine on the domain using an account with Domain Administrative rights.

 

- Open a command window  
- Set the SPN for the FDDN of the server name 

setspn –s http/wap-crm.raw.local wilson\svccrm

- The command will check for any existing SPN with the same name and then create the SPN  
- Set the SPN for the NetBIOS name of the server 

setspn –s http/wap-crm wilson\svccrm

- The command will check for any existing SPN with the same name and then create the SPN  
- Set the SPN for the external DNS name of the CRM website 

setspn –s http/wap-crm.raw.com wilson\svccrm

- The command will check for any existing SPN with the same name and then create the SPN

 

### Set Delegation for CRM

In order for the WAP server to obtain a Kerberos ticket we must allow connection from the WAP server to delegate using the CRM SPNs we set earlier.

 

- Open the Active Directory Users and Computers snap-in  
- Click on View in the toolbar and select Advanced Features 
[![image](http://lh3.googleusercontent.com/-5C37KrPalFs/VfHjzzy44eI/AAAAAAAARPI/smnvGGxV9Fc/image_thumb%25255B65%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-CZGCAhD7yHM/VfHjzES_bcI/AAAAAAAARPA/8ZqG3pE_Kzs/s1600-h/image%25255B112%25255D.png)
- Find the entry for the WAP-PROXY computer, right click and choose Properties 
[![image](http://lh3.googleusercontent.com/-QJ5ARvAF5oY/VfHj1M8TY9I/AAAAAAAARPY/fC9nGQeEehg/image_thumb%25255B58%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-PgLo7-89LuA/VfHj0v7SFuI/AAAAAAAARPQ/aG3S5hO9rO0/s1600-h/image%25255B107%25255D.png)
- On the Properties window click the Delegation tab  
- Choose the option for Trust this computer for delegation to specified services only  
- Choose the option for Use Kerberos Only 
[![image](http://lh3.googleusercontent.com/-RFYNnQDdn64/VfHj2rr5XEI/AAAAAAAARPo/Wh9te4n0rTM/image_thumb%25255B67%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-uKUahyCWz1Q/VfHj128ymQI/AAAAAAAARPg/PIM5XVfQRrQ/s1600-h/image%25255B116%25255D.png)
- Click the Add button 
[![image](http://lh3.googleusercontent.com/-EoeYK7vxVRM/VfHj3-KU8bI/AAAAAAAARP4/jC1RZxS2N3M/image_thumb%25255B69%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/--lB5mwvXfcE/VfHj3HL8bQI/AAAAAAAARPw/ZlGZCf4hQPc/s1600-h/image%25255B120%25255D.png)
- Click Users or Computers 
[![image](http://lh3.googleusercontent.com/--PDefa8UquI/VfHj5f1YR8I/AAAAAAAARQI/6YnQjpHflE8/image_thumb%25255B71%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-ZHW875opcwc/VfHj4lCjoPI/AAAAAAAARQA/sYk5CRF_OB4/s1600-h/image%25255B124%25255D.png)
- Enter the service account running the CRM application pool and click OK  
- On the Add Services window click Select All and then OK  
- Click the Expanded checkbox on the Delegation tab and all three of the SPNs added earlier will appear  
- Click OK to exit the properties for the WAP server

### Configure Users for KCD

In order for KCD to translate the client certificate to an Active Directory account we must update the userPrincipalName for the users within AD to match that of their CAC certificates.

 

- Open the Active Directory User and Computers snap-in  
- In the View menu make sure Advanced Features is checked  
- Right click on a user account and select Properties  
- Open the Attribute Editor tab, navigate to userPrincipalName and click Edit  
- Enter the DoD ID Number for the users CAC card followed by @mil and click OK  
- Click OK on the user properties window

 

# Configure AD FS Server

### Install Certificate

In this step we will be installing the certificate for the Federation Service URL.

 

- Copy the certificate to the AD FS server  
- Open an MMC console  
- Choose Add/Remove Snap-in… from the File menu  
- Click Certificates and click Add > 
[![image](http://lh3.googleusercontent.com/-JbxG1Y1S9hY/VfHj6QnZJ-I/AAAAAAAARQY/GBKSyRS2syk/image_thumb%25255B75%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-UFJW--UhDd0/VfHj5q0ve-I/AAAAAAAARQQ/F5JW7YPlHCs/s1600-h/image%25255B132%25255D.png)
- Choose Computer account and click Next 
[![image](http://lh3.googleusercontent.com/-l8CXSF5pzgI/VfHj7uVqq6I/AAAAAAAARQo/FKhGnA6ppcE/image_thumb%25255B77%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-Fka1NtrNNN0/VfHj637iWSI/AAAAAAAARQc/-tJum7utjZg/s1600-h/image%25255B136%25255D.png)
- Choose Local Computer and click Finish 
[![image](http://lh3.googleusercontent.com/-w96GBpF3FSI/VfHj8tsziEI/AAAAAAAARQ4/xZ7664Mbvtw/image_thumb%25255B79%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-JhNTdo9LRV0/VfHj8M7ty4I/AAAAAAAARQs/NOhIkzKq7Aw/s1600-h/image%25255B140%25255D.png)
- Expand the Personal folder and select the Certificates folder  
- Right click on the Certificates folder and select All Tasks -> Import… 
[![image](http://lh3.googleusercontent.com/-QEvUiEqt25k/VfHj997PVZI/AAAAAAAARRI/xR1TT4eEwWY/image_thumb%25255B81%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-WKeeobZtrSQ/VfHj9QezH1I/AAAAAAAARRA/i8ve6YIOD6k/s1600-h/image%25255B144%25255D.png)
- Choose the certificate for your external URL and click Next  
- Enter the password for the private key and also mark this key as exportable then click Next 
[![image](http://lh3.googleusercontent.com/-Ok__83jSNbg/VfHj_Be76HI/AAAAAAAARRY/iXHCmA-aVrE/image_thumb%25255B83%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-whMh6R8MqDk/VfHj-f4QM7I/AAAAAAAARRM/p5OG4yJn0RE/s1600-h/image%25255B148%25255D.png)
- Leave the default store of Personal on the Certificate Store page and click Next 
[![image](http://lh3.googleusercontent.com/-dyTdPMNyUho/VfHkAe62lwI/AAAAAAAARRo/A5UBf-KubsY/image_thumb%25255B85%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-8bfxjljfNfE/VfHj_6S-5tI/AAAAAAAARRc/M6FCz6q2jQQ/s1600-h/image%25255B152%25255D.png)
- Click the Finish button

### Add Roles and Features

Using the Add Roles and Features Wizard we will add the AD FS role.

- Login into WAP-ADFS with an account having Active Directory domain administrator permissions.  
- Open the Add Roles and Features Wizard and click next until you get to the Server Roles page  
- On the Server Roles page select the Active Directory Federation Services role and click Next 
[![image](http://lh3.googleusercontent.com/-sL6BIbMYf4w/VfHkByyA9gI/AAAAAAAARR4/rX0ITtrTIag/image_thumb%25255B87%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-Xrr6z0AtAcE/VfHkBMtK26I/AAAAAAAARRw/oT6LFExHNDA/s1600-h/image%25255B156%25255D.png)
- Click Next on the Features page 
[![image](http://lh3.googleusercontent.com/-WxqjbcrgB20/VfHkDA6JknI/AAAAAAAARSI/4MH1FpDkCX4/image_thumb%25255B89%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-CvrIc7AO-SY/VfHkCQYuK9I/AAAAAAAARSA/qghI9S7YdZ8/s1600-h/image%25255B160%25255D.png)
- Click Next on the AD FS page 
[![image](http://lh3.googleusercontent.com/-sWuzli7BSYU/VfHkET-a_xI/AAAAAAAARSY/GPUW1PHvmSg/image_thumb%25255B91%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-qrpU9fNt9LM/VfHkD0qIyGI/AAAAAAAARSQ/GWP0lefdPrc/s1600-h/image%25255B164%25255D.png)
- Check the Restart the destination server automatically if required check box on the Confirmation page and click Install 
[![image](http://lh3.googleusercontent.com/-P2Eg6PBzYtM/VfHkFxL1piI/AAAAAAAARSo/VVAoBnaUyrg/image_thumb%25255B93%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-gxJfkK5Pklo/VfHkFCTtcJI/AAAAAAAARSg/O5yfQXY5BdU/s1600-h/image%25255B168%25255D.png)
- The install will begin and the server will reboot when completed  
- After the server has rebooted continue the configuration for the AD FS service 
[![image](http://lh3.googleusercontent.com/-t3LwDN2h2sI/VfHkGwA6A6I/AAAAAAAARS0/VAGOJY1EE3o/image_thumb%25255B95%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-gBi8n3MmSoI/VfHkGeDaAeI/AAAAAAAARSw/XobTW_Vb9OY/s1600-h/image%25255B172%25255D.png)
- Since this is the first AD FS server in the environment we will be leaving the default option and clicking Next on the Welcome screen 
[![image](http://lh3.googleusercontent.com/-EXdOFojef9I/VfHkIQbEM0I/AAAAAAAARTI/v8pCfzC_8vA/image_thumb%25255B97%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-8Crl5zSqJ7c/VfHkHvB5nlI/AAAAAAAARTA/pyiInW9cZwE/s1600-h/image%25255B176%25255D.png)
- On the Connect to AD DS page you can leave the current user selected if you logged in with a user who has Active Directory administrative rights, otherwise change it to a user who does.  (this account will only be used for setup purposed and will not be used to run the AD FS services.)  
- Select the public certificate you installed earlier and enter the federation service name which should match the name on the certificate.  You can enter whatever you like for the Federation Service Display Name  
- On the Specify Service Account page you can create a new managed service account.  This account will be given all the rights it needs to run AD FS  
- On the Specify Database page select the Create a database on this server using Windows Internal Database if this will be the only AD FS machine within the network.  Otherwise if you plan on having multiple AD FS machine you will need to specify a SQL server to host the database, this is not covered in this guide. Click Next  
[![image](http://lh3.googleusercontent.com/-rEzEzS91HCM/VfHkJszJKXI/AAAAAAAARTY/awBx1IAdjvA/image_thumb%25255B99%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-uthW6D_dMPI/VfHkI0CoLII/AAAAAAAARTQ/MxSDWEpI-Z8/s1600-h/image%25255B180%25255D.png)
- On the Review Options page click the next button  
- After the Pre-requisites check has completed click Configure 
[![image](http://lh3.googleusercontent.com/-LkCjUVjm69w/VfHkLPxKJZI/AAAAAAAARTo/cZ14gemj7Uw/image_thumb%25255B102%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-Zl1TXn7Sjqo/VfHkKqodyqI/AAAAAAAARTg/wTThrwriS6A/s1600-h/image%25255B185%25255D.png)
- The installation will begin  
[![image](http://lh3.googleusercontent.com/-xFloEL2-1cY/VfHkMUiITQI/AAAAAAAART4/QyuX6BH1Pb0/image_thumb%25255B104%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-xZG7yO5KSBw/VfHkLmgS-II/AAAAAAAARTw/owtARsxoOzQ/s1600-h/image%25255B189%25255D.png)
- After the installation has completed click Close
[![image](http://lh3.googleusercontent.com/-g1iHxZOunjo/VfHkNzufulI/AAAAAAAARUI/GHrcOfyBygE/image_thumb%25255B106%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-XhTLtf91W_w/VfHkMxI3YII/AAAAAAAARUA/agRCT-HviDQ/s1600-h/image%25255B193%25255D.png)

### Add CRM as Non-Claims Aware Relying Party

- Open the AD FS Management snap-in  
- Expand Trust Relationships and select the Relying Party Trusts folder  
- Click Add Non-Claims-Aware Relying Party Trust… in the Actions menu  
[![image](http://lh3.googleusercontent.com/-B6i5BrchZPQ/VfHkPcm7H7I/AAAAAAAARUY/JY6Nt07yr24/image_thumb%25255B108%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-AdgmJf6hzJI/VfHkO1vJRPI/AAAAAAAARUQ/Yhu1z5RvllM/s1600-h/image%25255B197%25255D.png)
- Click Start button on the Welcome screen  
- Enter any display name you like and click the Next button  
- Enter the external URL of the CRM website and click the Add button  
- Click the Next button  
- Leave the default values for not configuring multi-factor authentication and click Next  
- Click Next on the Ready to Add Trust page  
- Make sure the Open the Edit Issuance Authority Rules dialog checkbox is checked and select Close  
- On the Edit Claims Rule dialog click the Add Rule… button  
[![image](http://lh3.googleusercontent.com/-OzZTtjyrLeU/VfHkQvoo12I/AAAAAAAARUo/bpsGUEwASvM/image_thumb%25255B110%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-SWBXQSel9fs/VfHkP0sGQrI/AAAAAAAARUc/ulcdik9uvAk/s1600-h/image%25255B201%25255D.png)
- In the Claim rule template select Permit All Users and click Next  
[![image](http://lh3.googleusercontent.com/-Xonitdu0M2w/VfHkR_zRXtI/AAAAAAAARU4/PhB-y4SHLFA/image_thumb%25255B112%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-qyc7W7Of6eI/VfHkRJEuriI/AAAAAAAARUw/weRxBcEREDc/s1600-h/image%25255B205%25255D.png)
- Click Finish  
- Click Ok on the Edit Claim Rules for CRM Dialog
[![image](http://lh3.googleusercontent.com/-31P9qDOPY9c/VfHkTHHLWGI/AAAAAAAARVE/fSzIx2blUJU/image_thumb%25255B114%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-apF_ixkEHnY/VfHkSkwGw2I/AAAAAAAARVA/-VUovkHknz4/s1600-h/image%25255B209%25255D.png)

### Update Authentication Policy

In order to accept only client certificates updates will be completed on the global AD FS authentication settings.

- Open the AD FS Management snap-in  
- Click on the Authentication Policies folder  
- Click on Edit Global Primary Authentication.. in the Actions menu 
[![image](http://lh3.googleusercontent.com/-1_WLUmHyIAQ/VfHkUVg4qGI/AAAAAAAARVU/GwMvb4qkOWE/image_thumb%25255B116%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-_Y8gSphz0Oo/VfHkTpeYFbI/AAAAAAAARVQ/8gYXy3kw3DE/s1600-h/image%25255B213%25255D.png)
- In the Extranet settings un-check Forms Authentication and check Certificate Authentication, then click OK
[![image](http://lh3.googleusercontent.com/-EMaOD4pl1x8/VfHkWhjjeVI/AAAAAAAARVo/Spy883yW6Wc/image_thumb%25255B118%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-VZaNVj2VFeI/VfHkU0bg0OI/AAAAAAAARVg/tMw31uRU_e4/s1600-h/image%25255B217%25255D.png)

### Test AD FS Service

This will test if the AD FS server is running and processing requests

- Open browser on AD FS server  
- Enter the following URL, https://wap-fs.raw.com/adfs/fs/federationserverservice.asmx
Note: make sure to replace wap-fs.raw.com with your federation service url  
- The browser should show and XML response from the server

# Configure WAP Server

### Add Roles and Features

- Open the Add Roles and Features Wizard and click next until you get to the Server Roles page  
- On the Server Roles page select the Remote Access role and click Next  
[![image](http://lh3.googleusercontent.com/-kv_LTFkQRNw/VfHkZBQRt7I/AAAAAAAARV4/86l9Xxe8vws/image_thumb%25255B120%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-HlnmhxEKzVA/VfHkYsJSCTI/AAAAAAAARVw/pA3OvHuDmJY/s1600-h/image%25255B221%25255D.png)
- Click Next on the Features screen  
- On the Role Services page for Remote Access choose Web Application Proxy  
[![image](http://lh3.googleusercontent.com/-xnSUyKP5DQE/VfHkat7A8EI/AAAAAAAARWI/7Luapy-k5ZI/image_thumb%25255B122%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-4TH-Pyl_zgs/VfHkZ9U2aYI/AAAAAAAARWA/XFaq4eI_HRE/s1600-h/image%25255B225%25255D.png)
- Click Add features if prompted to add additional Remote Server Administration Tools  
[![image](http://lh3.googleusercontent.com/-pgBPuneXy9Y/VfHkb94aXNI/AAAAAAAARWY/T4_VzBbetm8/image_thumb%25255B124%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-CVPXTP0Ij08/VfHkbAAfQRI/AAAAAAAARWM/W534dzZ5T10/s1600-h/image%25255B229%25255D.png)
- Click Next on the Select role services window  
- On the Confirm installation selections page check the Restart the destination server automatically checkbox and click Install
[![image](http://lh3.googleusercontent.com/-EubcEaumY20/VfHkc0Eoj3I/AAAAAAAARWo/dh4ZEPXwTks/image_thumb%25255B126%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-1_E61KYoN_I/VfHkcRwTCWI/AAAAAAAARWg/e6UTL2LDI7A/s1600-h/image%25255B233%25255D.png)

### Install Certificates

The WAP server will be the forward facing server that clients will be hitting, because of this any certificate which will be used for external URLs will need to be installed on this machine.  These certificates should contain the private key.

- Open an MMC console  
- Choose Add/Remove Snap-in… from the File menu  
- Click Certificates and click Add >  
[![image](http://lh3.googleusercontent.com/-cB8fVhIlFcc/VfHkebQmirI/AAAAAAAARW4/g9gm39H8JUM/image_thumb%25255B128%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-FEcxJXCdXhc/VfHkdl0ri2I/AAAAAAAARWw/VycYYaeeg2E/s1600-h/image%25255B237%25255D.png)
- Choose Computer account and click Next  
[![image](http://lh3.googleusercontent.com/-76QK73zN2Bw/VfHkf44oxlI/AAAAAAAARXI/5YrfqViD0F8/image_thumb%25255B130%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-evf1vEN1gOo/VfHkfPBNvYI/AAAAAAAARXA/XTgi-e0s38Y/s1600-h/image%25255B241%25255D.png)
- Choose Local Computer and click Finish  
[![image](http://lh3.googleusercontent.com/-2jREp_aWDxM/VfHkhAAQElI/AAAAAAAARXY/EQgkyIFLcRk/image_thumb%25255B132%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-gB9VLn6lA4A/VfHkgUYrQSI/AAAAAAAARXQ/4LxDsXdz3B0/s1600-h/image%25255B245%25255D.png)
- Expand the Personal folder and select the Certificates folder  
- Right click on the Certificates folder and select All Tasks -> Import…  
[![image](http://lh3.googleusercontent.com/-bWRt4TVfqHo/VfHkj26qVXI/AAAAAAAARXs/oUVm303epj0/image_thumb%25255B134%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-uKQuzm2PWz4/VfHki9lsZ9I/AAAAAAAARXk/BPpJ-LcDn9Q/s1600-h/image%25255B249%25255D.png)
- Choose the certificate for your external URL and click Next  
- Enter the password for the private key and also mark this key as exportable then click Next  
[![image](http://lh3.googleusercontent.com/-KUNMYdU5rkM/VfHklKoCGnI/AAAAAAAARX8/YC3r0k3AynE/image_thumb%25255B136%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-JX19iSiG5h4/VfHkkW1pjbI/AAAAAAAARXw/zsSxMgckemY/s1600-h/image%25255B253%25255D.png)
- Leave the default store of Personal on the Certificate Store page and click Next  
[![image](http://lh3.googleusercontent.com/-fkPnClDAdMo/VfHkmERz6iI/AAAAAAAARYM/TxeoC1amxjE/image_thumb%25255B138%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-8JQHq-SKsfE/VfHklUd2qKI/AAAAAAAARYE/vQmxgsfFvpw/s1600-h/image%25255B257%25255D.png)
- Click the Finish button

### DNS Host File Entry

Based upon our sample setup our WAP server is located in a DMZ without access to the internal DNS server.  Because of this we will be using host file entries to map the external URLs from the WAP machine to the internal address of the machines actually hosting the services.

 

- Open Explorer and navigate to C:\Windows\System32\drivers\etc  
[![image](http://lh3.googleusercontent.com/-3Lnf5xVwKhs/VfHknJXR2GI/AAAAAAAARYc/NSa5SdXyAwQ/image_thumb%25255B140%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-W0HRTIGjhMg/VfHkmqp14RI/AAAAAAAARYQ/jGLgdGOYvPQ/s1600-h/image%25255B261%25255D.png)
- Open the hosts file using notepad  
- Create entries for the two internal machines which will be hosting AD FS and CRM and the external URLs which are going to be used

### Configure WAP

- Open the Web Application Proxy Wizard configuration  
[![image](http://lh3.googleusercontent.com/-Pmz5-WmhXpU/VfHkoQXz2BI/AAAAAAAARYs/YwKWcOGRFTQ/image_thumb%25255B142%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-DVzPi_sef-4/VfHkn5zCKfI/AAAAAAAARYk/cZGmuxR3Fx4/s1600-h/image%25255B265%25255D.png)
- On the Welcome screen click Next  
- Enter the federation service name you used during the AD FS setup and enter the information for a local service account on the ADFS box that has local administrative rights  
- Select the certificate which is also being used by the AD FS service  
- On the confirmation page click Configure  
- After the configuration has completed click Close  
- After configuration the Remote Access Management Console will be displayed  
[![image](http://lh3.googleusercontent.com/-mKcJwNOcUxQ/VfHkpTHZlFI/AAAAAAAARY4/ODpRjnYZKhg/image_thumb%25255B144%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-4UDpnmSSN_w/VfHko17IRWI/AAAAAAAARY0/KRVL9K2K2yo/s1600-h/image%25255B269%25255D.png)
- Select Publish from the Tasks menu  
[![image](http://lh3.googleusercontent.com/-60a31nRPwrk/VfHkqn0S1XI/AAAAAAAARZM/iIYwhbmKbcw/image_thumb%25255B146%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-CN53ew40rN4/VfHkp6NuGYI/AAAAAAAARZE/MOJrS07sJv4/s1600-h/image%25255B273%25255D.png)
- On the Welcome Screen click Next  
- Choose Active Directory Federation Service as the pre-authentication method and click Next  
[![image](http://lh3.googleusercontent.com/-U12whBYZ-hg/VfHkr_2j7NI/AAAAAAAARZc/t4zZa0lis_4/image_thumb%25255B148%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-ogOHs0kPpgc/VfHkrYs70BI/AAAAAAAARZU/btl2ZTwLz4s/s1600-h/image%25255B277%25255D.png)
- Select the Relaying Party we created during the AD FS setup for CRM and click Next  
[![image](http://lh3.googleusercontent.com/-i83CEhCapXg/VfHktDFjPsI/AAAAAAAARZs/M-lvuItgYkE/image_thumb%25255B150%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-KjBRwkaH8kE/VfHksXzETaI/AAAAAAAARZk/0rJGF6rJ8so/s1600-h/image%25255B281%25255D.png)
- Enter information for the published website.  The name can be whatever you like  
- On the Confirmation screen click Publish  
- After the web application has been published click Close

 

# Client Certificate Revocation (Development Environment)

On a production environment Tumbleweed or another service providing CRL should be installed and configured.  Within a development environment where Tumbleweed is not available disabling CRL checking can be done to allow for testing.  Disabling CRL checking is not something you would ever want to do in a production environment since it would negate much of the security that certificates provide.

- Log into the Web Application Proxy machine  
- Open a command window and enter the following command and press Enter

netsh http show sslcert

- Find the Hostname:port entry ending in 49443  
- Run the following command, replace << Hostname:port >> with the Hostname:port value from your environment

netsh http delete sslcert hostnameport=<>

- Run the following command, replace all << >> with the related items from your system

netsh http add sslcert hostnameport=<> certhash=<> appid=<> certstorename=My verifyclientcertrevocation=disable ClientCertNegotiation=enable

 

 

 

 

 

 

 

 

 

