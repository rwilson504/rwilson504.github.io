---
title: "Isolate Bootstrap CSS for PCF Components"
description: "Prefix Bootstrap CSS with Less.js to prevent style bleed between PCF components and Power Apps."
pubDate: 2020-11-18
category: power-apps
tags:
  - "power-apps"
  - "power-platform"
  - "pcf"
  - "bootstrap"
  - "css"
  - "less"
draft: true
---

When you create Power Apps Component Framework (PCF) components that utilize the Bootstrap framework it is important to ensure that the CSS styling will not interfere with Power Apps or any other PCF component on your page which is also using it.  In order to ensure that we don't have any styling bleedover I'm going to show you how to prefix you Bootstrap CSS utilizing [Less.js](http://lesscss.org/#)

First let's install Less.js on our machine using npm. Open a command prompt and run.  If you don't already have npm or node.js on your machine you can get the latest version [here](https://nodejs.org/en/).
```
npm install less -g
```

Now let's download the compiled version of Bootstrap we are using.  You can find the download file by going to the [All Versions](https://getbootstrap.com/docs/versions/) page on the Boostrap main page.
![Bootstrap documentation page listing all available versions](/images/isolate-bootstrap-css-for-pcf/01-bootstrap-all-versions.png)

Pick the version you are going to utilize in your PCF component and click on the link to download the compiled version of Bootstrap.
![Bootstrap documentation with a version download link](/images/isolate-bootstrap-css-for-pcf/02-bootstrap-version-download.png)
![Bootstrap download page with the compiled CSS and JS option](/images/isolate-bootstrap-css-for-pcf/03-bootstrap-compiled-download.png)

After the file is downloaded extract the Bootstrap files to a folder on your computer and navigate to the css folder.

Within the css folder create a new file called isolate.less and then open this file in the editor of your choosing.

Create a CSS class within the isolate.less file.  This class name will be the prefix which will be applied as a prefix to all the css that we will then mark as imports to this class.  With the class you will @import the CSS files you need from the Bootstrap distro. You can include as many as you need.

Finally we will run the lessc command in a Command prompt to generate our new CSS file.  I typically name the output file the same as the class name.

The format for the Less.js command line interface will be:
```
lessc "<less file location>" "<css file output>"
```

Example command:
```
lessc "C:\path\to\bootstrap-3.4.1-dist\css\isolate.less" "C:\path\to\bootstrap-3.4.1-dist\css\bootstrap-raw-samplecomponent.css"
```

If you run into any issue with this command try adding in the --math=strict command line option.  Some version of Bootstrap that use the calc method in their CSS can cause issues if this is not turned on.

```
lessc --math=strict "<less file location>" "<css file output>"
```

After you run the Less in the command prompt navigate back to your bootstrap CSS folder and you will now see the output file you created.

Unfortunately body and html cannot be prefixed so open the new CSS file and do a find and replace of the following two items.
```
find:
replace:
```

Finally to utilize this new file we need to add it to our PCF component.  To do this first drop the file into the solution and open the ControlManifest.Input.xml

Add the new CSS file to the resources node.  This will ensure that your css file gets loaded when the control is initialized.

Finally we need to apply our css class to the PCF components container object.  This will ensure that all of our styles are applied.