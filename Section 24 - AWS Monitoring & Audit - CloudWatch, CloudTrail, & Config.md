# Section 24 - AWS Monitoring & Audit - CloudWatch, CloudTrail, & Config

## 271. CloudWatch Metrics

- Provides metrics for EVERY service in AWS
- a metric is a varaible to monitor (CPU util, bucketsize, networkin etc)
- Metrics belong to namespaces (one namesapce per servie basically)
- dimension is an attributre of a metric (i.e. isntance id, environment)
- up to 30 dimensions per metric
- metrics have timestamps
- can create a CloudWatch dashbaord of metrics
- Can create CloudWatch Custom Metrics (for RAM util on EC2)


### Metric Streams
- can be streamed outside of CloudWatch, near real time delivery low latency
	- can stream to Amaozn Kinesis Data Firehose (then any of its destinations)

## 272. CloudWatchLogs

- store application logs
- log groups
- log stream: instances within an application (log files, containers)
- can define log expiration policies
- Can send cloudwatch logs to
	- s3
	- kinesis data streams
	- kinesis data firehose
	- AWS lambda
	- opensearch
- logs encrypted by default with KMS or your own if you want

### Sources
- SDK, CloudWatch Logs Agent
- Elastic Beanstalk
- ECS collection from cotnainers
- AWS Lambda: collection from function logs
- VPC flow logs: VPC specific logs
- API gateway
etc.

### CloudWatch Logs Insights
Can query the logs within cloudwatch logs
- can view log lines
- automatically get visualization
- automatically discovers fields from AWS services and JSON log events
- query engine, not real time (historical only)
- can query cross-account

Can export logs to
- S3 (up to 12 hours to finish)

For real time streaming
`CloudWatch Logs Susbcriptions`
- get a real-time log event from CloudWatch logs for processing and analysis
- Send kinesis data streams, data firehose, or lambda
- Subscription filter: filter which logs are events delivered to your destination

Can aggregate logs corss-account
`Cross-Account Scrubtiption` filter - send log events to resource in a different AWS account (KDS, KDF)
and this needs IAM Role and destination access policy

### CloudWatch Logs Live Tail
- can view events as they happen

## 275. CloudWatch Agent and CloudWatch Logs Agent

- by default logs from EC2 do not go to CloudWatch
- need to run a `CloudWatch Agent` on EC2 to push the log files yo uwant
- Make sure IAM permissions are correct
- CloudWatch log AGENT can be setup on-prem too

### Logs Agent (old) & Unified Agent (new)
- virtual servers
- Cloudwatch logs agent
	- old version of the agent
	- can only send to cloudwatch logs
- Cloudwatch unified agent
	- collect additional system-level metrics such as RAM, processes, etc
	- colelct logs to sen to cloudwatch logs
	- centralized configuration using SSM parameter store

### Unified Agent Metrics
- cpu (active, guest, idle, system, user, steal etc...basically high granularity)
- Disk metrics
- RAM
- Netstat (TCP and UDP connections, net packets, byte)
- Processes
- Swap space


## 276. CloudWatch Alarms

- trigger notifications for any metric
- can be complex or simple
- alarm states
	- OK 
	- INSUFFICIENT_DATA
	- ALARM
- Period
	- length of time in seconds to evaluate the metric

### Alarm Targets
- Stop, Terminate, Reboot or Recovery EC2 instance
- Trigger Auto scaling Action
- Send notification to SNS

### Composite alarms
- alarm monitoring the state of multiple other alarms
- remember individual alarms are only on single metrics
- can use AND & OR conditions

### EC2 Instance Recovery
status check
- instance status 
- system status
- attached ebs status
recovery
- same private, public, EIP, metadata, placement group to your instance

### Good to know
- alarms can be created based on cloudwatch logs metric filter (i.e. too many of a keyword)
- to test alarms and notifications, set the alarm state using CLI
```sh
aws cloudwatch set-alarm-state --alarm-name "myalarm" --state-value ALARM --state-reason "testing purposes"
```
`EXAM`

## 278. EventBridge

- FKA cloudwatch events
- schedule: cron jobs (Scheduled scripts)
	- trigger lambda
- Event pattern: event rules to react to a service doing something
- IAM react to IAM Root User signing into the console
	- SNS topic with email notification
- Trigger lambda functions, send SQS/SNS 


### EventBridge Rules
Exam Sources
- EC2 instance start
- CodeBuild fail
- S3 Event upload
- CouldTrail any api call
- Schedule/Cron

-> `Amazon EventBridge` can intercept any event (and can filter certain events)

Event Brdige then generates a JSON document about the event
- Example Destinations
	- Lambda
	- AWS Batch
	- ECS Task
	- SQS
	- SNS
	- Kinesis Data Stream
	- Step function etc.....point is there are a lot

### Amazon EventBridge
`Default Event Bus` - represents services in AWS

`Partner Event Bus` - SaaS partners (external), zendesk, datadog etc think 3rd party

`Custom Event Bus` - your own custom apps can send events to event bridge

- event buses can be accessed by other AWS accounts using `resource-based policies`
- you can archive events (all/filter) sent to an event bus (indefinitely set or period)
- ability to replay archived events

### Schema Registry
- EventBridge can analyze the events in your bus and infer the schema
- The Schema Registry allows you to generate code for your app, that will know in advance how the data is structured in your bus

### Resource based policies
- `cross acount`
- manage permissions for a specific event bus
- example: allow/deny events from another AWS account or AWS region
- use case: aggregate all events from your AWS organization (central event bus) in as ingle AWS account

## 280. CloudWatch Insights and Operational Visibility

### Container Insights
-  collect aggregate summarize metrics and logs from containers
- available on ECS containers
- EKS
- kubernetes on EC2
- fargate

basically the containers rely on a containerized cloudwatch agent

### Contributor Insights
- analyze logs and create time series that display contributor data
	- i.e. top-N contributors
	- the total number of unique contributors and their usage
- works for any AWS-generated logs
- i.e. lets identify a bad host/heaviest network users

Example: would look at
VPC flow logs -> cloudwatch logs -> cloudwatch contributor insights -> top 10 IP address
`EXAM`
- can use custom or built in rules

### Application Insights
- provides automated dashboard that show potential problems with applications to help isoalte ongoing issues
- your applications un on EC2 with select technologies
- SageMaker powers this
- enhanced visibility for application health to reduce the time it will take you to troubleshoot and repair your application
- finding and alerts are sent to amazon eveventbridge and SSM OpsCenter

### Summary:
- CloudWatchContainer Insights
	- container insights
	- ECs, EKS, EC2 Kubernetes, Fargate
- CloudWatch Lambda Insights
	- detailed metrics to troubleshoot serverless applications
- CloudWatch Contributor Insights
	- Find "Top-N" contributors through CloudWatch Logs
- CloudWatch Application Insights
	- Automatic dashboard to troubleshoot your application and related AWS services
`EXAM this is the point`

## 281. CloudTrail Overview

- provides governance, compliance, and audit for AWS account
- enabled by default
- get a history of events / api calls made within your account by
	- console
	- SDK
	- CLI
	- AWS services
- can put into cloudwatch logs or S3
- a trail can eb applied to all regions (default) or a single region
- `i.e someone deleting something, need to figure out who` look in CloudTrail `EXAM`

### CloudTrail Events
- Management Events
	- operations performed on resources in your AWS account
	- i.e. configuring security, routing data, setting up logging
	- can separate read events from write events
- Data Events
	- data events are not logged (high volume) by default
	- i.e. S3 object level activity (getobject, deleteobject etc) can separate read and wite events
	- AWS lambda function execution activity
- CloudTrail Insights events
	- next slide

### CloudTrail Insights Events
- have to enable and pay
- will try to detect unusual activity
	- i.e. inaccurate resource provisioning
	- service limits
	- bursts of IAM action
	- gaps in periodic maintenance activity
- focuses on WRITE events
- analyzes normal management events to create a baseline

### CloudTrailEvents Retention
- store for `90 days in cloudtrail by default` `EXAM`
- to keep beyond this period log them to S3
	- can analyze them with Athena if you want


## 283. EventBridge - CloudTrail Integration

ClouldTrail can intercept API calls

lets say we delete a dynamoDB table
this call gets logged in cloudtrail

## 284. AWS Config

- helps with auditing and recording compliance of AWS resources
- `help record configuration changes over time`
- example problems
	- unrestricted SSH access to my security groups?
	- do my buckets have any public access?
	- how has my ALB config changed?
- per region
- receive SNS alerts
- can store outputs in S3
- cana ggreegate cross-region and cross-acount

### Config Rules
- AWS managed config rules (over 75)
- can make custom config rules (must be defined in AWS lambda)
	- i.e. evaluate if each EBS disk is of type gp2
- rules can be evaluated for each config change
	- or at regular time intervals
- `purely for audit`, does not hard-deny anything
- can setup `AWS Config Remediations` to take automatic action `EXAM`
- can setup `AWS Config Notifications` if you want things like an email upon changes to a resource


## 286. CloudTrail vs CloudWatch vs Config


`CloudWatch`
- performance monitoring
- metrics
- events and alerting
- dashboards
`CloudTrail`
- Record API calls made within your Account by everyone for everything
- can define trails for specific resources
- global service
`Config`
- record configuration changes
- evaluate resources against compliance rules
