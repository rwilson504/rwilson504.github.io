---
title: "Power Automate Custom Connectors - Import Postman v2 Collection"
description: "There are many tools you can utilize to develop Power Automate custom connectors including Postman and Swagger Inspector.…"
pubDate: 2021-05-05
heroImage: "/heroes/power-automate-custom-connectors-import.png"
heroImageAlt: "image"
category: power-apps
tags:
  - "actions"
  - "customconnector"
  - "power-apps"
  - "power-automate"
  - "power-platform"
  - "triggers"
draft: false
originalBloggerUrl: /2021/05/power-automate-custom-connectors-import.html
---

There are many tools you can utilize to develop [Power Automate custom connectors](https://docs.microsoft.com/en-us/connectors/custom-connectors/) including [Postman](https://www.postman.com/) and [Swagger Inspector](https://inspector.swagger.io/builder). I prefer to utilize Postman but recent updates to the product no longer make it possible to export to a v1 collection.

This is unfortunate because the Power Automate custom connector site only allows upload of v1 collections.

![image](/images/power-automate-custom-connectors-import/01-117197061-59ab0c80-adb5-11eb-87ed-ed2cd9f37672.png)

Luckily [APIMATIC](https://www.apimatic.io/) allows you to convert the Postman 2.0 collection to just about any other format you want. You can downgrade them to Postman 1.0 or you could convert them to OpenAPI 2.0 format which you can also directly upload to the Power Automate connector page.

![image](/images/power-automate-custom-connectors-import/02-117196501-8ca0d080-adb4-11eb-9c6f-1e4d8a62d597.png)

Have fun creating custom connectors!
