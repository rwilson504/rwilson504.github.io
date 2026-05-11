---
title: "Dynamics CRM Demonstration Tools (Data Generator)"
description: "When creating demo environments for sales presenations I like to add a lot of test data to my systems and make it relevant to the custom to which I'm presenting.…"
pubDate: 2009-08-27
category: power-apps
tags:
  - "crm-4"
  - "demonstration"
  - "tools"
draft: false
originalBloggerUrl: /2009/08/dynamics-crm-demonstration-tools-data.html
---

When creating demo environments for sales presenations I like to add a lot of test data to my systems and make it relevant to the custom to which I'm presenting. Microsoft released a tool called "Microsoft CRM Demonstration Tools" which you can download [here](http://www.microsoft.com/downloads/details.aspx?FamilyID=634508dc-1762-40d6-b745-b3bde05d7012&DisplayLang=en).   
   
This tool has several useful features:   
-Data Generator   
-Date Mover   
-Dependent Picklist Creator   
-Generate Emails   
-Generate Entity Icons   
-Site Map Editor   
-String Replacer   
   
The tool I use the most is the data generator. This allows me to create XML files which will automatically generate entity records in my demo system.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiQbIVRGdJNImydm9vHBskGbEp7OfY89ofA35RBqI77eLfRYxXnYVW8regFVeH33imsq1gR588zHAc6OPo_ogFLvg5SoASv3tqUCjhuyoxTYDiWlTyEu57CXVynSbrDbwSIQLVf5dRBwnw/s400/DataGenerator.png.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiQbIVRGdJNImydm9vHBskGbEp7OfY89ofA35RBqI77eLfRYxXnYVW8regFVeH33imsq1gR588zHAc6OPo_ogFLvg5SoASv3tqUCjhuyoxTYDiWlTyEu57CXVynSbrDbwSIQLVf5dRBwnw/s800/DataGenerator.png.jpg)

I first go into the demonstration tools and generate an XML file with all the fields I want to populate and put in at least one test value for each field to ensure that I get my data formatted right.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiy-GmDPW80chh5bZ5qTFDhLhWeZ_I54Ej2MiQtFjFJ-40wN_kHjmhaLNnulhhOxa0ZnhMEWZTffM77LHJltV0JIyhsB8k8SiUi0XaBQIC3vm-rJrW6OAfC2Ea7IWwMeQcrVgh2ixirGN4/s400/SaveDataGeneratorFile.png.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiy-GmDPW80chh5bZ5qTFDhLhWeZ_I54Ej2MiQtFjFJ-40wN_kHjmhaLNnulhhOxa0ZnhMEWZTffM77LHJltV0JIyhsB8k8SiUi0XaBQIC3vm-rJrW6OAfC2Ea7IWwMeQcrVgh2ixirGN4/s800/SaveDataGeneratorFile.png.jpg)

Next I need to get some sample data. For some of it I look around the internet but for the basics I use a great OpenSource tool called [GenerateData](http://www.generatedata.com/) which you can install on any web server using PHP and MySQL, or you can use their [online instance](http://www.generatedata.com/#generator) of the tool. This allows you to generate test data for names, addresses, random words, dates, and more.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh3PFlEcvTt_IQxHu4hyDlOOOQX3QY2i8zQ_uXo8Zzg7Npus9DULHjfsZyqgXJGubzTOsdMCndUvh7F22YUnldqX9RSsKlOb-inQF7j2FeX_4rbxGSO5rkTqi0Na0YQEcBnLDXRjqbHZ7A/s400/GenerateData.png.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh3PFlEcvTt_IQxHu4hyDlOOOQX3QY2i8zQ_uXo8Zzg7Npus9DULHjfsZyqgXJGubzTOsdMCndUvh7F22YUnldqX9RSsKlOb-inQF7j2FeX_4rbxGSO5rkTqi0Na0YQEcBnLDXRjqbHZ7A/s400/GenerateData.png.jpg)

I usually edit the XML in Visual Studio and reformat it into a more readable XML format which also allows me to expand and contract the nodes. After you load the file in just go to Edit -> Advanced -> Format Document   
   
The problem with editing the document in Visual Studio though is that the Demonstration Tools will not accept an XML file that has any line breaks for paces between the tags. This is when I crack open my favorite text editor called [TextPad](http://www.textpad.com/). I past and then do a select all of the XML data in TextPad. I then go to Edit -> Joint Lines (Ctrl+J).

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjZdGV6iIg0MJ2QNQbmMSsq5TcETZ6jaoDGweAvuwXnV6gD81t6oEZ9aBVsKWuKI0R5QKU5AhsK7d2Od8WlYxT6KZmSno2fwQZ3I9Amq_oJkSI00ixGn8MlvYHD0EptC3TFBtd1OC43zms/s400/JoinLines.png.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjZdGV6iIg0MJ2QNQbmMSsq5TcETZ6jaoDGweAvuwXnV6gD81t6oEZ9aBVsKWuKI0R5QKU5AhsK7d2Od8WlYxT6KZmSno2fwQZ3I9Amq_oJkSI00ixGn8MlvYHD0EptC3TFBtd1OC43zms/s400/JoinLines.png.jpg)

Next I go to Search -> Replace (F8) and look for "> <" and replace it with "><" to remove the space between the tags.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEja059XmTDC_d6eaCaY8t6Sw6VBM2ubvsLjQTzoxFexj4IsGerektIDsSzUi93o4DdUeE8fNn_M7KQkbCBwbod9y2LxOKrZKtUmokiSSgEwQ1ZgMtOjENpUSI9MaXyjhbZU2E0hKUQ1swE/s400/FindReplace.png.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEja059XmTDC_d6eaCaY8t6Sw6VBM2ubvsLjQTzoxFexj4IsGerektIDsSzUi93o4DdUeE8fNn_M7KQkbCBwbod9y2LxOKrZKtUmokiSSgEwQ1ZgMtOjENpUSI9MaXyjhbZU2E0hKUQ1swE/s800/FindReplace.png.jpg)

Finally I try clicking on the line directly beneath the text to ensure that there is no line break after the text. After I save all the info I go back into the Demonstration Tools -> Data Generator, click the Open... button and select the file I created. Ensure that your data is the way you want it, choose the number of records to generate, and click Generate Data. You now have a customized record set to show your customer.

On a final note I use differencing disks on my VPC to quickly set up multiple test/demo environments. If you only use one VPC but you want to delete your old test data before you load in new data you can [this tool](http://mscrmtools.blogspot.com/2009/07/new-tool-bulk-delete-launcher.html) to create batch delete jobs without using the SDK.
