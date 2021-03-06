---
layout: post
title: Set up CRM 4.0 Authentication in ISA Server
date: '2009-08-21T16:11:00.003-04:00'
author: Rick Wilson
tags:
- CRM 4.0
modified_time: '2009-09-01T17:58:40.460-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-8068224102516944631
blogger_orig_url: https://www.richardawilson.com/2009/08/set-up-crm-40-authentication-in-isa.html
---

So you have CRM 4.0 and ISA server. You also want to use the IFD (Internet Facing Deployment) feature of CRM. Well here is what you need to know. This information helped me and I will update and add to it soon....

**Taken from original posting**: [http://forums.microsoft.com/Dynamics/ShowPost.aspx?PostID=2915997&SiteID=27](http://forums.microsoft.com/Dynamics/ShowPost.aspx?PostID=2915997&amp;SiteID=27)

1. Enable just Basic HTTP Authentication on the Web Listener in ISA
2. In the Authentication tab of the Firewall Policy for the CRM, select "No authentication, but client may authenticate directly".
3. In the To tab of the Firewall Policy for the CRM, make sure "Foreward original host header" and "Requests appear to come from the original client" is selected.
4. In the Users tab of the Firewall Policy for the CRM, make sure it is "All Users" Instead of "All Authenticated Users" (CRUCUAL STEP)
5. Apply the settings in ISA.
6. Now go to "Internet Settings" on the client computer, and navigate to the security tab.
7. Click custom level on the trusted site, and scroll to the very bottom and select “Automatic logon with current user name and password”.
8. Add the CRM url to the trusted sites without the prefix (aka. not [http://crm.company.com](http://crm.company.com/) and just crm.company.com).
9. Navigate to [http://crm.company.com](http://crm.company.com/) and type in your login credentials. AND CLICK REMEBER PASSWORD.
10. Run the configuration wizard, and it should work

Hope this helps, I was struggling with this for days and nights.

E-mail me at bkootnekoff@gmail.com This e-mail address is being protected from spambots. You need JavaScript enabled to view it if you guys run into any more issues.

Brennan

