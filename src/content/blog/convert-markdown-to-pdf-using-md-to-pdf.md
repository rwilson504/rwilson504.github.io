---
title: "Convert Markdown Documents to PDF Using md-to-pdf"
description: "How to convert Markdown documents (e.g. an Azure DevOps wiki) to PDF using the md-to-pdf npm package, with examples of project setup, configuration, and generation."
pubDate: 2019-11-06
heroImage: "/heroes/convert-markdown-to-pdf-using-md-to-pdf.gif"
heroImageAlt: "Create Folder and Run init"
category: "dev-tools"
tags:
  - "markdown"
  - "pdf"
  - "npm"
  - "azure-devops"
  - "documentation"
draft: false
originalBloggerUrl: /2019/11/article.html
---

# Convert Markdown Documents to PDF Using md-to-pdf

Azure DevOps now has an option to [link your Wiki to a repo](https://docs.microsoft.com/en-us/azure/devops/project/wiki/publish-repo-to-wiki?view=azure-devops). With this change I decided to start creating all my documentation in Markdown and then to supply my users with PDF output for things such as user guide. This allows me to source control my documents and still supply users with clean looking outputs. Here is how i went about doing this.

## Create Documents Folder/Package

I started by creating a new folder for my documents and running the **npm init** command.

## Install md-to-pdf from NPM

Install the [md-to-pdf](https://www.npmjs.com/package/md-to-pdf) npm package by running **npm i --save-dev md-to-pdf**

![Install md-to-pdf](/images/convert-markdown-to-pdf-using-md-to-pdf/01-install-md-to-pdf.gif)

## Create Index.js file

Create a index.js file in the root directory of your folder and copy the following code.

```
const mdToPdf = require('md-to-pdf');
const config = {
"pdf_options": {
  "format": "Letter",
  "margin": "15mm",
  "displayHeaderFooter": true,
  "headerTemplate": "<style>section {padding-left: 10mm; padding-right: 10mm; font-family: system-ui; font-size: 11px; }</style><section><span class='title'></span> - <span class='date'></span></section>",
  "footerTemplate": "<section><div>Page <span class='pageNumber'></span> of <span class='totalPages'></span></div></section>"},
  "stylesheet_encoding": "utf-8"
  };
 const docs = ['README'];
 const start = async () => {
    for (let docName of docs) {
        config.dest = docName + '.pdf';
        const pdf = await mdToPdf(docName + '.md', config).catch(console.error);
        if (pdf) {
            console.log(pdf.filename);
        }
    }
    console.log('Done');
  }

start();
```

Update the docs array to include the file names of the markdown files you want to convert. In my example I’m just doing a single README file.

## Generate Documents

To generate the pdf documents open a console window and run **npm run test**. The output for the PDFs will have the same file name as the Markdown files and will be in the same directory.

![Generate Files](/images/convert-markdown-to-pdf-using-md-to-pdf/02-generate-pdf.gif)
