---
title: "Expand a VHD drive and partition - &quot;How To &amp; Video&quot;"
description: "When creating a virtual hard drive in Microsoft Virtual PC the default drive size is 16GB. This seems like a lot of space but it quickly dwindles as you do development.…"
pubDate: 2009-08-21
category: misc
tags:
  - "vhd"
draft: false
originalBloggerUrl: /2009/08/expand-vhd-drive-and-partition-to-video.html
---

When creating a virtual hard drive in Microsoft Virtual PC the default drive size is 16GB. This seems like a lot of space but it quickly dwindles as you do development. Typically I set the drive size to something much larger if I'm creating the virtual machine from scratch. Unfortunately many times I use SYSPREP images to speed up the process and these images are set to the default 16GB. In order to expand these drives out there are two tools which you need.

**Tools**

The first tool you will need is VHD Resizer. This tool allows you to expand the size of the VHD file and also change it from fixed size to dynamic or vice versa.

[Download VHD Resizer](http://vmtoolkit.com/files/folders/converters/entry87.aspx) (requires free registration)

The second tool required is the Gparted LiveCD. This is an open source tool that can be used to increase the size of the partition on the drive after you have increased the VHD size.

[Download GParted LiveCD ISO Image](http://download.tuxfamily.org/gpartedlive/gparted-livecd-0.3.4-11.iso)

[GParted Homepage](http://gparted.sourceforge.net/)

**Demonstration**
