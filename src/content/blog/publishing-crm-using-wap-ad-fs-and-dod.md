---
title: "Publishing CRM Using WAP, AD FS and DoD PKI"
description: "With TMG going the way of the dodo Microsoft has moved much of it's functionality into Server 2012R2.…"
pubDate: 2015-09-10
category: power-apps
tags:
  - "adfs-3"
  - "authentication"
  - "crm"
  - "pki"
  - "wap"
draft: false
originalBloggerUrl: /2015/09/publishing-crm-using-wap-ad-fs-and-dod.html
---

With TMG going the way of the dodo Microsoft has moved much of it's functionality into Server 2012R2.  This includes publishing applications utilizing Windows Authentication and Kerberos Constrained Delegation (KCD).  This is done through a combination of a feature called Web Application Proxy and ADFS 3.0.  
  
  

# Requirements

- Windows Server 2012R2- The Web Application Proxy server should be joined to the domain in order to pass KCD tickets.  The WAP server actually can be in another domain but it would require additional setup not covered in this article.- The External DNS of CRM should point to the WAP server.- WAP server will need two virtual or physical network cards.  One for external communications and one for internal.- The Federation Service URL cannot match the machine name of the AD FS server.

# Example Configuration

This diagram represents the configuration for our sample environment. Additional setup scenarios for load balancing the WAP and CRM server are possible but not covered in this setup guide.

[![2015-09-10 13_57_58-WAP ADFS KCD CRM (1).vsdx - Visio Professional](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg2UQ_NKAPNWVvQsZmyUmzApOZwFjp9blwC5Sm1F5qrVI027X2FNq7Mssldi6bNbLjCGH3XsLqI3Ow49fzNXmNOGjj22f8YQ0HhKxl6yViQwwKco0i87acqdV3OruwoYa7tpmkK8fWSv4k/?imgmax=800 "2015-09-10 13_57_58-WAP ADFS KCD CRM (1).vsdx - Visio Professional")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhMnmV0XIckHhTL8_I0AvqqNUjwyqRZ5mtb-aQm-GUSYImm974dG6m39qTgf93zWu4Ds1RFznscVvI1EgmEn4nRXnPvJ0DQZamNlY8O7E0ui5lAmSH623FQOjn3ly86nk0iUgFG8NKHAws/s1600-h/2015-09-10%25252013_57_58-WAP%25252BADFS%25252BKCD%25252BCRM%252520%2525281%252529.vsdx%252520-%252520Visio%252520Professional.png)

### 

# Firewall Considerations

If your domain controller (DC) and your Web Application Proxy will be separated by a firewall you will need to establish Active Directory and Kerberos communication between them. In order to do this you will need the following port rules.

### Ports required for Active Directory communication and Kerberos

|  |  |
| --- | --- |
| Port/Transport | Protocol |
| 443/TCP | HTTPS |
| 389/TCP | LDAP to Directory Service |
| 389/UDP |  |
| 3268/TCP | LDAP to Global Catalog Server |
| 88/TCP | Kerberos Authentication |
| 88/UDP |  |

# DNS Setup

The setting below describe the DNS setup using the sample setup diagram.

### External DNS

All the external DNS records should point to your Web Application Proxy external IP

|  |  |  |
| --- | --- | --- |
| URL | IP | Usage |
| <https://wap-crm.raw.com> | 52.4.168.181 | CRM Website |
| <https://wap-fs.raw.com> | 52.4.168.181 | AD FS Proxy Website |

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

In order for Kerberos Constrained Delegation to work correctly we must ensure that Kerberos is functioning correctly in CRM.   The following will demonstrate a basic Kerberos setup for a single CRM server.

### CRM Application Pool User

Your CRM environment should be using a domain user to run the Application Pool for CRM.  We will first determine what user is running the application pool.

- Open the IIS Management Console- Expand the server node and select Application Pools- Make note of the user running the CRMAppPool

### Kernel Mode Authentication and Authentication Providers

If kernel mode authentication is being used additional setting will need to be configured to ensure that the application pool user account is being used when Kerberos tickets are issued.  Additionally make sure that the providers for windows authentication are utilizing Kerberos (Negotiate).

#### Set Kernel Mode Authentication

- Open the IIS Management Console- Expand the server node and the Sites node- Click on the Microsoft Dynamics CRM website- Double click on Authentication in the Feature View area- Select Windows Authentication in the Features View area- Click Advanced Settings… in the Actions area- Ensure that Enable Kernel-mode authentication is checked and click Ok or Cancel if it was already checked

#### Check Authentication Providers

- Open the IIS Management Console- Expand the server node and the Sites node- Click on the Microsoft Dynamics CRM website- Double click on Authentication in the Feature View area- Select Windows Authentication in the Features View area and click the Providers… link in the Actions menu.- The providers window should have Negotiate listed as the first provider- Note: If Negotiate is not listed you can add it from the Available Providers drop down.  Additional if any provider is listed above Negotiate use the Move Up and Move Down buttons to ensure Negotiate is listed as the first provider.

#### Use Application Pool Credentials

Because we are using kernel mode authentication CRM will attempt to get Kerberos tickets utilizing a build in service account.  The service account IIS will user for Kerberos is not delegated to pass the tickets.  In order to fix this issue settings will need to be adjusted on the CRM website to ensure the application pool user we identified earlier who is delegated for Kerberos will attempt to get the tickets.

- Open the IIS Management Console- Expand the server node and the Sites node- Click on the Microsoft Dynamics CRM website- Double click on Configuration Editor in the Feature View area- Change the section area to System.webServer/security/authentication/windowsAuthentication- Update the authPersisNonNTLM and useAppPoolCredentials to True- Click the Apply button in the Actions area

# Configure Domain Controller

### Install DoD Certificates

The instructions illustrated here may differ from internal processes for installing certificates within your organization.

- Download and complete the setup for InstallRoot 4.1  
  x64 - <http://iasecontent.disa.mil/pki-pke/InstallRoot_4.1x64.msi>   
  x32 - [http://iasecontent.disa.mil/pki-pke/InstallRoot\_4.1x32.msi](http://iasecontent.disa.mil/pki-pke/InstallRoot_4.1x64.msi)- Run InstallRoot- Click the red checkbox next to Install DoD Certificates so that it turns into a green checkmark- Choose Install Certificates from the Actions Menu

### Install Certificates into NTAuth Store

In order for Smart Cards (PKI) to work correctly within our domain the certificates at the root of the smart card must be installed at the Active Directory level. The instructions illustrated here may differ from internal processes for installing certificates within your organization.

- Run InstallRoot- Make sure you have already installed the DoD Certificates- Click on the Store tab- Click on the Active Directory NTAuth button in the ribbon   
        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjlB5YUx8IdCfok0RUlkTHeVn5uGax05qtRbYa9UXmIG5wx1yqBpth9uLCwqe1rgJ45RK4iKuLnwhVmtgE37l-xj8fG0a-b44Wa4abm-Q2JLfz-F2gPFTmIs9W_WWK2rooKwyjXNIXxcF8/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiUbwKZHi10ch35a-bgv4UlQSFJ7tmsEj5Bi0-qFSW-xNd2ryWXxXsiW5ysx4Ahg_q4oOY5jsSwuxisx4Sjy9hp-KFm7gzO9c-KqdAe4SUYd33dbPDW9A1IgZ0edbPe5ERkpNgMyeP0JO8/s1600-h/image%25255B8%25255D.png)- Click ok when prompted- Go back to the Home tab and select Install Certificates   
            [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjWJEfkCbTrOam4NJQh-6x6a7busJyh7setFf4eBf9Y0Xy4tJ82HiJmtnMRmLHhA02UP6VgcB-RN_78ADKMNZjKRhjT4EiKot7hHZngMp-gpVxydIpd8B4QHNTFdebZbLVCZwHscjbNfiI/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj6oJPJ25B0EhRvZD52BxB2naBiJdgBadshFiUnWXkf-pD0fwCFOrHGWghn7quZIsAD7QA8FFVG8yqzs45RgVAlEId0YZARIX7HW467nu1eY41EoiEVsQabwlO7Cjn5aVd9uXc3iyw3yxo/s1600-h/image%25255B7%25255D.png)- InstallRoot will install the necessary certificates into the NTAuth store, click Ok when complete   
              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEimA-HQDkcCHpwPPb2K9o-EFpESFo5iy_YukNfod_XBjcmHt6BCVDDTBYRdfzs8j0Yninq6lxyU-IfMeYlT7juqCeBTRIsvtzJ-mGOEUeUJXSPXLi2m7vbHzRXWmlSIqFG25h2GtyRG_q4/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiemMlbD_lhEPlRG63IGoLmZm-JI-xvo16yuEjhoRDM0weWIB17HLgb0URCJM7A2x6iPVgq2URucoDXcUh9MyGoOthme_ClyhyBumNxm_UjCVcF36vNQyTErQgeGvvjvciXIUvkbReLxSU/s1600-h/image%25255B12%25255D.png)- Leave InstallRoot open- Open a command prompt- Run the command gpupdate /force  
                    **Note**: This will update the local NTAuth store with that of the one you just updated- Go back to InstallRoot and click on the Store tab- Click on the NTAuth Comparison report button   
                        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqyZaUa19YA4OETL1eHaxZrb3ywFhsIx23hIh3KEhgLnXWr3SUAgqbvr7kGaCrIWhjLUWCpbff7W32ZYy9OuHQiseFHkhuKOy2QSCSItYwsQlBtqIAHDUGCbcLpkYlbc8IWlgmPRRC1l4/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjUbcntmLUi88osM8RPtMvW1lneE6BjGqOKTqpD4FH03gWMvk9r_bDqsrR060LuhehdnZM4yHjQvV3p9hOho89O4KgHM7JpnXRGCVSREy0WDgXbSWAprGcwRYLiLwjNDoP7jbYP27eQxvg/s1600-h/image%25255B21%25255D.png)- The Report should show that both Active Directory and the Local store both have the DoD certificates installed, click Ok when you have verified the certificate installation

### Push Certificates Using Group Policy

In order to avoid having to install the DoD certificates on all machines utilize group policy to push the certificates down to all servers within the domain.

#### Export Certificates from Local Store

In order to import the certificates into the group policy object we first need to export the certificates from the local store.

- Open an MMC console- Choose Add/Remove Snap-in… from the File menu- Click Certificates and click Add >   
      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgdklFBe00f_AN-mziwu67C4MekXm1jVNicBDF_40RKOkVWz9WsbRxsQiVWljD4HnzU0DZ8Ar9KLlmIwbnd6ovig_khSfHsvRFYhwNhQxg_G3Ht0ahXBtTf5b92_UFLeXPzGNnqiI5DFOI/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhF4cH2bqIwX1sc0w_HIebPfwYeNhJaklyHp5GnOm-0LIOzVswJcYsVaqUCsCTgNnKlHRsmmLKJf2qOJKlrm5KkGE9VjO_V7gaaOjy_hHmOCZXJ4TNS9QK3QgS6Kpw5AiifJ2yIHUopODQ/s1600-h/image%25255B20%25255D.png)- Choose Computer account and click Next   
        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEicEVGFtt8vC1T2oNLV_J0tXvaRle2E_v5goL3vese9f3PYX8pgS7KVOiDsXLTefQTLpPMXDmtSrv8IkKvcFE-pHJsFlwR0IdC1ptnwQTVCYtQcM2-QgJ6EWYqm1J8BOUBh8-AhhcnoSvA/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiew2SlPqfBE-rK1qsABAbDWOJvKXBnNJMit5FdKCxvonNHjygbJ5i9q70erlxVH_oQTufT83zvMC2ceMW_EGDUv8b_l82EFUeoJs2cOoR6O-OS_X3qU9XAClB5Ad7uuN-SztiRlYI3TbI/s1600-h/image%25255B25%25255D.png)- Choose Local Computer and click Finish   
          [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjxcQXdJXSYddO3vuE-a1_ZnzMBWGwmDAWprW-Pve6SVPKMDzr2mTvQXWeWK9BL-2qEIQLL48c0j0TR5J474XbypnMV5h0eB-Z9RKK6oSwEVJ_ZNnMrKxEeVZjRi0maijTSnXLH4CZhg4Y/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgtR7eo9TvjYRFove7sDKh8isnnUIoCnkC5mISNbbHCjK-Jgz0OrJTPM0mnj0d9cdrm305nmjpesnumibPSwptxjAdQmRBLNs2yDLjWiBI8sweS5VGN1BKrs7B0j1nBunZRegczIUa6zu8/s1600-h/image%25255B29%25255D.png)- Expand the Trusted Root Certification Authorities and select the Certificates folder- Select the two DoD Root CA certificates   
              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjnRzCmOh_q5hMZLSDWKKs-3F2i3tgGzlzPYOiBwCroEoxml3Igirvwm_U3qBRu7z1O-Wu64PQyYQGqMdIxQNk_bspJw5CRaRRFhQhaY4xFdKdIswdmHZ8zVpWWgYEYW-4ybKJnSjrCTxg/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjhmdnKLZ1d5SksRD0Hk8ehKOqECimYGVGqBX4Z7YiDMuX3rcHLyyTYG7l0FbnyWv2uNytHhbJwT5FnHacbYHCHrkowO5Jln18XqJuX1l_uCTVoryTCdeOiJnYOJ4XfnCNpEnDDuZ3gwL8/s1600-h/image%25255B33%25255D.png)- Right click on the two certificates and choose All Tasks -> Export…   
                [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhhsMRxZGR9hDaPlcrlYhyphenhyphenvvzO-tvmSvO2cnEJMlE0omn2ffVK_aras9eGwTPB-KRB6cAhmWUw9tQlg8wXv5SjM-VoVyHpKw9GJap8S4VZnAJAK-pCDkatX2CudZiyHeXaJ5rgEz1sZAXc/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhpY05FrYYDyi9kU_4P3EhAq-cktCLWgfw-i1ZqJo4KhWOUpdZ9tUlX7FPaXImIfTYZ-JD-W3Y61792HMHSMeVZjw_N-zsvbrB7yQUOXTNCTUlaxIqECSGYeUraNalzYS34XwSzOphkWk4/s1600-h/image%25255B37%25255D.png)- Click Next on the first page of the Certificate Export Wizard- On the file format window choose Microsoft Serialized Certificate Store (.SST) and click Next   
                    [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgsa0oXV0xQeLVS5VgKCGkx279CRn4tYT2rAyiG_6Ye1CdS_AzviUJoOWMUOIeFZpwgLqC5W0-o8nOLrdneSHli8JmAoZHuIZqW7R6Ej5kaCvSOgAvnzAzvLKJeMXY94TIQupAYbZLQjOc/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiqep_jSWrTU8b9ZLnAtn2rojwHjKziFKiVjPeuov0ZEO566rdLGzk1bMCmiXhhOGz0C031_oy1kwo8YclwPNr1hd1xlEdFv6PdA78gYalsKHBRuaT-VWuafnbqAMxJ3lKiwRldEKXsUNU/s1600-h/image%25255B41%25255D.png)- Choose a location and File name for the certificate file and click Next   
                      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgBSPwhc3psGKFwwVKW7VpEQsRASLAys0ANyVefeGOq89HxtScPOI6IBU-ccaM5y6fOQXmpLa6ibL1qzXvGd7LLC37DYKwmI7GBQ-CLvINcLPP1MoTaa92X0SSInN2A_8scSsyhC78ZteM/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgxIxo70Zf9IcpxIN8nzWS5LKswNxWx93nsT2ABmJZYO2OrSgSothUWZeSEpVqfByyO6v7_05YaxN1d679JkioFgOjOSm1XXMVoG-RDqRJt1N-ElBLt7Ko0OTt365i8_CsIe53FFaRCRCE/s1600-h/image%25255B45%25255D.png)- Click Finish on the Completing the Certificate Export Wizard- Expand the Intermediate Certification Authorities and select the Certificates folder- Select all of the DOD certificates   
                            [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjF_rVUBjgM-i3A-i5eOlWtvIixgfDTHGn0tH-dSF83Hop3EGUljFRk24_D3ERv8RLtcFVO78z6-dGG78M7LVllRj7Anhn4wREQUG6tOxsMx365rCwYAliYUflYJmn8bn_5iahBNtGxczk/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiwaoSI4P2vmwNP5UF70P4c1jsIddM8bxAJcEL2zBKjtgEnwzcPIZmL_oufLzK9pWyUt2VXmoI5UB6mV_8tynhCb4sWj77xlCMFMjKzBCyesfh8wWwcpn3YM2Wa-85s-nxf7rO0ARPEq_k/s1600-h/image%25255B50%25255D.png)- Right click on the selected certificates and select All Tasks -> Export…   
                              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhCzh0qnYA4xxdxywYfor6FVMqDy-_PllfSAop1CS1C3BE3kDTO18hFEdMSJGu93ngCN4Swwa3JId1-BguSNXXVSzw8fhYx9tnVF-VKCW6NGByATAJvf96OHIN9THnrtN_kIl_npSgpIxI/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEifUtHv2gKV1TW5A8Ka8-oumd47JB9n3Dkcr7jFI3DlkuTdnCXoklQ_5HBOPIRyWzMcgNk05a4ndyvqEgFlCiJvms13PJ0oZ3w-x0aZ5Emz-Jp6r_jb2yAbZYDO8tQFW_U9a5ymR8BNn80/s1600-h/image%25255B54%25255D.png)- Click Next on the first page of the Certificate Export Wizard- On the file format window choose Microsoft Serialized Certificate Store (.SST) and click Next   
                                  [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjKzpp7SOPJK27r5QmHEIm8vWwSKXv68_0b45mnzDhJZQ5CwZ8v062fNFUfxYpd92ZWC4nFXaCCNrNEJmcXMyFGLZtq2xkXAfHfHbupd1Ul9nKiOxHlh_1rT2jWJOaO-e6vlsweaUNXOIA/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi2-iyWd93yo_SYFOqPtScHGXl2BMIxNMHrrZbfSP0bGnWmLyuD9u8xYo7sscfbctvSIJM_zPaiScA_DrPdkpXxOKUr4wWrPtCMGZn0CSlOB4MXrJbBLX7cSSqZP94vrNfRgp3KHgh1yAg/s1600-h/image%25255B58%25255D.png)- Choose a location and File name for the certificate file and click Next   
                                    [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi50hgEmDRPzWkCtOcEwmx1ecPrmNEpO8uOninY1fJZF9k26Ylg7A8_Y3jhclLtZwbyTOV2d7x2Hs5dXbry2IE0Obj-iOExQdvC-_fa-urbV4qZE4sY_Jj7LAR9v3TFMI5CKyGD05kNfOc/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhpjw929mq-7vmSH3jKIIb3NOwsictmFbDkBXgdYA9ezehPQp38L9DZ42mmIpmGKCv0HP7WiFIOhLULl5kXeM8wTowVGCX6tq7BgzflQfDZPwluH4Qty0_jccTodTK2D7lIaLTjyzNuiq8/s1600-h/image%25255B62%25255D.png)- Click Finish on the Completing the Certificate Export Wizard

#### Import Certificates into Group Policy Object

- Open the Group Policy Management snap-in- Expand Domains and expand your domain- Expand the Group Policy Objects container- Right click on the Default Domain Policy and select Edit…- Within the Group Policy Management Editor navigate to Computer Configuration -> Policies -> Window Settings -> Security Settings -> Public Key Policies   
          [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiu6h2vDq2bVzTewIolb4p0pBDS_nMjlFve1QqBYOF_hAbcR_P6oNzAPWy5fqY293hUopcTG8tU3c8M1K7E-_km1mlw0uda5qsIyaRCrKwNy9K9HBLYdJtH0nqX082SQvw-R8rw2wG5-xw/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiDRV-rDOIOm5NJ52TAvbWg9oLgio7lH-r92WYm_gScixHOVsMTb8WlUT4sXfF-OFopeQvF6iPyltw63eKnpqYOn6REe1HopZuZUke-ZoF5yJWSolXBzvLh7BQc1RKaOLDn6M0zqXucvSk/s1600-h/image%25255B66%25255D.png)- Expand Public Key Policies and Select the Trusted Root Certification Authorities- Right click on the Trusted Root Certification Authorities folder and select Import…   
              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgWL0H3gP6pWqrKDl7gSnRt39Jw00uAMetphjAAz5B5xzbEap_hQ5dXAiMfo3HAAGolIcu1SUJuoTNe33Kd4QERwDwJ9Kgp3wAf8W971amxpjLJ0KiKF1amW_IfNGG-Qor_jqntp6Ebb7w/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiiSoaBDCkYJjSnH4GvGJgB7R55D6PmoXeM_DicEtZLKnb33GBjvREJdpNddeBB36afzJ2-3ZziwCLRtOm5TrkxfItMStZBWIjaNSee2weFTje343cNm_0M1Kh2oUGn6LJ0UYN-UKVdzV8/s1600-h/image%25255B70%25255D.png)- Click Next on the Welcome to the Certificate Import Wizard- Click Browse on the File to Import page- On the Open file dialog change the file type lookup to Microsoft Serialized Certificate Store (\*.sst) and choose the DoD Root certificate sst you created earlier   
                    [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjkoNDw6VK8OaHGmy3V3f9BBKaWOhk3A76k9cGSxCZ-wZtKjKwzKE9RFiO1Srxbrr3JSuuuchZTlrLzZnE1T3VTLM5iHwSgDlRpC0l0T_z7w41d76VtPFpeDGo_c8MsV67r4jhT5Ayvyd4/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhNIBTKs9ec3EPRlVVLjZXvUMgPQ-ZZpYwGHmXQFi4ZGSPNp4Pj_YtytPdvFtKJfS6u8a0VOPzYynqFEJT3-Ba0fNO8Gy4y6KZ0NYsCLGxDptsLqg21geRjYShyCuAbrw0dyoUyiTT51fk/s1600-h/image%25255B78%25255D.png)- After selecting the file click Next on the File to Import page   
                      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgA14nTEEWudHrzw9rEY3RPczMnzNHMv6Y0cFmtOBaQ0WW1zR48cJ1TZyIqWNI2YMpVsPdGq-MLQ0tH-d18r7UxGlOOS2Dsw-mcNeWaCe0iJCb8GA-ZZybrXExCtAlF5mHgf32uv6sgzoE/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiJaBJg6Wwd-ucLnY3-Wbl4lm2h5hTsVS1nGLdHYa5csv28FV8ouNQY4LHReI3GmT9qCI3hNSkkKdEUiosCJg0gObFDa7cwOxNSuuzcYqmBjXa5tK1eJd1I96rJ-TJJD6IaNdYQCJ6bcGY/s1600-h/image%25255B74%25255D.png)- The certificate store will have the Trusted Root Certification Authorities selected by default, click the Next button   
                        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgSP4C98zQj9LEHIhQjKNSqrGlURkNyCwctYqV6OGZf-honU8DS5h8J-zoci_CocgWAVOmu07PE9SNBfnDD0_Fj7Upoz_ZbZCTKwYLAXQHvA5JS-6DiyxrvGjMTBoQzeMkOYDtPhTUCkqk/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgL_qYZLXUK9iAJvI7HTT3HqZZy0I0NY53y0WE2iXaY0ZMKTqV8duwLUDRycb26b7NbMPczSDB1JcfdNuBHFmdj1Q__TM_IyoX018di5Jhy-mMWrKAanja5ScHkVeTRpb4qlgnKCgJPqU8/s1600-h/image%25255B82%25255D.png)- Click the Finish button on the Completing the Certificate Import Wizard- Under the Public Key Policies click the Intermediate Certification Authorities folder- Right click on the Intermediate Certification Authorities folder and select Import…   
                              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjI65DqtDTQJsJV9vmBPpVXmDRsGEAxgHCYxiia-kWa6S4IEgrLFxrnue70kJ3M9rmVs7gsolg-hzUC80Xqwxa6meEEt5h3xPeZOmLQ0Y3fnuzGIhmYEesU1NAv6Y3XStx8eykLv3YUIEY/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgscgUBHyv02nO9Q-C_-_mnRWkvMIweL-rN1KHPJtoubUnTbSNt5mChq62zeXYhTa9GEqhIh6IvYZA4CROEJ18qqhFEtZe2zXGE81Qgu8XFFCIIaFnGaYz6t05RTkzb9IUIK8tG9DrNy5A/s1600-h/image%25255B86%25255D.png)- Click Next on the Welcome to the Certificate Import Wizard- Click Browse on the File to Import page- On the Open file dialog change the file type lookup to Microsoft Serialized Certificate Store (\*.sst) and choose the DoD Root certificate sst you created earlier   
                                    [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgqQriDMntcj39dMm6gfVwbsObmgAADjGsr_h4Jqaka5AngWlJYEH8pPWpmOcLij3dj4UD_HAZJozlShuLsT_vw7fIxXH4QianuOq1-Vwor2x3Ksy_RHz9RZwMwwOQoiyZmkL7HV-jDtlE/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiSsgnzLoOGxP7sTCj82XHop5bKorT55JDuYx6NkgXpqjjimJgv03xKWJccQ27G2b8Dg3llD_n2epDk_yH4xaqmSvs47RpndbWybGJg5IdY_jYO5nyXjj92UNg8oUT6-g80bp09tCiVJWQ/s1600-h/image%25255B90%25255D.png)- After selecting the file click Next on the File to Import page   
                                      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi30cdKMTORuibAE21kxvFnxbnoWTubtYYdSMz4BQSaWV8EuULlNcEB0T4kwgtvEuxan1mlJiCLewiw7JBTAK24249AMZWQn8efzIZTIHhvy75BRDrYG6PfDDnPQxu6GRUyHjcrbBjQsa0/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhkmNZ-NoNuSS-7VVUQNK8uSwkEXQjzGirb71jwJWgQZbBXMP6XR7TnJXHNf2yKvWs8FPZniODpwQKiZOGNH_Sf-jmB1svM8sshpugS_UrXgoeJ2N2QFBuw9bhunJ4ElOAPToN2q6wgQiE/s1600-h/image%25255B94%25255D.png)- The certificate store will have the Intermediate Certification Authorities selected by default, click the Next button   
                                        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjp2YCm-lgqG1IwxUVFn_owW4I_tuxGa_rAaARvoPXoNkr59Fl8XzTngbIDrYkmvZubv6X2dkP3yQ3f6UIvdrFEU9RFRS4ijT0JAwmwE80Hd2KL0eKSnzWY5nI5zZJcZjdXdD5WKlehxuY/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiOBIEIjdwCnP5kiUDrb5hyphenhyphen03cvvCpAgOqu5qadKPiUpoxD3Yldxmut-W5RKdsy9bPnokWC8GuSMEaUCiNEsClxpCMd8PLTJ175qsSSbrErXqctXr8M30SBRHXf903mxyR7puVy4qBKa5A/s1600-h/image%25255B98%25255D.png)- Click the Finish button on the Completing the Certificate Import Wizard- In order to make sure all the other machines receive these certificates you should log into all other boxes, open a command prompt, and run the following command;   
                                              
                                            gpupdate /force  
                                              
                                            [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiPFpA9xQYJrlIZYEo6qTPR-ZfSV4OrdvvtEwlexJ49oNIgeRTS_xrbC7e6opv90G6nE-tIg1ZX7hnWTXg2I7apodUeil_h4J8BRgOC9NZjuR3NZtnuZVkSNSsGDEdWE6npLlwjvkf4jV8/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiflyOfoMUo881zH-EnBPyX0eUDQsDUj5wXIjkOC_N5C-biBMV7HArPyGd4KFy6JCo2HfJxydGFtRoZb7KUNW9jXhHo_VhaYOzPngj9Hz9gN_Nrp2sqygAnFrUEj8LFrErUdQ5lpVmHT3c/s1600-h/image%25255B102%25255D.png)

### Create SPN Records for CRM

In order for Kerberos to work correctly Service Principal Name (SPN) records must be set for CRM.

Log in to any machine on the domain using an account with Domain Administrative rights.

- Open a command window- Set the SPN for the FDDN of the server name   
      
    setspn –s http/wap-crm.raw.local wilson\svccrm  
    - The command will check for any existing SPN with the same name and then create the SPN- Set the SPN for the NetBIOS name of the server   
          
        setspn –s http/wap-crm wilson\svccrm  
        - The command will check for any existing SPN with the same name and then create the SPN- Set the SPN for the external DNS name of the CRM website   
              
            setspn –s http/wap-crm.raw.com wilson\svccrm  
            - The command will check for any existing SPN with the same name and then create the SPN

### Set Delegation for CRM

In order for the WAP server to obtain a Kerberos ticket we must allow connection from the WAP server to delegate using the CRM SPNs we set earlier.

- Open the Active Directory Users and Computers snap-in- Click on View in the toolbar and select Advanced Features   
    [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhrMyBwSTua6fES3117aGgZk0GrRCkY1ndEAbziaExKgK1Eqzn3eFRWzThPWipzzrqcjra7n6c_yjPhlEHEMpcmdyuqEdXpBWw-__FEtfnMgBR8Q9S9BLJdWG5I1n6NNj1SbjP-zIqOQo0/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjPdg_Nx020XvrPuchJujMyPbwqbwStSaoKwXXx12YOi7RIa2b0y9fR-qZ8eUBDtsiRcPbdjjWHsg2wQfOQlA3qlwGe84F-Q95016pOpdyK7CLEl8UFciRLd2lTBWMzdvFuZyXC0ziLRAM/s1600-h/image%25255B112%25255D.png)- Find the entry for the WAP-PROXY computer, right click and choose Properties   
      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhna6ALFiSgfOgDP_II1lFkSl_ouAbKDzKrYv5nBpEA-8cUUgatk3Z6QOhymjvInuIhFuDneojU6bCWxrnvAQXRphZuuq5RrA-AcPUb0TZzZT-3PdJq0kYhec5fhnZEiWNrPLv5Dr8ifX0/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiPA-FmGlzB6QwjnGaHjYRHGIpNg-U555XQkqbatJA-RShulLV20-ysRioXrXDo4tt0R2MOqgx_IJuEbRNTsBIp4Yhmql6RR3_6F6BTRIyuR-P2BeKkDhnmK7VBEPG4a4r_2zAA6rqTzpg/s1600-h/image%25255B107%25255D.png)- On the Properties window click the Delegation tab- Choose the option for Trust this computer for delegation to specified services only- Choose the option for Use Kerberos Only   
            [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiTH3MssQzI7ShqhDHrjYD12ia3KH-ewdM82N20wxEz2y7YlbvxMVj_M2s26HoSw8HKFNbBnNMXvdpUB_fn6qWK42WcGBjhLOaWM__xnpzjWyrMtwuSbcvfdKHhcG3tPOoYtHhHa4KOlaQ/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgr43VwDpJa0PSSP5CaRgH5otEJL7YzxHksllycMm71Oftpp85XefvHjp-3oDOoCUx3iejNaSssaL35cTH3JSivXoYsTn5gwLqyPRLdkjRVK6QeC_rcCyVG11Q7z9EekZPa-ATmEaXO4dQ/s1600-h/image%25255B116%25255D.png)- Click the Add button   
              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEji9QayQXkA-MKAOVkosNCZWxbMpnFv8k0VNpEDluHzNbSFUwg8pyrH7XGx5ket1M0EJdoAfwVDqP3T8Ug8sWZLSYVz5RWiI5bhpPspfdB9EGYVi1mufcfokkEtq3YXrs7qntnD0xsK8Uc/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjyFFfuBtUB3M139PXkLfufs2BSTYHum9zGCchqixzXD-fgfxqnuVI-3LAlFnkPVMrAO6dh6lBUt85c1IuiHPDGkGJxxUrWrcEWY5T0grQqPzT_9hpV6s9AgnbT6wne1oWwx2w88OyMwys/s1600-h/image%25255B120%25255D.png)- Click Users or Computers   
                [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgBOXvbzZhA89_H7ltETUMNOlwZwyh9HZ4e8-6w8bKuT2BbcTuudcn7qfdPh7uWK_JDhwWO8GLujEaSdFhQikTo26qNzD3Rh0fhTm5fIgkMFws3vE39elR-5w8-iLZuctl3D09jhc4FM7M/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiAkV5F2DIZeyn0xjMvW3RJrAGqZy9rTS4AgpjrUYYENILVqd4XxfoK5n5-6iXsdwqLOGJxMqt9heIh05cnRoJzJ-i24f_G5XL2L2RXD47Pn0qBZ70dHKJ2d0I1an8nzgjtPVg23kAJnRY/s1600-h/image%25255B124%25255D.png)- Enter the service account running the CRM application pool and click OK- On the Add Services window click Select All and then OK- Click the Expanded checkbox on the Delegation tab and all three of the SPNs added earlier will appear- Click OK to exit the properties for the WAP server

### Configure Users for KCD

In order for KCD to translate the client certificate to an Active Directory account we must update the userPrincipalName for the users within AD to match that of their CAC certificates.

- Open the Active Directory User and Computers snap-in- In the View menu make sure Advanced Features is checked- Right click on a user account and select Properties- Open the Attribute Editor tab, navigate to userPrincipalName and click Edit- Enter the DoD ID Number for the users CAC card followed by @mil and click OK- Click OK on the user properties window

# Configure AD FS Server

### Install Certificate

In this step we will be installing the certificate for the Federation Service URL.

- Copy the certificate to the AD FS server- Open an MMC console- Choose Add/Remove Snap-in… from the File menu- Click Certificates and click Add >   
        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgO4aicK42oCyzoMdxANywOwpz2JrYilhZhFaCsg-wB_-n2TnGvbBemXBEF9gKe6nB2FR0N01sO3Gmzqb4V58j-RQbBLgpy7bMz-AQXVKZ7FzXlctHdC_y8PYzR5hyphenhyphen-z7iZ-Qk7-Z18On8/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhi6joRnKfm6-TlDspD2F_rfPpWIk9B0vni9YykK-Im0aULz0EY5uw_ngOaw7-a2mdJA93m1Z5TJjIu77UdQqMP8GX_E_eUA1sqK-Ob30Nb8ynXP6D7XKd5384EgA9ngq3y_QG4GzC0QiE/s1600-h/image%25255B132%25255D.png)- Choose Computer account and click Next   
          [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgSKKURZK59IM_fOk5nCHHV13zuj1-9tc87woAVRszUcDanBdroXCcL0eEb92AeuL73iUgQXkOaHphyfcx_qxtaPaKySLKQKTzR-sgKwyrG9ozWAInuysYh34CIk99eWFwV3_Syhqr86aM/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgjLahQZzMhi9chwQLmom5dtcIyR3EnvUmAjhZQcr0yEoLr2WTSTM7oGawIbK_iEttfCHcC-QBeR3oHCehI7JLPq63Vjc6MtKlUalTuQUKnICHPmBwP76mJ_ShLCzi946oXk3XABtkFCtg/s1600-h/image%25255B136%25255D.png)- Choose Local Computer and click Finish   
            [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjHUSH9K8DgDoxMYapbc6aupZQwdmvtU8Z-KbFtJzDBURbip63-iDhRrxqJn1oxjVwpplxO-hsHWLNDrAuyjChxsCnNv2OfXqmDEWam1SzrS2q1MXPIR4LuCkZ6SFkFJt7L9bH6Jzoe5Tk/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg-9aW9V9YUuWEoWsNOLDprUkwHPMKKIZQTesUmhRDW4rc1Gm6HsjJSKamirHfjGXFS9dRuw4wjRlMfWxWMLZ12OBUA6h0uq9w7n4dfDfgf2me2UVUOOKE3Snq4G7BcVpD1mP0QwNY3MH8/s1600-h/image%25255B140%25255D.png)- Expand the Personal folder and select the Certificates folder- Right click on the Certificates folder and select All Tasks -> Import…   
                [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiOBuKQOYakmTcpFP2vo3kZJ1KHOBBckpUSs2azsW0tnBQ2a5_98AhvA_c-PQHZakBRe-Qulab4O97aWwNS8GZUb7nCaUhAH8zOGUXbFlk6STHzoMkitd0TClwHT1wjRrjaCuDN8iDa1Y8/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgu8crD_Dg_IVlSxPc1CqkUzLcgs9pFHGV4WTmZql5rqNrTL58aLWPeP9veD4f6KF7gSnh7YIOzIVs9H4z7qtmLpYNaYFsgS-Vye0r3pq5dNMaUU1khoQEJyLCvH4SVNyOF9QFW2iKMb5M/s1600-h/image%25255B144%25255D.png)- Choose the certificate for your external URL and click Next- Enter the password for the private key and also mark this key as exportable then click Next   
                    [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiVdZbffkiKaPmam8jZSISn1LDE6wizKPdNxwLbTWckwZvtb0D8Bv5pP-5ZZOuAWl2pXK_m3Fnkyb7kujYJfBAdhNGUxI0ZVU3LiRvvgzMJhK4Y8gx56e1MBlNOVoniYB5Hhtdes8f9TaE/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgacSl6I5GoYIBiOE3HcpZe2Oa2mqllOJs_GO6nG5TuJA1tWnJe2tNn3CSl2Cdma4hmmDIJxgO-BAZ4dkMuX21zKzspeoZN6n2a4JJvATWbgpzpp7YSAQglU7I8EoX6w2GngzaFWcfp3xU/s1600-h/image%25255B148%25255D.png)- Leave the default store of Personal on the Certificate Store page and click Next   
                      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgiVPu8hzdhK7Uv06dqYTXNWr6CkCnA1re1otEmy0RLNrP2fYm2l9kvmhyphenhyphenwx1doFrYZz0rPVuH4oLUMYIbqJxhPsw11Y6m2Mnh-l-bB7MncOp6-yiBOnyjbbYsPh1ZaLqxVGHgY7e_h_oU/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjYFi00YV4novy3gCj1Twz0SABMMtQ-lmiFGIiZrO-yXCPajfdnxwskZFaFhfxH0NvCic-rJnQDiSfVgZMeVL4dXKmsN0L6ksU3elgJqxUxLEA9KpPyd81qBwDNnqjvbNjA6T0qxU7iIA4/s1600-h/image%25255B152%25255D.png)- Click the Finish button

### Add Roles and Features

Using the Add Roles and Features Wizard we will add the AD FS role.

- Login into WAP-ADFS with an account having Active Directory domain administrator permissions.- Open the Add Roles and Features Wizard and click next until you get to the Server Roles page- On the Server Roles page select the Active Directory Federation Services role and click Next   
      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgDeKJ7uaKuL5LiaBOSHq8Qjp5DnGYPtjOeSG65XSd4s3sjRQSiDShTkF_KDgmgKwlXricT0OdnOtwofUph0DknIGAriaYuaZVXFFaWUrkx-OMkSA6W3G_dMpmOimKDeCJJC6yaE4yA_RE/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgrLe6u3ayCtxv8PGrcOuc7X6NWTkJZdzNSd88wtXeK98xd3bJkJ9tin01bXygkd2M5yFvmJjXChQslg-z_OJSxYJLE8N4_qFMf9KbJF565H5kTm-qackG145iS_oC4mXuZ1zUwx6LZ8OM/s1600-h/image%25255B156%25255D.png)- Click Next on the Features page   
        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj5zm3x8DXO2zbi5BIfKsDkDQgJtvUpnnrZJw79fpQ37ZRp-6aInquVMiy2wsoxWAPEtZvcWZZ7nrEHjJFsyeKQ7WgE280ub_hi-5rnjUJ43sgyQAHU1_fpRbH8Xfo81X5Jl6qgkG890t4/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi4IWRjzH6SnkGYJ49kkQq72amxw4qaG97umdyJij9LeelkOyalg8OnFCTVvrvVYVdKkAei_IvcJiLPrITzqYz1R9DxnousbI_MvhJ9vasnym7YhY7Mwuog18NK5hOS_NhQEiHYPiLtOpA/s1600-h/image%25255B160%25255D.png)- Click Next on the AD FS page   
          [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjSMAzvC9i_nb0dnefeqUNbVeRClLm3GgJv7sQWOZkhHKgyqAWnAkmNuzsodfz-egpyAYPMpv2xYbD9e_klsudbAWOPQUKvRBLCb3sUQH8KvUgg-09PrXqBr8lToMUMVHASrEFwN-kQVLE/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgut9u3zkeEmaaSPEB7p2gOuHNdJiUU7N-NMc9lItjFVxbe9MziYF8pR2ugLZiigpkMFuNzENhkvtoud6m46rZp9cQfw7k1YesFBg7vDfHTB-1JW9KbTQHTfOgsTqt7ZuORHsUp4l0hnnQ/s1600-h/image%25255B164%25255D.png)- Check the Restart the destination server automatically if required check box on the Confirmation page and click Install   
            [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj-9mQg42JuUjBGSy8Xvzl5Dcmk2zqJ4WNKtTThYS2oeKGp1BamYoVOklxPTBTmu3Cp_uGnRqy-Ohd0XVJPHCMHCvAJd3ay_ubCZZWSSsslP-S7bXoTgc7i0mC5gJQj4E1bD-HZv6YLUdI/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgALgZ4gPRLpq1sqs_VWs0tse60aoiKmYGTk2gruAOhtraNXHCw0wirylK7z0y6M9tfmOxxS7HgBj0ePhICvwQuQbZwvVmlS1W1AtG2HOzgakvlf36c2ejTUiOXGG2-x4rQrYPC7cMVu2s/s1600-h/image%25255B168%25255D.png)- The install will begin and the server will reboot when completed- After the server has rebooted continue the configuration for the AD FS service   
                [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjJhz5BJUnQx6XN444m2CnkRRCu7Vn0NbahIn6Ta1ZDeq9x5X-2nNRi4aRMOHf9MI-NS2WBU0LcwB8gF61oFTjpohS_6D3SrSeV1zRmOG6aXD_YCO2vFerjEdMQQIfj2SxKbcMMBPAXczo/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgM_cPZx_PYzKS1PAUQ7J3M2g5bGKWh5RGRc_pggl9Pg9uubOcwYX0Dii1ihEAMZk5boqhu6Iv2_Z5keV_x_Sl-5ea8GuCX8tB22PSETqQHEI2J_sbm6DIzb86rDywUaG4JG8Jk_ioA6HA/s1600-h/image%25255B172%25255D.png)- Since this is the first AD FS server in the environment we will be leaving the default option and clicking Next on the Welcome screen   
                  [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiQtTKyCRMOn5MOL3nJ591hfNphNeeNVsaRN8wHqKS690olCeQk9bXKaMjktANXVxKMbhoNfwmg3C2bvCcWp1lR0Rf9uBmWRo6i4Xfcbkf8X60y-cxiBh9tjHHammhXAOdp2Xz9zd07ef8/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiHgI1qzETbXOOv4N0KfuxpQzWb0cYUe94Zs7iqHbENN5Qr9Kin3XzsUfcBJy_HDkpWU4yUJ_BqbIalF-8-UMkpPR5sm3wlTMOb2buAXUMYx7cZWNcVyWQJX9OFvTzLC84fb01a03LwC7M/s1600-h/image%25255B176%25255D.png)- On the Connect to AD DS page you can leave the current user selected if you logged in with a user who has Active Directory administrative rights, otherwise change it to a user who does.  (this account will only be used for setup purposed and will not be used to run the AD FS services.)- Select the public certificate you installed earlier and enter the federation service name which should match the name on the certificate.  You can enter whatever you like for the Federation Service Display Name- On the Specify Service Account page you can create a new managed service account.  This account will be given all the rights it needs to run AD FS- On the Specify Database page select the Create a database on this server using Windows Internal Database if this will be the only AD FS machine within the network.  Otherwise if you plan on having multiple AD FS machine you will need to specify a SQL server to host the database, this is not covered in this guide. Click Next    
                          [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj5uuULkz02jaGyvScoPqsdNU-uo9N9vR7XptCUhsEr4LHCLVLBmjCHhIDzQewixXLfLczIELOCljtvDBbXsT-mj-Rgww9Gz4vbuUqMO8fbw3W_JN1na4rpr0aOm3xVVnAfqFqFyBXBQLg/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjEau8L4kdhrCsqrLxJVYmzqByTqxnWzgobtLjiu9PsbVntpYgOUBuD7q8_mS0FL52TacHUTO_Z2GMMMxt0RrKbTj3Cq6Wcp99nq7pZm7emj2HWc2FeO3tG_zI9Okx2svwfiW58W-Log8c/s1600-h/image%25255B180%25255D.png)- On the Review Options page click the next button- After the Pre-requisites check has completed click Configure   
                              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgYVLpfbautzjKn7TagfxWNQyEZzJHrKylbz94xPmZ0dX2KF0oz0zSCEYzksKCZLpVeikO6hO0D1YVq4kZKAJDY8VaKK81HeyofVFUSW88ix6D_ixKWnFdTR36tXzDUxEyIT0ybQWGIWwg/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEip8XVPJ0KlHEP-8Xf5ENampITxvaZUV2pc7syj88OT0Git-QP-Tkp6IJkPm0XSjA03sz58I_Az1o-4tyitEEM_a6xYbyNq7UZFc7zcvoLl9GQPcPwWCJSqYUtGNN9vbnle0_XBmuXwW74/s1600-h/image%25255B185%25255D.png)- The installation will begin    
                                [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhLE8ndPcVDV7DD2wMlIPODQc_PB9NuNTzXVibPcKgmQcxeNszWdRWQkhbZpHu_s1VzpaqYb2xPvqa9zi7k_StAMLzCI1MpvHJYAILgWHHhWIMv8a_Ik_V3kzgEWJvG8q7owlS-IiRpcow/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgauLqF5pLy_FbxSXKuCA83i5iPNDByMISr4T91gSFIDZ1Yspe8TVfx8WND4Ga5nEW_HtNWPd7X4bLyuQKiR-h2yJB76CggXiw7S7gL21bHkAVfkj0R0AofokVkwDAp9Hbv35hCWmKAzP8/s1600-h/image%25255B189%25255D.png)- After the installation has completed click Close  
                                  [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhQOKw6nCGSFXnq5krVeCYM201eeNEcJU7uChsYpRKANgyNI5rdQyXhySjkP173OEAuMnrczalU1Vg8gpWrj4lF977oxc4iflJAsYstoQtTgshQ_rZxN_v5XXPz86l5IdxguKWNtqVxESQ/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiowVOtzYw3SzF4DMU9FAizCiS_zHRHV1NpY3f21iEkQdQMShT_2rbPVkt8Ovj-SqlkCciAt7esBRP_OWiQXoud0p5i2POvE_D4cSwHOP89naXI_QAHQt5O57cYU7gWy5SWFATSpFY5Mqg/s1600-h/image%25255B193%25255D.png)

### Add CRM as Non-Claims Aware Relying Party

- Open the AD FS Management snap-in- Expand Trust Relationships and select the Relying Party Trusts folder- Click Add Non-Claims-Aware Relying Party Trust… in the Actions menu    
      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg2xYhB8ikyYJ9xpov3IaI31E144wKZuR9tPkCGRKd8UB1NY2oG-dB9A7zkhKmH6xYyACh7BWBnmoMjANUlJGBb3dK8ntfyNegFdVrr__jneR7_HnMwcBJ8cBArbGAuES_Xk1oPObEq5-k/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiAPN230Ra2r2fLnMuEt541OekcvqFng-0W_3stuF_eyai1qyaAUzQX_AAnds4dItgw9vOV5wCxqkTjdMKJ0wRlfm0eFAZD-PVzZFHu4KvYfRczRaGPE6xDgHxZvlPlo-HQhcLITSnrS20/s1600-h/image%25255B197%25255D.png)- Click Start button on the Welcome screen- Enter any display name you like and click the Next button- Enter the external URL of the CRM website and click the Add button- Click the Next button- Leave the default values for not configuring multi-factor authentication and click Next- Click Next on the Ready to Add Trust page- Make sure the Open the Edit Issuance Authority Rules dialog checkbox is checked and select Close- On the Edit Claims Rule dialog click the Add Rule… button    
                      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi-ONlSaot0__N8OidiIzQ_Gr3w-Hcn_w5FPvdsWUzZ2r1al2AffXNVxOHo8S3ojKKuem4k_e9K6PaNu-3A6iVN29VZSBT_P-r21UDuAoeBZr_FNaosTttLAnFXmC06nVX5N8LBkWn8WNU/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEir6kUDGaMfuXENyIbrpgFTaW3saNaexTMnJ7eytcWyXNzm_aApCil34IpqcQLLVRowKy13krvYbVTJrkpyS20CZ86wbHv-HAm48e9eGEucSFzqS0nW5N0v6ZFd1unGF84-K4GoVQNj4PI/s1600-h/image%25255B201%25255D.png)- In the Claim rule template select Permit All Users and click Next    
                        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgzq0QQvxu6YsIibeK1UDm62QrNX-cbcB7frpL_0yBzDgF2DqRKHplvmq_YOX9oCneXhl9L14z4rQyIXnCwtw2OUCmhE4G05k53PZFkJpW3pIyaYx5IlVKNS51UUQIm5mWDtElWvCYt5_o/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjBj0zkyEqaBlYnfOgl1HmUXCtNfs9vX1TSBYzU8F0nC6p4bQCYjurxpTLXB9Uh6cqVvSFDFna5pRSToNpUwYVVxlEuyxWWjlOtNkovqHmMaSkFGODPVnPPvEiRFata7En9kD08QImRpv8/s1600-h/image%25255B205%25255D.png)- Click Finish- Click Ok on the Edit Claim Rules for CRM Dialog  
                            [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgSzEow4Fck4f9LjAPQas-YsTVSHi0c71fhGx-AgEYbVBQqn-bkxZssVWGwhIdsNBqbwYIGec8vLvzY8WyG1vxUuYzjuJIoNVvr7-ZO_IBTritePDMDxouPAFmfNvyerwI1Oabh2J8K7ZA/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgggKE62cYnQCHHrcqP-yHv2EjAK6BTGqlzdEKDpmgwrKC3wjAMhKdygxCOMnVHGK_mCOoZV2nlFQr9fPi-Ds_VI6teq5kCWaURJzyk_BfOgcVkoP0XMWeMN7uGG7Eg6XOK3JFwyTc5J40/s1600-h/image%25255B209%25255D.png)

### Update Authentication Policy

In order to accept only client certificates updates will be completed on the global AD FS authentication settings.

- Open the AD FS Management snap-in- Click on the Authentication Policies folder- Click on Edit Global Primary Authentication.. in the Actions menu   
      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjgzeudVSK5qLE9SgoECRXZTKBB2l0kdo5blrxeuNJEpO3uYT4wnSfxlcO1oLh3plDZXqk4ve7KaH9OQzBEushwsJSHjbjeP3eT8X6vBDD9giWY0rxh5U9rvO5tiNn17SZUAyOawpx5vB8/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgbpQfW_me43-26u6ywxIupXeGKZel0WZ1IXyZ0ZMOewDSJK3MpV7OXoZaPOe_Q9Ob7m0W9lKYhE6tpR28cAheNldwQVp4-I0d6gOcHJK8rlqSfImsNTBs2dp68cM7j1Nk0ClX7Xwf5WN0/s1600-h/image%25255B213%25255D.png)- In the Extranet settings un-check Forms Authentication and check Certificate Authentication, then click OK  
        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgf7BJysl0x0OLfGPfs42eo6CaW7OO7OvOIzAE2moC64_q_fvAkFoipZ6Pq-j5NF_gdkWmrxS8RH-abRtC-ziLuCcaGhFvq6FSs18nJc_CssxxavxnQG4ZADCh0LJRtzTQTVgcqon27k4w/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEityte8C-v6TcCsE0Viq1c3OyfjS5H3-3uF0BMjjl_eJaOgpnww8gIxEggVTNCUgFTrZFeLCLVDutK87dDgzfUKFrEn1zjX2T4-ID9G-cobMN9ZiAfsVtTq2KKATc1GWHgitVm8uJ5hksA/s1600-h/image%25255B217%25255D.png)

### Test AD FS Service

This will test if the AD FS server is running and processing requests

- Open browser on AD FS server- Enter the following URL, https://wap-fs.raw.com/adfs/fs/federationserverservice.asmx  
    Note: make sure to replace wap-fs.raw.com with your federation service url- The browser should show and XML response from the server

# Configure WAP Server

### Add Roles and Features

- Open the Add Roles and Features Wizard and click next until you get to the Server Roles page- On the Server Roles page select the Remote Access role and click Next    
    [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhvlGNfxCuEJjULdT6IU0blJf1g9XRZjHC0dcll4oGa8ov0zsoZzKJeBmNMXLc7tXbBfhW7-AjsrdI5DKLuOupYGR7IYSxs1pMFu91MJx6h03z2y6SPiISvrxsZwwlYFP0WrtOOJ_lanHU/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgHA751ftEgsviBfK_2jKA53_knZx_ygZzevPcYUu3ItM7lbBwwfCK9GWqrQqUZZu-wF7OTYCiyzPyVQe-x23rqVb8L0MTEyPp7yM2t9lNgNm84JHt9bk0Z_EN9UNW_hQadv3g4YkxxAhk/s1600-h/image%25255B221%25255D.png)- Click Next on the Features screen- On the Role Services page for Remote Access choose Web Application Proxy    
        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiLA-3RhDku9MLn4WddajR1ADrAqepLV445wOGBcJqinPwywh6XZipPPcm9eriUY0xYQHvzW5vh2ebugKcrSlTpHn53-xb7_6H2yyjU_HEAuoNt5USm6981j5TPNOXhkEdh95j8tjEx3P0/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEigFAzjckyUYaEmpU1KqK-Bs0XMpBzbj08-2spHs3mE3zoDWjwCxT0Q1iszfSCX1Yu2FTITSSirBHkzL_BLvaWwQJdBBK85aoRQeTBQ-bJOguUJiLV7HkfwS94ZxscB8WIs6NC_eswrGzY/s1600-h/image%25255B225%25255D.png)- Click Add features if prompted to add additional Remote Server Administration Tools    
          [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgG262qnNmON4MQ6eopD96VN7C0VGlq7xqk4zeEH8es4YfFNhj0iGZjTNPktfyXoN6SsBDFHMW8vOW0rSWq5FCi3vkRLYbgWc7MgoKl28iDoEK7MdjmcmhAAXzaojyEcDp7hyeK14jnbUA/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjIOkUqL5D9HTi3Jr6w1LwriMsLivPKL5H5oG2OAh63SfGT3bkeRnWWgCWEVyOTILVKLqfvT4ycav0x2ftrUaudLcIjpLvTzb-_hbZ64GMFlYljH7mkIEpzxolzFWPrnTyy8AimzVdnl9E/s1600-h/image%25255B229%25255D.png)- Click Next on the Select role services window- On the Confirm installation selections page check the Restart the destination server automatically checkbox and click Install  
              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgMoQQpFkJaXJS8dPDjK18rjHX0xoW6bstTkEy50QsShVjaiOftZAjT7u1D8zh0Jl1B2b_sLTXAbY9rvoBdIdX-Hf5fGiamQOH6u-bNkfmk3cdaaA5Lugb1Lb0jYaYYcGa05P9j58K0Mgc/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgxDaxhQy-7Qsz5VmSCnFES6zfLVtulBJVhMVzxYfZ_oquaNkmbx3_Y9_v-_NZfpJTmZr4nPWG-WyAjHDkrckJlUgSNx12JMpSvUQJjekhYF5Up5lrFc3jDxQ-wjFInsEj61yH1S2Wxl9k/s1600-h/image%25255B233%25255D.png)

### Install Certificates

The WAP server will be the forward facing server that clients will be hitting, because of this any certificate which will be used for external URLs will need to be installed on this machine.  These certificates should contain the private key.

- Open an MMC console- Choose Add/Remove Snap-in… from the File menu- Click Certificates and click Add >    
      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjNrg5vLBRtIPxDmdjj2x7xqzqQBOCy6xmvBySGmD-o6JX5klXkGnXi5SeMkWf_gwq0u6Pk4L69cxHEdwSrMmbA5QLQ16S_TxxxaS3-ZOZ3yTwg1cX0Z-2-3RahploDM1HH0JNt3ph-0NM/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhEfvODBA4Qc7a1yFsQc8-vh9B7JB2IhcM2k99OSt4_yT0IOG2ZpJnrHHYu102Y8Q1xgAtVl75A-tg8sxNXzQHJEGLyAFlFR9awj60rq6wHGjqCyp6mflq-swxWkkXssRpXmqphp7DjBOo/s1600-h/image%25255B237%25255D.png)- Choose Computer account and click Next    
        [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjYA2KAAEGz2ZY7aP2rNJlkuYcpwi_50v0AmXiDSInJRqdcG6EHM9U2JcdcTXe46vqLpyb3NtD1N5edc9K-4D0fVz8UDLckkffIg63moqSVpLfQvXVOEmnmNekgNcmrucaBfDtLqq0Tdf8/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiNUaSkKdzysfjnuzMAS70V-Z56Bws4BPtmihj0rZQPkQ53RhWsZuZaGtKt8RSprXUTR77bANOJ1-CYv2IRKOZJ0wWgfpsk7P_pzYjnB3eziCgFwAmwMIgLJLRaq65CmQmtCPTZh68kpVM/s1600-h/image%25255B241%25255D.png)- Choose Local Computer and click Finish    
          [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg6SADNjZgzGsKbQ0T1UEfckmHMTiwCTw4BhtgTsLHyYLwiRz9ei9auuMRRURaZSyMtqNrnjrqFKiPgmNVAjCxBqYtMV62IMS-wlpRQ3xbOEzTvlvrMtFjkui4iqJ9-LiZJb8Tf84IHTd8/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi2UZxyuJgw89kEIZ8hnKRgZSmmbxVhK6c2Dx1L56cH86SjpFzWQID_hRs82pNl_RAV4r8IqLi_CJZF4yiLyoem3uBW9NUYbIxDakBoI-hBqGBgEwICUqZshvWVO0fOOQHVKSN1Rm60Hy4/s1600-h/image%25255B245%25255D.png)- Expand the Personal folder and select the Certificates folder- Right click on the Certificates folder and select All Tasks -> Import…    
              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiG_bOAOYI0D5rbIYwoHCGPSTh4MwX9s9piO7NvSLnxWPBTG-nrPLqaL9ofwMBJM9hmcLDg1t1HwK1Pb_jLVPzF0Hmtec1Y9JkNjFVhExEhFxwN9PTmt4-ibRc7tU3BannWpzNnTzCFwMM/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiGiV4V4l1L3D57XW_-N-g_aCwAWL2mi8IcK1XZrCIDk4O0akzfLwy01xWZN-eiPfryW_i7oxRH577IVUGf9IlY7028MIT3YY4papuDKNpgZqgoK8WH1Oe0PULEMuHaflBTDIKAwf7sA9Q/s1600-h/image%25255B249%25255D.png)- Choose the certificate for your external URL and click Next- Enter the password for the private key and also mark this key as exportable then click Next    
                  [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjsVymKskPb6Bp5Mb8ZQmvuOmFZG7jLrQzCqxlpT2Sw-KLnvj7lhsgwva6K_mdGOrPIScXdTSFSjU4I9nqmoTRyegIvu-L6Ohj3kjM76SJw3FQk7cBQQjx9A-1aKwA8CMcuRtwDuFAOVwE/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjLj_ARdkob5g8hq95aNaC5mABNtlBaKN2xR0c6_FyOgAgcQCsn0I4ymUzk_1JI39b81srRQJAZ1SjuomXCnLtqQBQMxCfbcyFAOAyI-cWsdvQ_ajcJfgxA-Gp1PGI6CM1r8PPykcz-HJY/s1600-h/image%25255B253%25255D.png)- Leave the default store of Personal on the Certificate Store page and click Next    
                    [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj7GQFjWA2UFW-PDOij1fipUJlhm7izSAY0Wb0exxXtTd59P8tB_M00ae-BvHh137WusgdVsjOUFFauDc-rDVAzddx-t8ARVJYn4ZfBnLDN1ohfmPMAZI5ipt37TdYRKpyK7nRzKhcVHtk/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjdQ4uzJ3HhW0n2YwitG3HwUfHoHx1jDPQmi5aK5O2WuMb5hWc2GBc99gHk_pLxUINjM6w9GlHIaPizR_19UygWxiSKzzYGVaPj63zsdVpKHJ6X7c-9PKTpverMltGLTxmCKGlg_vPO6UE/s1600-h/image%25255B257%25255D.png)- Click the Finish button

### DNS Host File Entry

Based upon our sample setup our WAP server is located in a DMZ without access to the internal DNS server.  Because of this we will be using host file entries to map the external URLs from the WAP machine to the internal address of the machines actually hosting the services.

- Open Explorer and navigate to C:\Windows\System32\drivers\etc    
  [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhK0qEW2tYGFXhnveekb5K7G_cKEYBnXguygFCyux2ZJIQUuW9EB2ZE1VdZFl2Qj7SK7uwGg90-xebFuvJkWqFr_zpThOL36fvQUN15naMTQuouBk67ZFeXpBvQe9-iC2cz7zgJBD42vHM/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhWCbXA9JiNpwFj9tPR1S0eI-gtjfH0NGqVO-SznIsgm9mZvVWZ7_sOwqGzW_YGZuyTRTtwoyJlqPZOBXg3L-naKKEyk55D2Yj05suoRrsPyJ8EyJ4rLYzvnviTXGSZVs1ILV_RWCyRt1g/s1600-h/image%25255B261%25255D.png)- Open the hosts file using notepad- Create entries for the two internal machines which will be hosting AD FS and CRM and the external URLs which are going to be used

### Configure WAP

- Open the Web Application Proxy Wizard configuration    
  [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgRnEae1DLQIsltn91W9oQ0nqRobaj-s1vFgN0nnOhPZh9tCy0x7AJEs9KoqcnwvOzRcccj7qoLkfU0M4dLqDGSRdV-uMXKToA3jdqii8VpAYDpElr13gzUEiVSebxVllwABIhlcIQLAs0/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhPlgMCBztWKdDNRPl9Nx-_AGly1gBdht9PdbBQTp800IFZ4O9wOsczkfe3zPv6k4V150_K_WR4aI9KGcIy1EcC9utqBjjN09qKBeM3s07AlgI_J7CB_cQ7MJwDhd471i3oqtpxL9biubY/s1600-h/image%25255B265%25255D.png)- On the Welcome screen click Next- Enter the federation service name you used during the AD FS setup and enter the information for a local service account on the ADFS box that has local administrative rights- Select the certificate which is also being used by the AD FS service- On the confirmation page click Configure- After the configuration has completed click Close- After configuration the Remote Access Management Console will be displayed    
              [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgDEbhPZJvXy_5ISGi7PX4RcQQlCnvmRmQi3otZX5LqoDEiw29zb4Fy9wbsJYrBCj9zsiw4WNE0KRZWStN6NeFbh2wOIxrcUjkxVlAjnMyX-VTanq5rwIEgBn_ltb0yMwnREYUOPi3vNzw/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjzdkTTFs496_UrUBUWF2EkBDGQTJREsXqap0hbk7govJQcPc_niBaprm58ABvU5X62PsRjVHTYc-z7qpls1J9XpHR7QPaVkqDV2-ylKCLfM37pqf9gtD1W98AQYUH8hZzi7MOrMShTgyc/s1600-h/image%25255B269%25255D.png)- Select Publish from the Tasks menu    
                [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEje5XBDryDUaXl47K6ra4M7O8qaan6mt-xZxTZrLw9DuIGttmbGQHyjLg01wvRPVRTWxO8iBG1VbRG5gBtKBCGJOpP58m1S4C8Wm9X2YuHLFV7epXFQv0jTgcZcb7zIgo1dhuPoIOSwQ_g/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjFDKz6n1BDl5BXnYehSBPPlzhyphenhyphenjDRS_GVMnoK8aN45XzLYIzv_5-5hdA2IN9CB-UUYxsltrNkp_pWzaF3fgVY1xsGPI_zzmg7Q-whFksIxzVLMRNjkFGWKOtyCI5GOgavrm6G1I1c3cg0/s1600-h/image%25255B273%25255D.png)- On the Welcome Screen click Next- Choose Active Directory Federation Service as the pre-authentication method and click Next    
                    [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiVFxKhWh_-OBAhV44PZ1IRsqeAze84Lqyh6Jslq1DdnGqRxdLE2eFvNOvulqntAhX1_SiB2vs3_mNC59BvczbpV-kCv8FCIGUCpsK5D7VIjKtG4XZN8PJhDjvK_8-cAfYS5uuybco8AjI/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEio5W-zHuI1WaopsUzylq7xwUTS54JCIAkhvtKqydQIZFlQv_4hKtbj-Gzaf4moX0JdRrhGUDW1ZSdOeSQ6y7eJQqs0WMAI4-w1s0KP7y5wFXH1BuNBsYsE_b17dlj85stcybGfn6hCdBo/s1600-h/image%25255B277%25255D.png)- Select the Relaying Party we created during the AD FS setup for CRM and click Next    
                      [![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiT7yGytxuf9Q6F7_YNoBHx7KSjtlDvzkDlLOUglgDcCZt0gRvHxYZFTOzslQip-vhBOE-kOg_R-OGkFUryQlhP3Azt08JrgVu2Xa_dI9RuUkDtmOFz61NhEvQ988WPn-d614qLd8eP_Y4/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgECNNNWpcFmMYl3W1zadvhsFtu6WL85u87pN8mewbW119tZpv-iZbNZgBcfVq2i0W_AXnf1E-yWL4YQ6k870T7CaqkjnZeaE3NaBJ9nLik6lnhNSqRRNiRGvESjUMaZkoGfhIXUsltmb8/s1600-h/image%25255B281%25255D.png)- Enter information for the published website.  The name can be whatever you like- On the Confirmation screen click Publish- After the web application has been published click Close

# Client Certificate Revocation (Development Environment)

On a production environment Tumbleweed or another service providing CRL should be installed and configured.  Within a development environment where Tumbleweed is not available disabling CRL checking can be done to allow for testing.  Disabling CRL checking is not something you would ever want to do in a production environment since it would negate much of the security that certificates provide.

- Log into the Web Application Proxy machine- Open a command window and enter the following command and press Enter  
      
    netsh http show sslcert  
    - Find the Hostname:port entry ending in 49443- Run the following command, replace << Hostname:port >> with the Hostname:port value from your environment  
          
        netsh http delete sslcert hostnameport=<>  
        - Run the following command, replace all << >> with the related items from your system  
            
          netsh http add sslcert hostnameport=<> certhash=<> appid=<> certstorename=My verifyclientcertrevocation=disable ClientCertNegotiation=enable
