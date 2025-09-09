# Section 30 - Other Services

## 370. CloudFormation

Deploying and managing infrascture at scale

- declarative way of outlining your AWS Infrastructure for any resource
- can do it in the right order, with your infrastructure

- Infrastructure as code (no need for manual creation)
- Cost advantage
	- each resource within the stack is tagged within an identifier
	- can estimate costs of your resources
	- Saving strategies: can quickly delete and create entire infra

- automated generation of diagram for your templates
- declarative programming
- don't re-invent the wheel
	- leverage existing templates on the web
	- leverage the documentation
- in the rare case something isn't supported
	- use custom resource

### Infrastructure composer
- can see all resources
- can see the relations between the components


## 372. CloudFormation Service Role

- IAM role that allows CloudFormation to create/update/delete stack resource on your behalf

## 373. Amazon SES

Simple Email Service
- fully managed service to send emails securely, globally and at scale
- Allows inbound/outbound emails
- Reputation dashboards, performance, anti-spam feedback
- Provides statistics such as email deliveries, bounces, feedback loops results, email open
- Supports DKIM and SPF frameworks (security)
- flexible IP deployment
- Send emails using your application using AWS console, APIs, or SMTP

- use cases transactional, marketing, bulk email communications

## 374. Amazon Pinpoint

- scalable 2-way (outbound/inbound) marketing communication service
- email. `SMS`, push, voice, and in-app messaging
- like SES but with SMS and more options
- scales to billions of messages per day
- Use cases: run campaigns by sending marketing, bulk, transactional, SMS, messages


Amazon Pinpoint events


- SNS & SES you managed each message's audience content and delivery schedule
- In Amazon Pinpoint - you create message templates, delivery schedules, highly-targeted segments, and full blown campaigns


## 375. SSM Session Manager

- allows you start a secure shell on your EC2 and on prem servers
- no SSH access, bastion hosts, or SSH keys needed
- no port 22 exposure necessary (better security)
	- relies on an `SSM agent` which is connected to the session manager
	- relies on an IAM Role
- works on multiple OSs
- can send logs to S3 etc.


## 376. SSM  Systems Manager - Other Services

- Execute a document (Script) or just ru na command
- run command across multiple instances (using resource groups)
- No need for SSH (runs through agent)
- Command Output can be shown in the AWS console, s3, CloudWatch Logs
- Send notifications to SNS about command status 
- Integrated with IAM & CloudTrail
- Can be invoked using EventBridge

### Systems Manager - Patch Manager
- automates the process of patching managed instances
- on demand or schedule (maintenance windows)
- supports ec2 and on prem
- can get reports on patch compliance

### Systems Manager - Maintenance Windows
- self explanatory
	- scheule
	- duration
	- targets
	- tasks


### Systems Manager - Maintenance Windows
- simplify common mainteance and deployment tasks for ec2 instances and other aws resources
- ex. restart many instance, many ebs snapshots, create an AMI
- `Automation runbook` - ssm documents to define actions performed on your ec2 instance or AWS resources 
- Can be triggerd using
	- console, cli, sdk
	- amazon eventbridge
	- scheduled by maintenance windows

## 377. AWS Cost Explorer

- visualize, understand, manage your AWS costs and usage over time
- Create custom reports that analyze cost and usage data
- Analyze your data at a high level, total costs, usage across all accounts
- Choose an optimal savings plan
- can forecast

## 378. AWS Cost Anomaly Detection

- continuously monitor your cost and usage using ML to detect unusual spends
- will detect one time spikes and or continuous cost increases
- monitors your services, member accounts, cost allocation tags, cost categories
- sends you the anomaly detection report with root-cause analysis

## 379. AWS Outposts

- hybrid cloud: on prem infra + cloud infra
	- 2 different ways if dealing with IT
- "server racks" that offer the same AWS infra, services, API  tools, to build your own applications on-prem just as in the cloud
- AWS will setup and maange "outpost racks" within your on-prem infra and you can start leveraging AWS services on-prem
- `you become responsibile for the physical security of your rack now`

- Benefits
	- low latency access to on pre msystems
	- local data processing
	- data residency
	- easier migration from on-prem to cloud
	- managed service

## 380. AWS Batch

- managed batch processing at any scale
- ex 100,000s of batch jobs on AWS
- batch is a job with a start and an end (as opposed to continuous or streaming jobs)
- aws batch provisions the right amount of compute and memory
- submit/schedule and batch does the rest
- jobs are defined as `docker images and run on ECS`
- helpful for cost optimizations and focusing less on infra

### Batch vs Lambda
Lambda
- time limit
- limited runtimes
- limited temporary disk space
- serverless

Batch
- no time limit
- any runtime as long it is packaged as a docker image
- rely on EBS / instance store for disk space

## 381. Amazon AppFlow

- managed integration servie that enables secure trasnfer data between SaaS apps and AWS
- Source: `Salesforce`, SAP, Zendesk, Slack, ServiceNow `EXAM`
- Destinations S3, Redshift, non-AWS like Salesforce etc
- Frequency
- Data transformation
- Encrypted


## 382. AWS Amplify

- web and mobile development tool
- integrate a lot of the AWS stack into web application
- one place to configure
	- storage
	- auth
	- API
	- CI/CD
	- pubsub
	- analytics
	- ML 
	- monitoring
- connect your source code from GitHub, AWS CodeCommit, direct upload etc
- Can connect Amplify frontend libraries
	- react
	- next
	- angular
	- vue
	- etc

`Think of Amplify as the elastic bean stalk of mobile web apps`

## 383. Instance Scheduler on AWS

- not a service but an AWS solution deployed through CloudFormation
- `Automatically start/stop your AWS services to reduce costs`
- Ex. stop EC2 instances outside of business hours
- EC2, ASGs, RDS instances
- schedules are managed in a DynamoDB table
- Uses resource's tags and lambda to start/stop instances
- Supports cross-account and cross-region resources



## Quiz

Review
Elastic beanstalk
