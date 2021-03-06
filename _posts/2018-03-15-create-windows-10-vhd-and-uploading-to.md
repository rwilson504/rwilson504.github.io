---
layout: post
title: Create Windows 10 VHD and Import as EC2 AMI
date: '2018-03-15T10:38:00.000-04:00'
author: Rick Wilson
tags:
- S3
- EC2
- Windows 10
- AMI
- AWS
modified_time: '2018-03-15T13:59:01.361-04:00'
thumbnail: https://3.bp.blogspot.com/-71I-i0KJ5W4/WqlVLUxzsuI/AAAAAAAA1nc/SCYaLmf2TeUam7ZfuHZN3FDyFyIR3IeEgCLcBGAs/s72-c/2018-03-14%2B12_55_13-Oracle%2BVM%2BVirtualBox%2BManager.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-2184322203224087633
blogger_orig_url: https://www.richardawilson.com/2018/03/create-windows-10-vhd-and-uploading-to.html
---


In needing to test client configuration and keep them in the same domain as our server we recently needed to add some Windows 10 machines to EC2.  It was a bit of a surprise that there were no AMIs available for Windows 10. Instead we needed to create our own VHD and import it as an AMI in our EC2 isntance.

Prepare VM

1. Download and install [Oracle VM Virtualbox](https://www.virtualbox.org/wiki/Downloads)
2. Download your Windows 10 ISO file.
3. Create a new Windows 10 VM
4. When creating the hard drive make sure to choose the VHD format.

[![](https://3.bp.blogspot.com/-71I-i0KJ5W4/WqlVLUxzsuI/AAAAAAAA1nc/SCYaLmf2TeUam7ZfuHZN3FDyFyIR3IeEgCLcBGAs/s320/2018-03-14%2B12_55_13-Oracle%2BVM%2BVirtualBox%2BManager.png)](https://3.bp.blogspot.com/-71I-i0KJ5W4/WqlVLUxzsuI/AAAAAAAA1nc/SCYaLmf2TeUam7ZfuHZN3FDyFyIR3IeEgCLcBGAs/s1600/2018-03-14%2B12_55_13-Oracle%2BVM%2BVirtualBox%2BManager.png)

5. I chose Fixed size for the storage on the hard disk.  I have not tried using Dynamic.

  [![](https://4.bp.blogspot.com/-0PEGLl1kz4Y/WqlVSSCd16I/AAAAAAAA1ng/3hakzDu7ifAe3l5BzA5HsnWn2h9wTKzqwCLcBGAs/s320/2018-03-14%2B12_56_29-Oracle%2BVM%2BVirtualBox%2BManager.png)](https://4.bp.blogspot.com/-0PEGLl1kz4Y/WqlVSSCd16I/AAAAAAAA1ng/3hakzDu7ifAe3l5BzA5HsnWn2h9wTKzqwCLcBGAs/s1600/2018-03-14%2B12_56_29-Oracle%2BVM%2BVirtualBox%2BManager.png)
6. Give the hard drive at least 25GB go bigger if you can.
7. Attach the ISO to your Virtual Machine and start it up.
8. Run through the windows setup
9. When prompted to either enter a windows account or a domain account choose domain account.  You will be promoted to create a new user and password, this new user will be a local administrator on the machine, make sure to save this information.
10. After you have completed the setup enable Remote Access to the machine.  If you fail to do this now then you won't be able to connect later when you create the EC2 machine instance.

[![](https://3.bp.blogspot.com/-zXuJ5SR_Jpg/WqlXlwzn13I/AAAAAAAA1oU/ucQtO8WDAmMkVeIOq-5L_qzSnZU0s10_gCLcBGAs/s320/2018-03-14%2B13_10_27-How%2Bto%2BSet%2BUp%2Band%2BUse%2BRemote%2BDesktop%2Bfor%2BWindows%2B10.png)](https://3.bp.blogspot.com/-zXuJ5SR_Jpg/WqlXlwzn13I/AAAAAAAA1oU/ucQtO8WDAmMkVeIOq-5L_qzSnZU0s10_gCLcBGAs/s1600/2018-03-14%2B13_10_27-How%2Bto%2BSet%2BUp%2Band%2BUse%2BRemote%2BDesktop%2Bfor%2BWindows%2B10.png)[![](https://3.bp.blogspot.com/-RKSK9DH6Db4/WqlXl8Hy05I/AAAAAAAA1oQ/gGYfMBYUs8Ayj_2SOCGMGiyg7qUTQzWMACLcBGAs/s320/2018-03-14%2B13_10_37-How%2Bto%2BSet%2BUp%2Band%2BUse%2BRemote%2BDesktop%2Bfor%2BWindows%2B10.png)](https://3.bp.blogspot.com/-RKSK9DH6Db4/WqlXl8Hy05I/AAAAAAAA1oQ/gGYfMBYUs8Ayj_2SOCGMGiyg7qUTQzWMACLcBGAs/s1600/2018-03-14%2B13_10_37-How%2Bto%2BSet%2BUp%2Band%2BUse%2BRemote%2BDesktop%2Bfor%2BWindows%2B10.png)

11. Restart the machine and run Windows Update.
12. Close the Virtual Machine

Install the AWS Command Line Utility

[Click here for instructions](http://www.richardawilson.com/2018/03/amazon-aws-command-line-interface-cli.html)

Upload the VHD File to S3

[Click here for instructions](http://www.richardawilson.com/2018/03/uploading-large-files-into-amazon-s3.html)

Create JSON Documents

These documents will be used to a role, assign rights, and import the vhd as an AMI.  It's helpful to have all these documents in the same folder.

1. Create a trust policy document which will create a new role and give that role the correct actions it will need to do the import. The file can be called role-trust.json

    {
       "Version": "2012-10-17",
       "Statement": [
          {
             "Effect": "Allow",
             "Principal": { "Service": "vmie.amazonaws.com" },
             "Action": "sts:AssumeRole",
             "Condition": {
                "StringEquals":{
                   "sts:Externalid": "vmimport"
                }
             }
          }
       ]
    }
    
    

2. Create a role policy document which will provide the role the security permissions it need to do the import.  You can name the new file role-security.json, make sure the two places where YOURBUCKET is mentioned that you replace them with the name of your bucket where the VHD is located.

    {
       "Version": "2012-10-17",
       "Statement": [
          {
             "Effect": "Allow",
             "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
             ],
             "Resource": [
                "arn:aws:s3:::YOURBUCKET"
             ]
          },
          {
             "Effect": "Allow",
             "Action": [
                "s3:GetObject"
             ],
             "Resource": [
                "arn:aws:s3:::YOURBUCKET/*"
             ]
          },
          {
             "Effect": "Allow",
             "Action":[
                "ec2:ModifySnapshotAttribute",
                "ec2:CopySnapshot",
                "ec2:RegisterImage",
                "ec2:Describe*"
             ],
             "Resource": "*"
          }
       ]
    }
    
    

3. Create another document which will describe the VHD which is going to be imported. Make sure to replace YOURBUCKET with the name of your bucket where the VHD is located. You can name this file image-container.json

    [{ 
             "Description": "Windows 10 Base Install 1709", 
             "Format": "vhd", 
             "UserBucket": { 
                      "S3Bucket": "YOURBUCKET", 
                      "S3Key": "Windows 10.vhd" 
             } 
    }]
    

Run Commands

1. Open a command prompt As Administrator
2. Navigate to the folder where you have the json document you created in the last step.
3. Run this first command which will create the role

    aws iam create-role --role-name vmimport --assume-role-policy-document file://role-trust.json
    
    

4. Run this command which assign permissions needed by the role

    aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document file://role-security.json
    
    

5. Run this command which will import the VHD

    aws ec2 import-image --description "Windows 10 (1709)" --disk-containers file://image-container.json --region us-east-1
    
    

6. It can take a while to import the VHD as an AMI, in my case it took about 1.5 hours.
7. To see the status of your import run this command.

    aws ec2 describe-import-image-tasks --region us-east-1

[![](https://3.bp.blogspot.com/-A-v2hyzsUh0/WqpsJFgVgWI/AAAAAAAA1pU/ntZN6D4lxl0FR7EPXj78lY7Jlyz30XnJACLcBGAs/s320/2018-03-15%2B08_31_12-Select%2BWindows%2BPowerShell.png)](https://3.bp.blogspot.com/-A-v2hyzsUh0/WqpsJFgVgWI/AAAAAAAA1pU/ntZN6D4lxl0FR7EPXj78lY7Jlyz30XnJACLcBGAs/s1600/2018-03-15%2B08_31_12-Select%2BWindows%2BPowerShell.png)

8. When the import is completed the status will look like this. Make note of the ImageId tag.  You will need this to find the AMI later when you want to launch an instance of the AMI.
[![](https://3.bp.blogspot.com/-fUiynXL3KU0/WqprgZuUuCI/AAAAAAAA1pM/rOPPRit2OiQKPmvQX7yFEEVB_bveakhcwCLcBGAs/s320/2018-03-14%2B13_27_36-Select%2BWindows%2BPowerShell.png)](https://3.bp.blogspot.com/-fUiynXL3KU0/WqprgZuUuCI/AAAAAAAA1pM/rOPPRit2OiQKPmvQX7yFEEVB_bveakhcwCLcBGAs/s1600/2018-03-14%2B13_27_36-Select%2BWindows%2BPowerShell.png)

Create EC2 Instance

Now that our VHD is an AMI we can create a new EC2 instance from it.

1. You can quickly launch an instance of the AMI from AWS -> EC2 -> AMIs
2. Select the AMI you created and click the Launch button.  You can located the AMI by the ImageId you got from the completed status you received earlier.
3. Make sure when you set up the security group for the Instance you allow port 3389 for RDP.
4. When you log into the machine use the local administrator account you created when you set up the VM.

