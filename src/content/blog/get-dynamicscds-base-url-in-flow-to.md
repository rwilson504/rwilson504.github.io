---
title: "Get Dynamics/CDS Base URL in Flow To Generate Links To Record"
description: "When sending emails or approvals in flow it can be helpful to also include a link to the record which is being referenced.…"
pubDate: 2019-08-09
heroImage: "/heroes/get-dynamicscds-base-url-in-flow-to.png"
category: power-apps
tags:
  - "cds"
  - "dynamics"
  - "flow"
draft: false
originalBloggerUrl: /2019/08/get-dynamicscds-base-url-in-flow-to.html
---

When sending emails or approvals in flow it can be helpful to also include a link to the record which is being referenced.  In order to send those links though we need the environment URL of the Dynamics/CDS environment.  This article shows an example of how to get the base URL for the environment and how to build a link based upon it.   
  
This will be demonstrated within a Flow created for the [App In A Day Workshop](https://powerapps.microsoft.com/en-us/blog/power-platform-challenges/). In this Flow we are attempting to get an approval when a Device Order entity record is created from our Canvas App.  The Approval step allows us to include a link to the item and we will also be sending out emails to the requester based upon the Approval outcome which will include the link.  
  
The first Action we need to add to our existing workflow is the CDS Get record step.  Why do we need this step?  Well unfortunately the Output that is provided from the Flow Trigger of when a record is created does not include the URL to the record.  Instead we need also include the Get record step which will include the record URL in it's Output.  
  

Next we need to parse the Output of the returned record and get the base URL of the dynamics environment.  We can do this by adding an Initialize variable Action to our flow.  As you can see below we are first creating an expression that will grab the URL from the @odata.id field within the body of the output.  The @odata.id field is the OData URL of the record so we cannot just sent the user that, instead we parse that URL to get the base environment portion.  After you parse out the environment UR  you can then add on the rest that will allow a user to actually view the record in Dynamics.

Expression to Parse URL (**Note**: Replace Get\_Current\_Record with the name of the Get record action you created earlier): first(split(outputs('Get\_Current\_Record')?['body']?['@odata.id'],'/api/'))

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgHrX8Tgi0AM7cZtbaL6wfZg6lrO3f8osaruLfONjLtWBvbXZrgVGSKaTdaOPTunLjCLiPp9r6zoT3rgrttdfVxqMCyHwg0oTrs19F0SqCVBs2eoct5v8mekkB4Sn_SQjeHuv_t0gyeSSo/s640/BaseURL2.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgHrX8Tgi0AM7cZtbaL6wfZg6lrO3f8osaruLfONjLtWBvbXZrgVGSKaTdaOPTunLjCLiPp9r6zoT3rgrttdfVxqMCyHwg0oTrs19F0SqCVBs2eoct5v8mekkB4Sn_SQjeHuv_t0gyeSSo/s1600/BaseURL2.png)

So how did we determine how to parse the URL?  You can view the output of the Get record activity by view either running the Flow in Test mode or you can view a historical run of the Flow where the Get record activity has already been added.  From here we can view the JSON output which allows us to determine the parsing.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi7Y9U2hrQbqhCYUd79v0EirtIzwELJCupMxrgngeO77pC-RBIzA7z9iFArNkD-9AvLxpvX8durRnqMrHVpqlB0oggxJjssaCVEAcEzYOiIaLwDYaLazvFsmIUcxiRJ3iH5NXkBzeWtntk/s640/BaseURL4.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi7Y9U2hrQbqhCYUd79v0EirtIzwELJCupMxrgngeO77pC-RBIzA7z9iFArNkD-9AvLxpvX8durRnqMrHVpqlB0oggxJjssaCVEAcEzYOiIaLwDYaLazvFsmIUcxiRJ3iH5NXkBzeWtntk/s1600/BaseURL4.png)

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgbY7DXhjEMSyxiO08wMxW5OImnV7UTlAQ1-NhAP9KuoGQm5IbE02cXnOkkXyF36SXxh30hIVHHZTXcYQM2j-CUPzBQt_82B3z5CD67WKfDobtUSdDsrQl4i9ISjn-XmgvxpmtoixKtf7M/s640/BaseURL3.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgbY7DXhjEMSyxiO08wMxW5OImnV7UTlAQ1-NhAP9KuoGQm5IbE02cXnOkkXyF36SXxh30hIVHHZTXcYQM2j-CUPzBQt_82B3z5CD67WKfDobtUSdDsrQl4i9ISjn-XmgvxpmtoixKtf7M/s1600/BaseURL3.png)

Finally we can utilize the Record URL variable we have initialized within the other action in our Flow.  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh-CAKQaeKVVAaGfcfT644cyJ3LhmW92i2hsCmHF2-Nx6bnPUT0cQ7HckO7v9M00PW589YI5PbB_FQL39cL3e_1UiaWPbUT2Lmz6oQMlymDT4dO85x0EWWnChRYv7HSiWzvptVwUUpBTos/s640/BaseURL5.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh-CAKQaeKVVAaGfcfT644cyJ3LhmW92i2hsCmHF2-Nx6bnPUT0cQ7HckO7v9M00PW589YI5PbB_FQL39cL3e_1UiaWPbUT2Lmz6oQMlymDT4dO85x0EWWnChRYv7HSiWzvptVwUUpBTos/s1600/BaseURL5.png)

  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgXIppXVnmk6VUCoz509JZMBTy-IEDkQlQxBpIXbW_vaYIVPUxuqmmrTHmL_cNnFkgjF9Mk8YW0rNbqRRCXoW-TOE9BQYdNQ1b5rHpp54ncGS46UDqsNPoC5OgRc0dPWlRA8SvZrnUqiiw/s640/BaseURL7.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgXIppXVnmk6VUCoz509JZMBTy-IEDkQlQxBpIXbW_vaYIVPUxuqmmrTHmL_cNnFkgjF9Mk8YW0rNbqRRCXoW-TOE9BQYdNQ1b5rHpp54ncGS46UDqsNPoC5OgRc0dPWlRA8SvZrnUqiiw/s1600/BaseURL7.png)
