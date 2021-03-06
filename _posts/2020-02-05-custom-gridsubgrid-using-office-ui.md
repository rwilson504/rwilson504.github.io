---
layout: post
title: 'Custom Grid/Subgrid Using Office-UI-Fabric DetailsList'
date: '2020-02-05T17:27:00.001-05:00'
author: Rick Wilson
tags:
- PowerApps
- pcf
- Dynamics
- CRM
modified_time: '2020-02-05T17:27:01.591-05:00'
thumbnail: 'https://github.com/rwilson504/Blogger/blob/master/Office-Fabric-UI-DetailsList-PCF/office-fabric-ui-detailslist.gif?raw=true'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3339791979174946295
blogger_orig_url: https://www.richardawilson.com/2020/02/custom-gridsubgrid-using-office-ui.html
---

Allows you to simulate the out of the box Grid and Subgrid controls using the Office-UI-Fabric DetailsList control. It was built to provide a springboard when you need a customizable grid experience. This component re-creates a mojority of the capabilities available out of the box in less than 300 lines of code and demonstrates the following:

- Using the DataSet within a React functional component.
- Displaying and sorting data within the Office-UI-Fabric DetailsList component.
- Rendering custom formats for data with the DetailsList component such as links for Entity References, email addresses, and phone numbers.
- Displaying field data for related entities.
- React Hooks - the component uses both useState and useEffect.
- Loading more than 5k records in DataSet.
- Retaining the use of the standard ribbon buttons by using the setSelectedRecordIds function on the DataSet.
- Detecting and responding to control width updates.

![DetailsList Grid Control](https://github.com/rwilson504/Blogger/blob/master/Office-Fabric-UI-DetailsList-PCF/office-fabric-ui-detailslist.gif?raw=true)