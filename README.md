##### Session Notes

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

##### Removed “CI=true npm test” line under build from buildspec.yml file, then only code build project succeeded.

##### Enabled ACL, Static website hosting on S3

##### Updated Artifacts on Codebuild as Zip, ticked the check box - allow aws codebuild to modify the service role.

##### Make sure to attach below policies to code build project service role

default policy will be there, code commit power user, s3 full access, ec2 container registry power user (for future), code build admin access, cloud watch full access.

After successful build, you can check the s3 bucket Static website hosting, you will get the link on which react app hosted.

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



Basically, we will have an EC2 instance, we will be creating app from code deploy and deployment group and all, from git bash local we then do code-deploy ..

We will be using separate code commit repo.

So we are hosting react app on EC2 instance created using code-deploy.
