##### Session Notes

https://071652668689.signin.aws.amazon.com/console

##### For a normal user

##### pip install git-remote-codecommit

1- Created one Code Commit Repo called testrepo.

If you sign in AWS using root account, you cannot configure SSH connections for a root account, and HTTPS connections for a root account are not recommended. Consider signing in as an IAM user and then setting up your connection.

I am already an IAM user.

##### Before cloning, get credentials first

to get key - IAM then Users then your name then security credentials tab then create access key, save the file.

below there is option for generate credentials, do it and save.

Then get the HTTPS Git Clone URL from the repo, use command git clone "URL" local_repo_name, enter, it will ask for credentials, enter the username and the password from the csv downloaded, that's it.

--------------------------------------------------------------------------------------------------------------------------------------------------------

##### User with organization account

##### Problems

1- Git credentials manager (search credentials manager from windows search) is not saving credentials.

2- Getting fatal unable to access 403 error

Though I have admin access, code commit power user policy, it is not working.

Even I manually entered the credentials in Windows credentials, still not working, deleted it.

Tried with creating new user too, same error.

Tried with below commands too..

##### AWS Commands

Download AWS CLI - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

##### aws configure - 

It asks for access key ID, secret Access key, these two you have downloaded as csv from AWS.

It also asks for default region name - you can give your repo region name

Default output format - you can give it as json

##### aws sts get-caller-identity

It gives your user id, account, your arn

##### git config -l --global

It will give you the credentials used.

##### git config --global credential.helper "!aws code-commit credential-helper $@"

##### Problem

By default, Git for Windows installs a Git Credential Manager utility that is not compatible with CodeCommit connections that use the AWS credential helper. When installed, it causes connections to the repository to fail even though the credential helper has been installed with the AWS CLI and configured for connections to CodeCommit.

-----------------------------------------------------------------------------------------------------------------------------------------------------------

##### Solution

Service Control Policy denying the requests, because we are not providing MFA token!



Edit AWS Config and Credential file and have your MFA profile.

Run the bash script which asks for the token.

Then use GIT HTTPS GRC commands, done.

first do “aws configure”

##### To go inside AWS

"cd ~/.aws"

then "ls" command returns config credential file

##### Go inside config file

"vim config" - make sure you have like below

[default]
region = us-east-1
[profile mfa]
region = us-east-1
output = json
mfa_serial = arn:aws:iam::499554417458:mfa/raajesh.rameshbabu
get_session_token_duration_seconds = 86400

"vim credential" - make sure you have like below

[default]
aws_access_key_id = AKIAXIT6DPMZP73L36MN
aws_secret_access_key = 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
[mfa]
aws_access_key_id = AKIAXIT6DPMZP73L36MN
aws_secret_access_key = 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



##### Run the below file

gitMFA.sh (It is in downloads folder)

"cd .." (come out of AWS)

"cd ~/Downloads"

"chmod +x gitMFA.sh" (this is for giving permission)

"./gitMFA.sh mfa" (this is for running the file)

Output

Need to fetch new STS credentials:

Token : ##### Enter your token here

That is all!

##### Use HTTPS GRC

"git clone codecommit::us-east-1://testrepo"

cloning...

##### DONE

So every 24 hours MFA gets expired.

You have to run that file again asks for MFA token, then you can git https src commands.

----------------------------------------------------------------------------------------------------------------------------------------------------------

##### Assignment Part 1 - Hosing react app using codecommit, s3, code build.

##### Hosted link will be on S3 Static Website!



##### Git Push

Then adding few files, pushing it, and just playing around it.

Then created a new user, added to group, attached policy to group which has restrictions on pushing to main branch.

Playing around it.

-----------------------------------------------------------------------------------------------------------------------------------------------------------

##### Code Build

First installed node js - https://phoenixnap.com/kb/install-node-js-npm-on-windows

“node -v” -  to check installation

“npm install -g npx” - to install npx

##### Create react app

npx create-react-app testrepo

$ npx create-react-app testrepo
npm WARN exec The following package was not found and will be installed: create-                                                                                                                react-app

npm WARN deprecated tar@2.2.2: This version of tar is no longer supported, and w                                                                                                                ill not receive security updates. Please upgrade asap.

Creating a new React app in C:\Users\Admin\Desktop\Raajesh\EMLO\Session10AWSCode                                                                                                                CommitBuildDeploy-main\codes\testrepo\testrepo.

Installing packages. This might take a couple of minutes.
Installing react, react-dom, and react-scripts with cra-template...


added 1369 packages in 3m

169 packages are looking for funding
  run `npm fund` for details

Installing template dependencies using npm...
npm WARN deprecated source-map-resolve@0.6.0: See https://github.com/lydell/sour                                                                                                                ce-map-resolve#deprecated

added 38 packages in 15s

169 packages are looking for funding
  run `npm fund` for details
Removing template package using npm...


removed 1 package, and audited 1407 packages in 4s

169 packages are looking for funding
  run `npm fund` for details

8 moderate severity vulnerabilities

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.

Success! Created testrepo at C:\Users\Admin\Desktop\Raajesh\EMLO\Session10AWSCod                                                                                                                eCommitBuildDeploy-main\codes\testrepo\testrepo
Inside that directory, you can run several commands:

  npm start
​    Starts the development server.

  npm run build
​    Bundles the app into static files for production.

  npm test
​    Starts the test runner.

  npm run eject
​    Removes this tool and copies build dependencies, configuration files
​    and scripts into the app directory. If you do this, you can’t go back!

We suggest that you begin by typing:

  cd testrepo
  npm start

Happy hacking!



##### It created node_modules, public, src , package.json..

-----------------------------------------------------------------------------------------------------------------------------------------------------------

##### s3 bucket

Created new testrepo-static s3 bucket.

Then go to properties then edit static website hosting then enable then add index.html as index document.

----------------------------------------------------------------------------------------------------------------------------------------------------------

On the console where your package.json and all are there, do npm start, it starts react js server on port 3000.

Then git push to AWS!

-----------------------------------------------------------------------------------------------------------------------------------------------------------

##### Code Build

https://github.com/sd031/aws_codebuild_codedeploy_nodeJs_demo

Created buildspec.yml and pushed to codecommit.

Created new code build project - given codecommit testrepo

Under environment

​	ubuntu as OS

​	runtime standard

​	image 5.0

It created the role for us.

Then create build project!

##### Enabled ACL, Static website hosting on S3

##### Updated Artifacts on Codebuild as Zip, ticked the check box - allow aws codebuild to modify the service role.

##### Make sure to attach below policies to code build project service role

default policy will be there, code commit power user, s3 full access, ec2 container registry power user (for future), code build admin access, cloud watch full access.

After successful build, you can check the s3 bucket Static website hosting, you will get the link on which react app hosted.

##### Adding Artifacts

Assignment 1 for you is to add an artifact (in this case zip of your build files) and then move it to S3. For that, you'll have to change your buildspec, by adding something like this:

##### Edit artifacts on Code build...

zip

build id

give all -refer video

update artifacts

retry build now

artifacts would have been added.

----------------------------------------------------------------------------------------------------------------------------------------------------------

##### Cloud Watch

switch to original interface

Select Cloud watch : Cloud Build

Click Events then rules, go to amazon event bridge

create rule

name - testrepo-autobuild

predefined pattern by service

service provider aws

service name code commit

event type codecommit repo state change

specific resource by ARN - give your codecommit repo arn check inside settings



Target 

select target - codebuild project (lambda will be there by default)

give code build project urn - check inside build details

create rule!

So now whenever there is a code change, auto build happens, it worked.

-----------------------------------------------------------------------------------------------------------------------------------------------------------

##### Assignment Part 2 - Hosting react app on EC2

##### Creating another repo for Code Deploy

session10codedeploy

go inside then

“npx express-generator” - It is going to create the small express application...

##### EC2

Launch Instance

Select - Ubuntu Server 18.04 LTS (HVM), SSD Volume Type

family t2 type t2 micro selected by default

click - Next: Configure Instance Details

IAM Role - create new IAM Role

create role

check box EC2 on common instances

created role..

Select created role now on EC2

On security group:

add rule - 

type - custom TCP

protocol - TCP

port range - 3000

source - anywhere

Review and Launch!

Launch!

Create a new key pair and download.

Create Instance!

##### Installing Ubuntu from MS Store to connect to EC2 instance.

username and password : raajesh

make sure you have wsl

install wsl

refer kubeflow session and other docker session

check first - wsl -l -v

install wsl

##### Commands

cd /mnt/c

navigate to the directory

I have EC2 instance key pair file inside secures folder, So I am going inside that.

raajesh@LAPTOP-UN5K40HI:/mnt/c/users/admin/desktop/raajesh/emlo/Session10AWSCodeCommitBuildDeploy-main/codes/secures$

“cp EC2KeyPairForS3.pem ~/” - ran this command.

we are basically copying this file from windows directory to ubuntu home..

then do cd

our file will be there in ubuntu home now

chmod 400 session10ec2keypair.pem

do - ssh -i "session10ec2keypair.pem" ubuntu@ec2-3-14-29-113.us-east-2.compute.amazonaws.com

we are connected!

now

“sudo apt-get update”

“sudo apt-get install ruby”

“wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install”

“chmod +x ./install”

“sudo ./install auto”

Our code deploy agent should be up now.

to check - sudo service codedeploy-agent status

Our code deploy agent is ready now..



##### Lets go back to our repo where we did npx react app - session10codedeploy

rename app.js to index.js

changed code on index.js

const { application } = require("express");

const express = require("express");

const app = express();

const port  = 3000;

app.get("/", (req, res) => {

  res.send("CodeDeploy Sample V1!");

});

app.get("/status", (req, res) => {

  res.send("ok");

});

app.listen(port, () => {

  console.log(`Example app listening at http://localhost: ${port}`);

});

##### Create new appspec.yml file

We are going to specify what to do at what stage.

version: 0.0

os: linux

files:

  \- source: /

​    destination: /home/ubuntu/app

hooks:

  ApplicationStop:

​    \- location: scripts/stop_server.sh

​      timeout: 300

​      runas: root

  BeforeInstall:

​    \- location: scripts/before_install.sh

​      timeout: 300

​      runas: root      

  AfterInstall:

​    \- location: scripts/after_install.sh

​      timeout: 300

​      runas: root 

  ApplicationStart:

​    \- location: scripts/start_server.sh

​      timeout: 300

​      runas: root 

  ValidateService:

​    \- location: scripts/validate_service.sh

​      timeout: 300

​      runas: root                   



Now we need to add those files.

we added all those files inside scripts folder

this is for every time server restarts, it executes all these from appspec.yml file

did git push!

Our deployment code is ready now.

But our code deploy is not up, so go to code deploy.



##### Code Deploy

create application

name and select ec2

create deployment group

create new role

go to iam roles

create role

aws service

use cases - code deploy

##### select the role and it must appear now

now we have to connect our ec2 instance using key value pair

so first create tags on the ec2 instance.

disabling load balancer as of now

Deployment group is done

Now we need to create the deployment.

we have to enter our revision location - basically s3 path.

for that...

lets do

actually we are deploying to ec2 and also do a copy to s3.

C:\Users\Admin\Desktop\Raajesh\EMLO\Session10AWSCodeCommitBuildDeploy-main\Personal Account\session10codedeploy>aws deploy push --application-name session10codedeployapp --s3-location s3://session10-static/codedeploydemo/app.zip --ignore-hidden-files --region us-east-1

To deploy with this revision, run:
aws deploy create-deployment --application-name session10codedeployapp --s3-location bucket=session10-static,key=codedeploydemo/app.zip,bundleType=zip,eTag=304736dc4a195422fd94b2847f69c079 --deployment-group-name <deployment-group-name> --deployment-config-name <deployment-config-name> --description <description>

It created one folder on our s3 bucket.

Now go back to code deploy

now if you refresh, it will show you s3 bucket location..

select overwrite the content

Created Deployment!

This deployment gets failed since npm install is not done on our EC2 instance.

So on ubuntu terminal (make sure you connected to ec2)..

ubuntu@ip-172-31-90-239:~$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
​                                 Dload  Upload   Total   Spent    Left  Speed
100 15037  100 15037    0     0   564k      0 --:--:-- --:--:-- --:--:--  564k
=> nvm is already installed in /home/ubuntu/.nvm, trying to update using git
=> => Compressing and cleaning up git repository

=> nvm source string already in /home/ubuntu/.bashrc
=> bash_completion source string already in /home/ubuntu/.bashrc
=> Close and reopen your terminal to start using nvm or run the following to use it now:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

execute all commands above.

then nvm install v14

npm i -g pm2 (this helps on scaling).

then

n=$(which node);n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local

above is for proper permission and moving our files to root folder

##### Now retry deployment, and everything will work.

##### Assignment Part 2

I am creating new deployment!

go to code deploy

go inside your app

go inside your deployment group created

created new deployment

##### Done

Now go to instances, click public IP, have ‘http’ with port 3000.

we can see our app deployed.

##### Enable bucket versioning on S3







##### Session11 - Autoscaling

we normally have autoscaling option while we create instance but then it is going to linked with load balancer.

Now lets create image on our instance, right click your instance, image and templates, create image.

Give image name.

When you create image of your instance, usually system shuts down for a while, creates image and all.

so we have to do few things on our instance first.

“sudo su -”

“pm2 ls”

“pm2 startup”

“pm2 save”

we saved config files, these are the things must be there before creating the image.

##### Now go back to instance and create image.

##### Create Autoscaling group

First make launch configuration from autoscaling.

you can see your images from AMI - FYI

select the image on AMI dropdown

add rule

custom tcp rule

port range 3000

source type anywhere

##### Key pair

choose existing key pair

Launch configuration is ready!

##### Now create auto scaling group

give name

switch to launch configuration

and give the launch configuration created.

select availability zones (all)



On the next - we are going to select load balancer

so first create load balancer and choose here.

Go to load balancers

create application load balancer.

Create security group here..

add rule

select that security group..

now after that on listeners.

add listener..

port 3000

create target group now..

add it to pending..

then create target group.

back to load balancer

choose target policy as cpu utilization 80%

all done

so we can see 3 instances!





























