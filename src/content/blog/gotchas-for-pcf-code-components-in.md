---
title: "Gotchas for PCF Code Components in Canvas Apps"
description: "PCF Code Components allow developers to create their own custom interfaces utilizing Typescript and/or React. To learn more about the PCF Component Framework check out this article."
pubDate: 2020-04-24
heroImage: "/heroes/gotchas-for-pcf-code-components-in.png"
heroImageAlt: "No Escape Characters"
category: power-apps
tags: []
draft: false
originalBloggerUrl: /2020/04/gotchas-for-pcf-code-components-in.html
---

PCF Code Components allow developers to create their own custom interfaces utilizing Typescript and/or React. To learn more about the PCF Component Framework check out [this article](https://docs.microsoft.com/en-us/powerapps/developer/component-framework/custom-controls-overview). Building these controls has been great in Model app but only recently could we also start re-using them in our Canvas apps.

If you want to learn more about how to add your PCF Code component to a Canvas App check out [this article from Microsoft](https://docs.microsoft.com/en-us/powerapps/developer/component-framework/component-framework-for-canvas-apps).

Now that these controls can be utilized within Canvas Apps there are a few things to watch out for. Some of these are bugs that should be fixed when this all comes out of Preview and into General Availability.

# ControlManifest.Input.xml

The ControlManifest.Input.xml file is where you define your component information and all the properties associated with it. Below are some gotcha that will cause you errors when attempting to deploy your component into a Canvas app.

## Be Careful of XML Escape Characters

When defining your component it’s important to add descriptions to ensure your users know how to interact with your control. When doing so though make sure you don’t include any XML escape characters or your control will not import correctly

This is bad…  
  
XML Escape Characters

| Name | Character |
| --- | --- |
| Ampersand | & |
| Less-than | < |
| Greater-than | > |
| Quotes | " |
| Apostrophe | ’ |

## Don’t Include Preview Image

The preview image is great for Model apps because it gives the user an image of what your control looks like before selecting it. Unfortunately right now it will cause an error when you attempt to import your control into the Canvas editor.

Here is what the sample image looks like in a Model App when adding it to a form or view.  
![Preview Image Sample](/images/gotchas-for-pcf-code-components-in/01-preview-image.png)

Make sure not to utilize the preview-image in your manifest if you plan on importing this control to Canvas.  
![Preview Image in Manifest](/images/gotchas-for-pcf-code-components-in/02-namifest-preview-image.png)

## Don’t Use Enum Type for Parameters

When defining your parameters Enums are a great way to let the users know which values are allowed. Unfortunately using Enums will allow the control to be added in the Canvas editor but as soon as you try to run the app in the Canvas run-time you will get the horrible Canvas Screen of Death!

![Canvas Screen of Death](/images/gotchas-for-pcf-code-components-in/03-canvas-screen-of-death.png)

Here is an example of an Enum defined in a manifest.  
![Manifest With Enum](/images/gotchas-for-pcf-code-components-in/04-manifest-enum-dont.png)

Instead define your parameters and an SingleLine.Text and give the user some instruction on the Description keys as the valid options.  
![Use SingleLine.Text Instead](/images/gotchas-for-pcf-code-components-in/05-manifest-enum-do.png)

Using text is a bit harder and will require you to determine the correct value in your code. For example with a true/false field you will need to do something like this.

`var _myTrueFalse = context.parameters?.trueFalseField?.raw.toLowerCase() === "true" ? true : false;`

## Multiple Datasets

The default comments that are included in the manfiest when you provision a PCF project incldues text that says they allow multiple datasets. I though this would be great for a Calendar control I was building so I could define one dataset for the Events and one for the Resources unfortunately adding two datasets caused the Import of the PCF component to fail in the Canvas Editor.  
![Allow Multiple Dataset](/images/gotchas-for-pcf-code-components-in/06-manifest-multiple-dataset.png)
