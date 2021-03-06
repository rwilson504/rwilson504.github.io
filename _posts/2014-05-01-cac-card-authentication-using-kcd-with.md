---
layout: post
title: CAC Card Authentication Using KCD With CRM 2011 and TMG
date: '2014-05-01T13:10:00.000-04:00'
author: Rick Wilson
tags:
- CRM 2011
- Firewall
- CAC
- Kerberos
- Authentication
modified_time: '2014-06-05T15:00:59.320-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-2936037506110826086
blogger_orig_url: https://www.richardawilson.com/2014/05/cac-card-authentication-using-kcd-with.html
---


CRM

- Allow website to use Kerberos
- Create an SPN for CRM

- setspn -a http/crm-2011.test.local Domain/User

AD

- Open TMG Computer Account in AD and allow delegation to the SNP you created earlier.

TMG

- Install DoD Root Certificates (http://iase.disa.mil/pki-pke/function_pages/tools.html)
- Install Tumbleweed on TMG Server ***** this is extremely important on gov sites that use this software.  *****
- Import Tumbleweed client configuration file
- Disable HTTPS Inspection and NIS in TMG
- Publish DoD E-mail certs to the NT Auth Store

- certutil -dspublish -f <filename> NTAuthCA

- Make sure GPO for TMG machine is updated with the following.

- Policies -> Windows Settings -> Security Settings -> Public Key Policies -> Certificate Services Client - Auto-Enrollment
- Configuration Model should be enabled and Renew expired certificates and Update certificates should both be checked.

- Create Listener
- Create Rule

- Under Authentication Delegation choose Negotiate (Kerberos/NTLM).  In the SPN box enter the one you created earlier (http/crm-2011.test.local).
- Under Traffic -> Filtering -> Configure HTTP turn off "Verify normalization"  otherwise you will get 500 errors ([http://googleguilt.blogspot.com/2011/04/crm-2011-tmg-2010-error-500-12217.html](http://googleguilt.blogspot.com/2011/04/crm-2011-tmg-2010-error-500-12217.html))

USERS

- Add the EDIPI number from the back of the CAC to the User Principal Name on the AD  account (ie 123456789@mil)
- When creating the CRM users you should still use their original AD user name (ie DOMAIN\rick.wilson) not the EDIPI.

