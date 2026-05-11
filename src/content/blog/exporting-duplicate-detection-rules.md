---
title: "Exporting Duplicate Detection Rules Using CRM Configuration Migration (Data Migration Tool)"
description: "In order to move Duplicate Detection Rules to another system utilizing the CRM Configuration Migration tool make sure to add the Duplicate Detection Rule and Duplicate Rule Condition entities to the…"
pubDate: 2019-03-05
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgAgvZmY8l-A5piu9nTC44CTUG2U4QyKQlqck-5NGM309EIzEoYrMfwteT4bIKSouss7UnjPGhyVWd1copJ6jUsW325Yf7rXtp6P8dK_Bqrl7ZHRMXQk29sZMBNHr-cwR4LK9Q1llD9icU/s400/DuplicateRules.PNG"
category: power-apps
tags: []
draft: false
originalBloggerUrl: /2019/03/exporting-duplicate-detection-rules.html
---

In order to move Duplicate Detection Rules to another system utilizing the CRM Configuration Migration tool make sure to add the Duplicate Detection Rule and Duplicate Rule Condition entities to the Schema.  

**VERY IMPORTANT NOTE!:** Before you try to export the records you have to Unpublish the rules otherwise the tool will skip exporting all the Duplicate Detection Rules and just export the Duplicate Rule Conditions causing you import to fail.
