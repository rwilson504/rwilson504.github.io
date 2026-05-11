---
title: "Amazon AWS Command Line Interface (CLI) Install"
description: "Using CLI can make doing task in AWS much easier. In order to get the CLI tool this is the setup i usually perform."
pubDate: 2018-03-14
updatedDate: 2018-03-15
category: misc
tags:
  - "aws"
draft: false
originalBloggerUrl: /2018/03/amazon-aws-command-line-interface-cli.html
---

Using CLI can make doing task in AWS much easier.  In order to get the CLI tool this is the setup i usually perform.  Instead of going the Python/PIP route as show here there is also an MSI installer you can use.  ([MSI Download Link for 32/64 Bit](https://s3.amazonaws.com/aws-cli/AWSCLISetup.exe))  
  
1. Install Python.  Use Python 2.7.9+ or Python 3.4+ which will insure you get the PIP installer included.  If you are using a previous version of Python you will need to go through a separate setup procedure for PIP.  
  
https://www.python.org/downloads/windows/  
  
2. Open a command prompt As Administrator and run the following.  
  

```
C:\Windows\System32> pip install awscli
```

  
3. Test to make sure that the install was successful.  
  

```
C:\Windows\System32> aws --version
aws-cli/1.11.84 Python/3.6.2 Windows/7 botocore/1.5.47
```

4. After you confirm it was installed you can go ahead and configure the properties for your connection. If you don't have your access/secret keys you can add a new one to your user account in the AWS online console.  IAM -> Users -> Your User -> Security Credentials Tab -> Access Keys.  If you create a new key make sure to keep the keys in a safe place and don't loose them.  
  

```
C:\Windows\System32> aws configure
AWS Access Key ID: yourkey
AWS Secret Access Key: youraccesskey
Default region name [us-east-1]: yourregion
Default output format [None]: json
```

  
Usually before running the CLI updating it is a good idea.  
  

```
C:\Windows\System32> pip install --user --upgrade awscli
```
