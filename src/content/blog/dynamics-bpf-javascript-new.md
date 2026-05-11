---
title: "Dynamics BPF Javascript: NEW onPreStageChange Handler!"
description: "If you are utilizing the UCI interface there is a new JavaScript handler available for the Business Process Flows (BPF), onPreStageChange.…"
pubDate: 2019-10-28
category: power-apps
tags: []
draft: false
originalBloggerUrl: /2019/10/dynamics-bpf-javascript-new.html
---

If you are utilizing the UCI interface there is a new JavaScript handler available for the Business Process Flows (BPF), **onPreStageChange**.  Unlike the onStageChange handler on**Pre**StageChange fires before the actual business process has been changed so that you can evaluate if you want the change to occur and prevent it if needed.  

With this new handler we can now get rid of many of the Synchronous workflows used previously to evaluate the changes made to a BPF.  By removing these workflows the overall performance of your BPF changes should be increased.  Additionally calling JavaScript code being before the change also eliminates additional problems such as the users clicking the Next/Previous multiple times before the workflows have been fired ([Tip #360](https://crmtipoftheday.com/360/workflows-on-change-of-process-flow-stage/))

To utilize the new handler you will needed to create a function and then pass that function into the addOnPreStageChange function provided under executionContext.getFormContext().data.process.  It is best practice to pass a function rather than using an anonymous function because it will allow you to remove the handler later if needed.  Additional documentation for these function can be found [here](https://docs.microsoft.com/en-us/powerapps/developer/model-driven-apps/clientapi/reference/formcontext-data-process/eventhandlers/addonprestagechange).

```
 function onLoad(executionContext) {
        var formContext = executionContext.getFormContext();
        var process = formContext.data.process;        

        //handles changes to the BPF before they actually occur
        process.addOnPreStageChange(myProcessStateOnPreChange);
    }

function myProcessStateOnPreChange() {

        var formContext: Xrm.FormContext = executionContext.getFormContext();
        var process = formContext.data.process;
        var eventArgs = executionContext.getEventArgs();

        var currentStageId = process.getActiveStage().getId();
        var nextStageId = process.getSelectedStage().getId();

        //dont allow to go back using the set active button
        if (currentStageId != nextStageId) {
            eventArgs.preventDefault();
            Xrm.Utility.alertDialog("You cannot use the Set Active button.")
            return;
        }        
              
        if (eventArgs._direction === 1) //backwards
        {            
            //here you can add logic based upon the BPF going to the previous Stage.
            return;
        }

        //otherwise forward
        // here you can add logic based upon the BPF going to the next Stage.   
    }
```
