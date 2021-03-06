---
layout: post
title: Update Business Process Flow Using Flow
date: '2019-08-12T17:50:00.004-04:00'
author: Rick Wilson
tags: 
modified_time: '2019-08-12T17:50:51.096-04:00'
thumbnail: https://1.bp.blogspot.com/-jozuYcBaTvE/XVHamt-lJ9I/AAAAAAABJq4/WOVQ_Zg5Jg4--T5At-XTAP4OClDXk-nZgCLcBGAs/s72-c/FlowBPF1.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-5078097074674877080
blogger_orig_url: https://www.richardawilson.com/2019/08/update-business-process-flow-using-flow.html
---

When working through App In A Day Workshop I wanted to improve the Approval flow to move the Business Process Flow (BPF) Stage forward if the Device Order was Approved.  I have utilized plugins and workflow previously to accomplish this type of action but never with Flow.  After doing a quick search i found an article from Elaiza Benitez ([Automatically update the stage of a Business Process Flow with Flow 2.0](http://benitezhere.blogspot.com/2019/06/automatically-update-the-stage-of-a-business-process-flow-2.0.html)), make sure to check it out it's great.  My post here utilizes the techniques Elaiza provided but applies it to the Device Approval Request Flow as part of the App In A Day workshop.

Below if the final Device Approval Request.  The parts I added to the BPF are outlined in Red.

[![](https://1.bp.blogspot.com/-jozuYcBaTvE/XVHamt-lJ9I/AAAAAAABJq4/WOVQ_Zg5Jg4--T5At-XTAP4OClDXk-nZgCLcBGAs/s640/FlowBPF1.png)](https://1.bp.blogspot.com/-jozuYcBaTvE/XVHamt-lJ9I/AAAAAAABJq4/WOVQ_Zg5Jg4--T5At-XTAP4OClDXk-nZgCLcBGAs/s1600/FlowBPF1.png)

The first thing we need to do is get the Device Procurement Process record for the Device Order that applies to the BPF we build in the workshop.

[![](https://1.bp.blogspot.com/-nApsX2wnswg/XVHamqb1CGI/AAAAAAABJrU/Y-PVMjWd5uIsjHFnC7HO_EIxg_HdXkxKwCEwYBhgL/s640/FlowBPF2.png)](https://1.bp.blogspot.com/-nApsX2wnswg/XVHamqb1CGI/AAAAAAABJrU/Y-PVMjWd5uIsjHFnC7HO_EIxg_HdXkxKwCEwYBhgL/s1600/FlowBPF2.png)

Next we need to parse the returned record using the Parse JSON action.  In order to get the schema for this action just run the Flow with the previous action that returns the Device Procurement Process records and grab the Output.  Click the Use sample payload to generate schema link copy in the value portion of the output, make sure to not include the [ ].

first(outputs('Get_Device_Procurement_Process_Records')?['body/value'])

[![](https://1.bp.blogspot.com/-j0CRPqni_VQ/XVHamjSmEZI/AAAAAAABJrY/8vn3VYTT-zgZBxFXat9h5L1l1dRUsqavwCEwYBhgL/s640/FlowBPF3.png)](https://1.bp.blogspot.com/-j0CRPqni_VQ/XVHamjSmEZI/AAAAAAABJrY/8vn3VYTT-zgZBxFXat9h5L1l1dRUsqavwCEwYBhgL/s1600/FlowBPF3.png)

[![](https://1.bp.blogspot.com/-TnPPBi4XAKY/XVHbzQcYFCI/AAAAAAABJrc/fiCiHZh5qgg58STn6XMHHhoR9IL7TU6SgCEwYBhgL/s640/FlowBPF3.5.png)](https://1.bp.blogspot.com/-TnPPBi4XAKY/XVHbzQcYFCI/AAAAAAABJrc/fiCiHZh5qgg58STn6XMHHhoR9IL7TU6SgCEwYBhgL/s1600/FlowBPF3.5.png)Device Procurement Process Records Output
I wanted to make sure to follow the same rules as the BPF so next the price of the device needs to be evaluated.  

[![](https://1.bp.blogspot.com/-3HYbi7ow768/XVHanP3wiqI/AAAAAAABJrQ/glEaQaWY7Wwy-dSjFRaa6ymaNB9icaCuACEwYBhgL/s640/FlowBPF4.png)](https://1.bp.blogspot.com/-3HYbi7ow768/XVHanP3wiqI/AAAAAAABJrQ/glEaQaWY7Wwy-dSjFRaa6ymaNB9icaCuACEwYBhgL/s1600/FlowBPF4.png)'

If the device is $1000 or greater the first thing to do is to grab the Process Stage information for Capital Approval since that will be required.  We will use this process stage information in the next action to actually update the BPF.

[![](https://1.bp.blogspot.com/-SPSjYfVxLAY/XVHeoNT0NTI/AAAAAAABJrw/gVjjgNJ7P3MJcJuy-FB_LXjbh9nEpJdBQCLcBGAs/s640/FlowBPF5.png)](https://1.bp.blogspot.com/-SPSjYfVxLAY/XVHeoNT0NTI/AAAAAAABJrw/gVjjgNJ7P3MJcJuy-FB_LXjbh9nEpJdBQCLcBGAs/s1600/FlowBPF5.png)

Just like after we got the record for the BPF itself we will now need to parse the output from the Process Stage entity.

first(outputs('Get_Process_Stage_for_Capital_Approval')?['body/value'])

[![](https://1.bp.blogspot.com/-9BK1WU0_XD0/XVHanrlIGWI/AAAAAAABJrY/QNtbNmuOX0MRAGwJfHOonStwt0_C0jKPQCEwYBhgL/s640/FlowBPF6.png)](https://1.bp.blogspot.com/-9BK1WU0_XD0/XVHanrlIGWI/AAAAAAABJrY/QNtbNmuOX0MRAGwJfHOonStwt0_C0jKPQCEwYBhgL/s1600/FlowBPF6.png)

Finally we need to update the BPF record to set the Active Stage to Capital Approval.

[![](https://1.bp.blogspot.com/-xdIhparTP28/XVHaoZxXwWI/AAAAAAABJrY/wsMxwHLsB7k4o91riI5ctZtyGbTbLKu0gCEwYBhgL/s640/FlowBPF7.png)](https://1.bp.blogspot.com/-xdIhparTP28/XVHaoZxXwWI/AAAAAAABJrY/wsMxwHLsB7k4o91riI5ctZtyGbTbLKu0gCEwYBhgL/s1600/FlowBPF7.png)

The last action can be repeated for the no condition of this workflow the only difference being that instead of getting the Process Stage record for Capital Approval we find the one for Place Order.

[![](https://1.bp.blogspot.com/-HTF12zZZbxQ/XVHeJ8M2muI/AAAAAAABJro/8lB64VLtbsAgmcIlpbBXIS4uEvWP8cVUQCLcBGAs/s640/FlowBPF8.png)](https://1.bp.blogspot.com/-HTF12zZZbxQ/XVHeJ8M2muI/AAAAAAABJro/8lB64VLtbsAgmcIlpbBXIS4uEvWP8cVUQCLcBGAs/s1600/FlowBPF8.png)

