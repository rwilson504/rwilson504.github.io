---
title: "ADFS 2.1 &amp; 3.0 Config Debug Tracing"
description: "1.…"
pubDate: 2015-08-12
updatedDate: 2015-08-20
heroImage: "/heroes/adfs-21-30-config-debug-tracing.png"
heroImageAlt: "ADFS2.13.0Tracing"
category: power-apps
tags:
  - "adfs"
  - "adfs-2-1"
  - "adfs-3"
draft: false
originalBloggerUrl: /2015/08/adfs-21-30-config-debug-tracing.html
---

1. Run CMD as Administrator- WEVTUTIL sl "AD FS Tracing/Debug" /l:5- Open the file “C:\Windows\ADFS\Microsoft.IdentityServer.Servicehost.exe.config”- Find the following sections shown in the image  
         - Update the switchValues for **Microsoft.IdentityModel** and **System.ServiceModel** to **Verbose** instead of Off.  Also remove the comments from around the **system.serviceModel** section.  
           [![ADFS2.13.0TracingDone](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjisVxDM4HKCgpqOAr5Eu_9o9rB3sYyQsSwYoBJlNbV8aL2a5qI077DX8VXh59IIhZdk0rkkmJH5CmSelAJT597jQxqMXIeiyRS4JH9chXYaszdTg8L6r4TYDomdxcISTneq1PAAm8TmsA/?imgmax=800 "ADFS2.13.0TracingDone")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhdXJO9_OtiC9PFre-J0EnOIdogdrR3LnwdFq3lPzhnznYTXDtlwc-r607RPukR2kDyr7i5xdL9plDBIEI_ZJvgXfLdFLI3gK1plurg4WgJOo37E70wNCpnfL4MrWX4ltKwY5ZgtLZajis/s1600-h/ADFS2.13.0TracingDone%25255B4%25255D.png)- Open Event Viewer.- To open Event Viewer, click **Start**, point to **Programs**, point to **Administrative Tools**, and then click **Event Viewer**.- On the **View** menu, click **Show Analytic and Debug Logs**.- In the console tree, expand **Applications and Services Logs**, expand **AD FS Tracing**, and then click **Debug**.- In the **Actions** pane, click **Enable Log**.- Tracing for AD FS is now enabled.- Restart the **Active Directory FederationServices** windows service.- Open the AD FS Management tool- Right click on the **Service** folder and select **Edit Federation Service Properties…**  
                             [![ADFS Events](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjLm-H8UaDeWTmRwRK_-_Zmg35sCxwono1qEuEamTe4N-NZPvBbwyX7gGlBQjY81km4KrI6OjlI6fnRf-t_fV9v1n19leS60wGVh-fx0BTN7FkvkQGJebTpMpGXVo2tJd5A-vRePlfOipU/?imgmax=800 "ADFS Events")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhuR7YHx69K5NyU3r8EoNjbiXPOk45AFKT7nL_1o-SY928DJjsJ8oMZWXZr8K6KsyVOCr88tNPyBpEVSKNk3H0EDp2moi6QsI4BBp6zBq1qA_1xIf90IRPWRY0Kv8aqMI5WpHQD74XmoKo/s1600-h/ADFS%252520Events%25255B3%25255D.png)- Select the Events tab and select all the checkboxes to make sure all errors will be displayed in the event log.  
                               [![ADFS Events 2](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj2KjtBfTK1L3mclVLxCjdv6tZ3I1tK4sL9VFbEYBnXlSaFSnHCBMaUP_SidnNTXLEArdgA60B761gtJ-uYn42dPYXaKotvmL2GkdSK6s8KwDa1QjATf_URlcp9x4PFkEesw0jlr1r_9EU/?imgmax=800 "ADFS Events 2")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhZiaSin4b-0l-eMzOwhcfvSp1Hhmpb-nFHH2KMzASFdxB6wZPZiM2cwj96e-7TrsoaA3thcRMQeJ51WVepcg3P9pVMbkQvX55eI8f4FimDLWHmKVrGiG2iIHc1urY7_rQfHQZCW-kgu1A/s1600-h/ADFS%252520Events%2525202%25255B3%25255D.png)
