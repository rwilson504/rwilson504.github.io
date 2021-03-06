---
layout: post
title: Uploading Large Files into Amazon S3
date: '2018-03-14T12:41:00.001-04:00'
author: Rick Wilson
tags:
- S3
- AWS
modified_time: '2018-03-15T13:58:34.646-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7676524344511348620
blogger_orig_url: https://www.richardawilson.com/2018/03/uploading-large-files-into-amazon-s3.html
---

I recently had to upload some VHDs to Amazon S3 and found myself going beyond the upload limits for the web upload.  In order to accomplish uploading the 50GB files I used the AWS Command Line Interface (CLI).  If you need to know how to install the CLI check here ([Install CLI](http://www.richardawilson.com/2018/03/amazon-aws-command-line-interface-cli.html))

1. Open a command prompt As Administrator.

2. Make sure your CLI configuration is up to date.

    C:\Windows\System32> aws configure
    AWS Access Key ID: yourkey
    AWS Secret Access Key: youraccesskey
    Default region name [us-east-1]: yourregion
    Default output format [None]: json
    

3. Create your bucket on S3 if it's not already there.

4. Run the following command.  

    C:\Windows\System32> aws s3 cp c:\temp\yourfile.vhd s3://yourbucket/VHDs

5. After you run the command the output window will provide you feedback as to how much of your download is complete and your current upload speed. 

    C:\Windows\System32> aws s3 cp c:\temp\yourfile.vhd s3://yourbucket/VHDs
    Completed 1.1 GiB/50 Gib (14.1 MiB/s) with 1 file(s) remaining

