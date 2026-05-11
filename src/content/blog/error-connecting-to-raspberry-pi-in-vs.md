---
title: "Error Connecting to Raspberry Pi in VS Code After Reset"
description: "While utilizing the Remote Development tools to connecto to a raspberry pi board using SSH I encountered the following error after doing a full OS reset on the pi board."
pubDate: 2021-05-24
heroImage: "/heroes/error-connecting-to-raspberry-pi-in-vs.png"
heroImageAlt: "Visual Studio Code Error"
category: electronics
tags:
  - "dnsspoofing"
  - "errror"
  - "iot"
  - "raspberry-pi"
  - "remotedevelopment"
  - "remotessh"
  - "ssh"
  - "vscode"
draft: false
originalBloggerUrl: /2021/05/error-connecting-to-raspberry-pi-in-vs.html
---

While utilizing the [Remote Development tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) to connecto to a raspberry pi board using SSH I encountered the following error after doing a full OS reset on the pi board.

The detailed error within the VS code console was the following.

`WARNING: POSSIBLE DNS SPOOFING DETECTED! @ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ The ECDSA host key for raspberrypi.local has changed, and the key for the corresponding IP address fe80::a25a:b6ea:ae38:25d7%bridge100 is unknown. This could either mean that DNS SPOOFING is happening or the IP address for the host and its host key have changed at the same time. @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY! Someone could be eavesdropping on you right now (man-in-the-middle attack)! It is also possible that a host key has just been changed. The fingerprint for the ECDSA key sent by the remote host is SHA256:14s3gi2hHhIlFobItAxtLB1tlyB1uZFFi/C0ruoS9iI. Please contact your system administrator. Add correct host key in /Users/admin/.ssh/known_hosts to get rid of this message. Offending ECDSA key in /Users/admin/.ssh/known_hosts:1 ECDSA host key for raspberrypi.local has changed and you have requested strict checking. Host key verification failed.`

To fix this open file explorer to the location of the SSH configuration file. There you will see another file called known\_hosts. You can either delete the file completely or edit it and remove the line specific to the device you are connecting to. You will be prompted the next time you connect using VS Code to update the key for that device which will then add it back to this file.  
![Delete known_hosts file](/images/error-connecting-to-raspberry-pi-in-vs/01-119375670-11cb2700-bc89-11eb-865a-6b5cfbb07bca.png)
