---
layout: post
title: Utilize Customized npm Package from GitHub Branch
date: '2020-03-24T09:27:00.001-04:00'
author: Rick Wilson
tags:
- npm
- Development
- Javascript
- react
- github
modified_time: '2020-03-24T09:28:35.533-04:00'
comments: true
thumbnail: 'https://github.com/rwilson504/Blogger/blob/master/Npm-Install-From-GitHub/npm-fork.png?raw=true'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4625076713076061439
blogger_orig_url: https://www.richardawilson.com/2020/03/utilize-customized-npm-package-from.html
---

When working with npm libraries there are times you find bugs or want to add functionality to a library.  You could just modify the files locally and run the application but this gets tricky when you go to deploy an application and it does an npm install which doesnâ€™t include your changes.

If the project is out there on GitHub there is a better way.

1. Fork the project on Github to your account.![enter image description here](https://github.com/rwilson504/Blogger/blob/master/Npm-Install-From-GitHub/npm-fork.png?raw=true)
2. Create a new branch from your fork.
3. Fix the bug or add the functionality you want.
4. Uninstall the original npm package by opening a terminal within the directory of your project and running the following command.

```npm uninstall <package-name>```

Example
```npm uninstall node-simple-odata-server```

1. Install the npm package from your Forked branch using the following command from a terminal within your project directory.

```npm install --save <your-github-user>/<repository-name>#<branch-name>```

Example
```npm install --save rwilson504/node-simple-odata-server#Add-Nullable```

1. Make sure to create a pull request if possible from your branch to the original authors project so that they could include your fixes or functionality in the original project.

