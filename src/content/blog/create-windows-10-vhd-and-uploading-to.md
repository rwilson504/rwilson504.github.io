---
title: "Create Windows 10 VHD and Import as EC2 AMI"
description: "In needing to test client configuration and keep them in the same domain as our server we recently needed to add some Windows 10 machines to EC2.…"
pubDate: 2018-03-15
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgFDx12g8q14GG7-t5Vy3VrwakfBxnqtXGRPXaTEmQDTuapBGD8HStSZSm4e31YaFtRTwdV4T3l6dd8T2xhXyCF_mcO9WD3pwNMN2PRdtLnbopfIenKNYCyqU_cZXSSR6QYBFlJbDNUz08/s320/2018-03-14+12_55_13-Oracle+VM+VirtualBox+Manager.png"
category: misc
tags:
  - "ami"
  - "aws"
  - "ec2"
  - "s3"
  - "windows-10"
draft: false
originalBloggerUrl: /2018/03/create-windows-10-vhd-and-uploading-to.html
---

In needing to test client configuration and keep them in the same domain as our server we recently needed to add some Windows 10 machines to EC2. It was a bit of a surprise that there were no AMIs available for Windows 10. Instead we needed to create our own VHD and import it as an AMI in our EC2 isntance.  
  
**Prepare VM**  

1. Download and install [Oracle VM Virtualbox](https://www.virtualbox.org/wiki/Downloads)
2. Download your Windows 10 ISO file.
3. Create a new Windows 10 VM
4. When creating the hard drive make sure to choose the VHD format.  
     
   [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgFDx12g8q14GG7-t5Vy3VrwakfBxnqtXGRPXaTEmQDTuapBGD8HStSZSm4e31YaFtRTwdV4T3l6dd8T2xhXyCF_mcO9WD3pwNMN2PRdtLnbopfIenKNYCyqU_cZXSSR6QYBFlJbDNUz08/s320/2018-03-14+12_55_13-Oracle+VM+VirtualBox+Manager.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgFDx12g8q14GG7-t5Vy3VrwakfBxnqtXGRPXaTEmQDTuapBGD8HStSZSm4e31YaFtRTwdV4T3l6dd8T2xhXyCF_mcO9WD3pwNMN2PRdtLnbopfIenKNYCyqU_cZXSSR6QYBFlJbDNUz08/s1600/2018-03-14+12_55_13-Oracle+VM+VirtualBox+Manager.png)
5. I chose Fixed size for the storage on the hard disk.  I have not tried using Dynamic.  
     
     [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhZ2UpcrEe5t8-oqQ1z0Vy6rqROOhZ0ANu9I_6bcAfTGkvaINUgfHD0DwtnyXDkcshMvvc_6uMkpbG4dx3mQaYRh0oSNsghqG4eglGxvopwCIQUtToCIBAcOAK_n3FQz5O0WyatBBND6Yk/s320/2018-03-14+12_56_29-Oracle+VM+VirtualBox+Manager.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhZ2UpcrEe5t8-oqQ1z0Vy6rqROOhZ0ANu9I_6bcAfTGkvaINUgfHD0DwtnyXDkcshMvvc_6uMkpbG4dx3mQaYRh0oSNsghqG4eglGxvopwCIQUtToCIBAcOAK_n3FQz5O0WyatBBND6Yk/s1600/2018-03-14+12_56_29-Oracle+VM+VirtualBox+Manager.png)
6. Give the hard drive at least 25GB go bigger if you can.
7. Attach the ISO to your Virtual Machine and start it up.
8. Run through the windows setup
9. When prompted to either enter a windows account or a domain account choose domain account.  You will be promoted to create a new user and password, this new user will be a local administrator on the machine, make sure to save this information.
10. After you have completed the setup enable Remote Access to the machine.  If you fail to do this now then you won't be able to connect later when you create the EC2 machine instance.  
      
    [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjaJ0yKeA1YJ-ngRMRF0VwVyZy7fvuvaISIW6SG32LN2xUWRX530rG4Njn_RSyEFpPFGw5IgoY0hyphenhyphenOGGqbkG7I-6NIAcStQl-BoySmvtXsWJBn3R6Xv9EgfvuWXLH-MBs5cT98tCNu0P5w/s320/2018-03-14+13_10_27-How+to+Set+Up+and+Use+Remote+Desktop+for+Windows+10.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjaJ0yKeA1YJ-ngRMRF0VwVyZy7fvuvaISIW6SG32LN2xUWRX530rG4Njn_RSyEFpPFGw5IgoY0hyphenhyphenOGGqbkG7I-6NIAcStQl-BoySmvtXsWJBn3R6Xv9EgfvuWXLH-MBs5cT98tCNu0P5w/s1600/2018-03-14+13_10_27-How+to+Set+Up+and+Use+Remote+Desktop+for+Windows+10.png)[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgNe27XQpvNlV5mKfC0mtPoPfnrt9zRNP7j84hH1RIrNC36jcAGZMQqOId2W6SWQULePiIBjWHNE1MqAU5MJfrrVO-evsocCjTzUqJk5So8WGHPrUmm3jZIWFV7sjp2H_L7P18cqg4sHEE/s320/2018-03-14+13_10_37-How+to+Set+Up+and+Use+Remote+Desktop+for+Windows+10.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgNe27XQpvNlV5mKfC0mtPoPfnrt9zRNP7j84hH1RIrNC36jcAGZMQqOId2W6SWQULePiIBjWHNE1MqAU5MJfrrVO-evsocCjTzUqJk5So8WGHPrUmm3jZIWFV7sjp2H_L7P18cqg4sHEE/s1600/2018-03-14+13_10_37-How+to+Set+Up+and+Use+Remote+Desktop+for+Windows+10.png)
11. Restart the machine and run Windows Update.
12. Close the Virtual Machine

**Install the AWS Command Line Utility**

[Click here for instructions](http://www.richardawilson.com/2018/03/amazon-aws-command-line-interface-cli.html)

**Upload the VHD File to S3**

[Click here for instructions](http://www.richardawilson.com/2018/03/uploading-large-files-into-amazon-s3.html)

**Create JSON Documents**

These documents will be used to a role, assign rights, and import the vhd as an AMI.  It's helpful to have all these documents in the same folder.

1. Create a trust policy document which will create a new role and give that role the correct actions it will need to do the import. The file can be called role-trust.json  
     

   ```
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
   ```
2. Create a role policy document which will provide the role the security permissions it need to do the import.  You can name the new file role-security.json, make sure the two places where YOURBUCKET is mentioned that you replace them with the name of your bucket where the VHD is located.  
     

   ```
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
   ```
3. Create another document which will describe the VHD which is going to be imported. Make sure to replace YOURBUCKET with the name of your bucket where the VHD is located. You can name this file image-container.json  
     

   ```
   [{ 
            "Description": "Windows 10 Base Install 1709", 
            "Format": "vhd", 
            "UserBucket": { 
                     "S3Bucket": "YOURBUCKET", 
                     "S3Key": "Windows 10.vhd" 
            } 
   }]
   ```

**Run Commands**

1. Open a command prompt As Administrator
2. Navigate to the folder where you have the json document you created in the last step.
3. Run this first command which will create the role  
     

   ```
   aws iam create-role --role-name vmimport --assume-role-policy-document file://role-trust.json
   ```
4. Run this command which assign permissions needed by the role  
     

   ```
   aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document file://role-security.json
   ```
5. Run this command which will import the VHD  
     

   ```
   aws ec2 import-image --description "Windows 10 (1709)" --disk-containers file://image-container.json --region us-east-1
   ```
6. It can take a while to import the VHD as an AMI, in my case it took about 1.5 hours.
7. To see the status of your import run this command.  
     

   ```
   aws ec2 describe-import-image-tasks --region us-east-1
   ```

     
   [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj4dD9qtqwW4YV6Hs4P51UYWKqo_cD3deQT10vyumKhSI7kn8RTlBW02feB_9DfF4u3uaFkUSYIhaaqXIvv8TtiKHlhH9oMy4OyizJsVt5slntiePoxpFtgVequAadyAhR8XcAJVBpgsVg/s320/2018-03-15+08_31_12-Select+Windows+PowerShell.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj4dD9qtqwW4YV6Hs4P51UYWKqo_cD3deQT10vyumKhSI7kn8RTlBW02feB_9DfF4u3uaFkUSYIhaaqXIvv8TtiKHlhH9oMy4OyizJsVt5slntiePoxpFtgVequAadyAhR8XcAJVBpgsVg/s1600/2018-03-15+08_31_12-Select+Windows+PowerShell.png)
8. When the import is completed the status will look like this. Make note of the ImageId tag.  You will need this to find the AMI later when you want to launch an instance of the AMI.  
   [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEicPtHGrXD9UN-L6VUL6Hloep5Eeq3udrs5e_d7NlaJtvLvJubtXryUW12nz8dLicZbh3CaeN-5ftvYcIUBpEUaT4j5ssepLze4GaO_G_hGPXwdmqgjQEkLQ0ZazqNknqWf0MQW8X1qK_E/s320/2018-03-14+13_27_36-Select+Windows+PowerShell.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEicPtHGrXD9UN-L6VUL6Hloep5Eeq3udrs5e_d7NlaJtvLvJubtXryUW12nz8dLicZbh3CaeN-5ftvYcIUBpEUaT4j5ssepLze4GaO_G_hGPXwdmqgjQEkLQ0ZazqNknqWf0MQW8X1qK_E/s1600/2018-03-14+13_27_36-Select+Windows+PowerShell.png)

**Create EC2 Instance**

Now that our VHD is an AMI we can create a new EC2 instance from it.  

1. You can quickly launch an instance of the AMI from AWS -> EC2 -> AMIs
2. Select the AMI you created and click the Launch button.  You can located the AMI by the ImageId you got from the completed status you received earlier.
3. Make sure when you set up the security group for the Instance you allow port 3389 for RDP.
4. When you log into the machine use the local administrator account you created when you set up the VM.
