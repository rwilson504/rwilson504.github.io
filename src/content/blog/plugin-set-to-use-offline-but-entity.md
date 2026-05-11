---
title: "Plugin Set to Use Offline but Entity Offline Settings Not Configured"
description: "While attempting to deploy a solution to CRM 2011 I received the following error during the import."
pubDate: 2011-06-28
heroImage: "/heroes/plugin-set-to-use-offline-but-entity.png"
heroImageAlt: "image"
category: power-apps
tags:
  - "crm-2011"
  - "plugin-development"
draft: false
originalBloggerUrl: /2011/06/plugin-set-to-use-offline-but-entity.html
---

While attempting to deploy a solution to CRM 2011 I received the following error during the import.

0x80040203 - Supported deployment does not agree with message availability

After reviewing the code for the plugin I realized that it was attempting to register the plugin for both Server and Offline.

[System.ComponentModel.AmbientValue("CrmPluginStepDeployment=2")]

The problem there was that the Entity was not set for Offline mode.

[![offlinesettings](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiKZUERCoMf3bCveDu2ZwteY3AwVG_xQWd0lZbB9CP8BBpzT0bxlJ4-YHDyJvk5flSbsbfGeda-YiE8O2mmsQchDXp3dcAnnZnYbqmhC4VmFakQ5POmQpnn8N1N3-3EkHvu2lG-dwlfkpw/?imgmax=800 "offlinesettings")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjBiSETWE2dTQk-I2V34vMbh_JdCpoC4cULnUt9ulHbez0OjA_9Ec1Lp7RGXYSO8eIFvH74HNqQeaA5JM9xNZV-fkNmEbEKgJ4jfbZpbIGRLgY-EJ4PgKmfbyi1tk0bNqISnlGXIxncAJE/s1600-h/offlinesettings%25255B4%25255D.png)

One the entity was updated the solution installed correctly.
