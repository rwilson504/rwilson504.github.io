---
layout: post
title: Get Dynamics/CDS Base URL in Flow To Generate Links To Record
date: '2019-08-09T12:26:00.001-04:00'
author: Rick Wilson
tags:
- CDS
- Dynamics
- Flow
modified_time: '2019-08-09T12:26:20.124-04:00'
thumbnail: https://1.bp.blogspot.com/-DeLHL7OBL00/XU2JoGJGzMI/AAAAAAABJW4/2n-rGKVSSUoO-K4vbOcLNzepFprdTZYRQCLcBGAs/s72-c/BaseURL1.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-25575921193676972
blogger_orig_url: https://www.richardawilson.com/2019/08/get-dynamicscds-base-url-in-flow-to.html
---

When sending emails or approvals in flow it can be helpful to also include a link to the record which is being referenced.  In order to send those links though we need the environment URL of the Dynamics/CDS environment.  This article shows an example of how to get the base URL for the environment and how to build a link based upon it. 

This will be demonstrated within a Flow created for the [App In A Day Workshop](https://powerapps.microsoft.com/en-us/blog/power-platform-challenges/). In this Flow we are attempting to get an approval when a Device Order entity record is created from our Canvas App.  The Approval step allows us to include a link to the item and we will also be sending out emails to the requester based upon the Approval outcome which will include the link.

The first Action we need to add to our existing workflow is the CDS Get record step.  Why do we need this step?  Well unfortunately the Output that is provided from the Flow Trigger of when a record is created does not include the URL to the record.  Instead we need also include the Get record step which will include the record URL in it's Output.

[![](https://1.bp.blogspot.com/-DeLHL7OBL00/XU2JoGJGzMI/AAAAAAABJW4/2n-rGKVSSUoO-K4vbOcLNzepFprdTZYRQCLcBGAs/s640/BaseURL1.png)](https://1.bp.blogspot.com/-DeLHL7OBL00/XU2JoGJGzMI/AAAAAAABJW4/2n-rGKVSSUoO-K4vbOcLNzepFprdTZYRQCLcBGAs/s1600/BaseURL1.png)

Next we need to parse the Output of the returned record and get the base URL of the dynamics environment.  We can do this by adding an Initialize variable Action to our flow.  As you can see below we are first creating an expression that will grab the URL from the @odata.id field within the body of the output.  The @odata.id field is the OData URL of the record so we cannot just sent the user that, instead we parse that URL to get the base environment portion.  After you parse out the environment UR  you can then add on the rest that will allow a user to actually view the record in Dynamics.

Expression to Parse URL (Note: Replace Get_Current_Record with the name of the Get record action you created earlier): first(split(outputs('Get_Current_Record')?['body']?['@odata.id'],'/api/'))

[![](https://1.bp.blogspot.com/-IqLjgT6eVws/XU2LqaTlVaI/AAAAAAABJXE/_m6MZRTUkAYczG5qzjsCYi9pxCjlsLwgQCLcBGAs/s640/BaseURL2.png)](https://1.bp.blogspot.com/-IqLjgT6eVws/XU2LqaTlVaI/AAAAAAABJXE/_m6MZRTUkAYczG5qzjsCYi9pxCjlsLwgQCLcBGAs/s1600/BaseURL2.png)

So how did we determine how to parse the URL?  You can view the output of the Get record activity by view either running the Flow in Test mode or you can view a historical run of the Flow where the Get record activity has already been added.  From here we can view the JSON output which allows us to determine the parsing.

[![](https://1.bp.blogspot.com/-fqRvp9yTPfc/XU2STtK7Q7I/AAAAAAABJXU/44o9rwikMisPz3JZvBpX4osx63uGmonBQCLcBGAs/s640/BaseURL4.png)](https://1.bp.blogspot.com/-fqRvp9yTPfc/XU2STtK7Q7I/AAAAAAABJXU/44o9rwikMisPz3JZvBpX4osx63uGmonBQCLcBGAs/s1600/BaseURL4.png)

[![](https://1.bp.blogspot.com/-55E5ENFjeyY/XU2STkPr0ZI/AAAAAAABJXQ/D_BD9Lj2cNIZk7yQsajfCu8pYTKgAZPxgCEwYBhgL/s640/BaseURL3.png)](https://1.bp.blogspot.com/-55E5ENFjeyY/XU2STkPr0ZI/AAAAAAABJXQ/D_BD9Lj2cNIZk7yQsajfCu8pYTKgAZPxgCEwYBhgL/s1600/BaseURL3.png)

Finally we can utilize the Record URL variable we have initialized within the other action in our Flow.

[![](https://1.bp.blogspot.com/-JYJwKgHvepc/XU2dSfKH2MI/AAAAAAABJXw/QLzbVVq1_7g6vBSNHk6rCcJoe6S6S2I9QCLcBGAs/s640/BaseURL5.png)](https://1.bp.blogspot.com/-JYJwKgHvepc/XU2dSfKH2MI/AAAAAAABJXw/QLzbVVq1_7g6vBSNHk6rCcJoe6S6S2I9QCLcBGAs/s1600/BaseURL5.png)

[![](https://1.bp.blogspot.com/-lhdBmDsYzSg/XU2dxqxLSKI/AAAAAAABJX8/hGrwwXe3Aashl0-B-HBWdcHKFldVqfFfQCLcBGAs/s640/BaseURL7.png)](https://1.bp.blogspot.com/-lhdBmDsYzSg/XU2dxqxLSKI/AAAAAAABJX8/hGrwwXe3Aashl0-B-HBWdcHKFldVqfFfQCLcBGAs/s1600/BaseURL7.png)

