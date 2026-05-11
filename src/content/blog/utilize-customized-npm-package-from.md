---
title: "Utilize Customized npm Package from GitHub Branch"
description: "When working with npm libraries there are times you find bugs or want to add functionality to a library."
pubDate: 2020-03-24
heroImage: "/heroes/utilize-customized-npm-package-from.png"
heroImageAlt: "enter image description here"
category: power-apps
tags:
  - "development"
  - "github"
  - "javascript"
  - "npm"
  - "react"
draft: false
originalBloggerUrl: /2020/03/utilize-customized-npm-package-from.html
---

# Utilize Customized npm Package from GitHub Branch

When working with npm libraries there are times you find bugs or want to add functionality to a library. You could just modify the files locally and run the application but this gets tricky when you go to deploy an application and it does an npm install which doesn’t include your changes.

If the project is out there on GitHub there is a better way.

1. Fork the project on Github to your account.
2. Create a new branch from your fork.
3. Fix the bug or add the functionality you want.
4. Uninstall the original npm package by opening a terminal within the directory of your project and running the following command.

`npm uninstall <package-name>`

Example  
`npm uninstall node-simple-odata-server`

5. Install the npm package from your Forked branch using the following command from a terminal within your project directory.

`npm install --save <your-github-user>/<repository-name>#<branch-name>`

Example  
`npm install --save rwilson504/node-simple-odata-server#Add-Nullable`

6. Make sure to create a pull request if possible from your branch to the original authors project so that they could include your fixes or functionality in the original project.
