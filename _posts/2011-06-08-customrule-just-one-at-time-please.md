---
layout: post
title: CustomRule - Just one at a time please.
date: '2011-06-08T16:30:00.001-04:00'
author: Rick Wilson
tags:
- CRM 2011
- Ribbon
modified_time: '2011-06-08T16:34:55.910-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6619347959865924091
blogger_orig_url: https://www.richardawilson.com/2011/06/customrule-just-one-at-time-please.html
---

When you define a CommandDefinition in the CRM 2011 and you want to use a CustomRule underneath an EnableRule just remember that your CustomRule will never fire if you have other EnableRules applied to that Command Definition.  This means that you can't use a bunch of the already build in EnableRules on top of your CustomRule.... which sucks.  Instead you need to re-create the functionality in your CustomRule javascript.

For example you can't just use the Mscrm.SelectionCountExactlyOne rule to determine if there is only one record selected in a grid.  Instead you have to do the following; Pass in the CrmParameter called SelectedControlSelectedItemCount and then check to make sure that parameter equals one in your JS code.

I really don't like the ribbon schema.  It's confusing and the rules that apply to buttons you create don't always seem to apply to the ones that come out of the box, which makes it extremely hard to troubleshoot sometimes just using the output from the ribbonXmlExporter included in the SDK.

Here is an example of someone who has an example of what I described.
[http://howto-mscrm.blogspot.com/2011/04/how-to-series-6-how-to-use-customrule.html](http://howto-mscrm.blogspot.com/2011/04/how-to-series-6-how-to-use-customrule.html)

