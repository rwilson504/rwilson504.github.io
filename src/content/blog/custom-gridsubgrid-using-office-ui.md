---
title: "Custom Grid/Subgrid Using Office-UI-Fabric DetailsList"
description: "Allows you to simulate the out of the box Grid and Subgrid controls using the Office-UI-Fabric DetailsList control. It was built to provide a springboard when you need a customizable grid experience.…"
pubDate: 2020-02-05
heroImage: "https://github.com/rwilson504/Blogger/blob/master/Office-Fabric-UI-DetailsList-PCF/office-fabric-ui-detailslist.gif?raw=true"
heroImageAlt: "DetailsList Grid Control"
category: power-apps
tags:
  - "crm"
  - "dynamics"
  - "pcf"
  - "power-apps"
draft: false
originalBloggerUrl: /2020/02/custom-gridsubgrid-using-office-ui.html
---

## Custom PCF Grid/Subgrid Using Office-UI-Fabric DetailsList

![DetailsList Grid Control](https://github.com/rwilson504/Blogger/blob/master/Office-Fabric-UI-DetailsList-PCF/office-fabric-ui-detailslist.gif?raw=true)

Allows you to simulate the out of the box Grid and Subgrid controls using the Office-UI-Fabric DetailsList control. It was built to provide a springboard when you need a customizable grid experience. This component re-creates a mojority of the capabilities available out of the box in less than 300 lines of code and demonstrates the following:

- Using the DataSet within a React functional component.
- Displaying and sorting data within the Office-UI-Fabric DetailsList component.
- Rendering custom formats for data with the DetailsList component such as links for Entity References, email addresses, and phone numbers.
- Displaying field data for related entities.
- React Hooks - the component uses both useState and useEffect.
- Loading more than 5k records in DataSet.
- Retaining the use of the standard ribbon buttons by using the setSelectedRecordIds function on the DataSet.
- Detecting and responding to control width updates.
