---
layout: post
title: Exporting Duplicate Detection Rules Using CRM Configuration Migration (Data
  Migration Tool)
date: '2019-03-05T21:59:00.003-05:00'
author: Rick Wilson
tags: 
modified_time: '2019-03-05T21:59:43.555-05:00'
thumbnail: https://4.bp.blogspot.com/-1hPQTtqOMX4/XH83UIKH8jI/AAAAAAABDy0/H979swJyEEgmfgoiijjmGIySB56T7oIZACLcBGAs/s72-c/DuplicateRules.PNG
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-25544088511009263
blogger_orig_url: https://www.richardawilson.com/2019/03/exporting-duplicate-detection-rules.html
---

In order to move Duplicate Detection Rules to another system utilizing the CRM Configuration Migration tool make sure to add the Duplicate Detection Rule and Duplicate Rule Condition entities to the Schema.

VERY IMPORTANT NOTE!: Before you try to export the records you have to Unpublish the rules otherwise the tool will skip exporting all the Duplicate Detection Rules and just export the Duplicate Rule Conditions causing you import to fail.

[![](https://4.bp.blogspot.com/-1hPQTtqOMX4/XH83UIKH8jI/AAAAAAABDy0/H979swJyEEgmfgoiijjmGIySB56T7oIZACLcBGAs/s400/DuplicateRules.PNG)](https://4.bp.blogspot.com/-1hPQTtqOMX4/XH83UIKH8jI/AAAAAAABDy0/H979swJyEEgmfgoiijjmGIySB56T7oIZACLcBGAs/s1600/DuplicateRules.PNG)

