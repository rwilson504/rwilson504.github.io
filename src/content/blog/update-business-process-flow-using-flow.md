---
title: "Update Business Process Flow Using Flow"
description: "When working through App In A Day Workshop I wanted to improve the Approval flow to move the Business Process Flow (BPF) Stage forward if the Device Order was Approved.…"
pubDate: 2019-08-12
heroImage: "/heroes/update-business-process-flow-using-flow.png"
category: power-apps
tags: []
draft: false
originalBloggerUrl: /2019/08/update-business-process-flow-using-flow.html
---

When working through App In A Day Workshop I wanted to improve the Approval flow to move the Business Process Flow (BPF) Stage forward if the Device Order was Approved.  I have utilized plugins and workflow previously to accomplish this type of action but never with Flow.  After doing a quick search i found an article from Elaiza Benitez ([Automatically update the stage of a Business Process Flow with Flow 2.0](http://benitezhere.blogspot.com/2019/06/automatically-update-the-stage-of-a-business-process-flow-2.0.html)), make sure to check it out it's great.  My post here utilizes the techniques Elaiza provided but applies it to the Device Approval Request Flow as part of the App In A Day workshop.  
  
Below if the final Device Approval Request.  The parts I added to the BPF are outlined in Red.  

The first thing we need to do is get the Device Procurement Process record for the Device Order that applies to the BPF we build in the workshop.

[![](/images/update-business-process-flow-using-flow/01-FlowBPF2.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh6Mnfm1kYZwQnjXMucUH0eAy-rh0O8fGDO0It84HnQKxMHq9MDTPGE7iAoaGKGuWRqFE-0Y5jtMuXdBMSCxFbtau5J8gBJXInUmM7Z-RZR0uGgVUFLm8_uVL5GG-0UTXrqPVyOe5ltiOk/s1600/FlowBPF2.png)

Next we need to parse the returned record using the Parse JSON action.  In order to get the schema for this action just run the Flow with the previous action that returns the Device Procurement Process records and grab the Output.  Click the Use sample payload to generate schema link copy in the value portion of the output, make sure to not include the [ ].

first(outputs('Get\_Device\_Procurement\_Process\_Records')?['body/value'])

[![](/images/update-business-process-flow-using-flow/02-FlowBPF3.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjpeO84dZ-EHh9qPeVfB9tR7oRM676yPh8ViUdmqzYlwN4BNKTAnrehG4ZfJ3up30ZhGP-nhiiGA5jugeOYdfh7RmhOODrfVboOo_Xbwqqhv578eJM7Mrb5vDB82bcvju-eUnzn5ujGCF0/s1600/FlowBPF3.png)

  

|  |
| --- |
|  |
| Device Procurement Process Records Output |

I wanted to make sure to follow the same rules as the BPF so next the price of the device needs to be evaluated.

[![](/images/update-business-process-flow-using-flow/03-FlowBPF4.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi75WqJAKvOr6DHg6ksnzXUKo5naOrqxvmMmF7TY9etUUzvk58uCwwFkFTyR5qx3h0hvgQ_mjcJ1X7igCoEyeHo6H1HkavGk9D0-Sa91hqzpeGfCWWBa0JlOy793cqdJZjwuqPuM_tyxsg/s1600/FlowBPF4.png)'

If the device is $1000 or greater the first thing to do is to grab the Process Stage information for Capital Approval since that will be required.  We will use this process stage information in the next action to actually update the BPF.

[![](/images/update-business-process-flow-using-flow/04-FlowBPF5.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEix55w1Nj5dcPHgGeIn6-8UcXJcaomsDvC7r6MfqnztXhQ6LFByPVZSUfvO4jmNTpDV1mjWdYpqX6vhM8Z9E9T00ESgwUD4KaTrcmA_uzGCTQgb7AjvgzITF8ux8sg6SOrCXVa9rVKcXTw/s1600/FlowBPF5.png)

Just like after we got the record for the BPF itself we will now need to parse the output from the Process Stage entity.

first(outputs('Get\_Process\_Stage\_for\_Capital\_Approval')?['body/value'])

[![](/images/update-business-process-flow-using-flow/05-FlowBPF6.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiOKJl4WxujknXUvEvAIQg_5zP6CLIunf2xoLHJUlFyjCQ7qokwhQUSysM2HP8TgNVazfrBCvYrwugLTL5UztfPq8q91kTu-xxBvQ79dYkMq7fk9MkeKY7Ow_GzHrtFqIY4U-zB6NKNU3U/s1600/FlowBPF6.png)

Finally we need to update the BPF record to set the Active Stage to Capital Approval.

[![](/images/update-business-process-flow-using-flow/06-FlowBPF7.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjkMG5A7vKEhr2yymkUnWIO-8XabNMbZjsrTUjMDJhYOPJF7N6GD1eyPul5W_6m3w8PtQJSa60dg24AEn8sSuph4RGGi0PL94_vZBR3VevYYRk7UW0Hyq1I_ZrnSe7bvcmXKBlzWXd_Y_E/s1600/FlowBPF7.png)

The last action can be repeated for the no condition of this workflow the only difference being that instead of getting the Process Stage record for Capital Approval we find the one for Place Order.

[![](/images/update-business-process-flow-using-flow/07-FlowBPF8.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjBsiGMdsiHu-Kelj1gw3Tm31-zoEClToprtPcM2FzUu2b4yeHqLfZbbyOhdpB_z7i7WgQJrVSr-9hOpUvBhJNJv5Lk0c99X0g0LDOiTD3s_FyFJQUgEAhSfEi83frUIi0oux1PziH3zHI/s1600/FlowBPF8.png)
