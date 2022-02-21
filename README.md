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
