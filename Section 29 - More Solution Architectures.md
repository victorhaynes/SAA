# Section 29 - More Solution Architectures

## 364. Event Processing in AWS

### First
Lambda, SNS, and SQS (polling or FIFO)
Have SQS send failed messages to DLQs , setup on the SQS side


### Second
SNS & Lamba (asynchronous, lambda does internal retries)
this means the DLQ would be on the LAMBDA side


### Fan Out Pattern: deliver to multiple SQSs
Have an SNS topic in the middle, and multiple SQS queues subscribe to it
```txt

	-> SQS
SNS -> SQS
	-> SQS
```

# S3 Event Notifications
- use case: generate thumbnails
- send S3 event to SNS, SQS, lambda function `EXAM`
- can take

### S3 Event Notifications with Amazon EventBridge
- S3 -> Amazon EventBridge -> over 18 AWS services
	- kinesis streams
	- kinesis firehose
	- step functions
	- event bridge capabilities - archive, replay etc

### Intercept API Calls
- can intercept ANY api call using CloudTrail
	- can have a call trigger an Event in Amazon EventBridge

## 365. Caching Strategies in AWS

- Caching at the edge (cloudfront) - as close to the user as possible
- TTLs - self explantory

- API Gateway has cacheing capabilities (regional caching, regional service)

- an application itself can use a cache in front of its database


## 366. Blocking an IP Address in AWS

first line of defense
- NACL on the public subnet (Deny + Allow rules, stateless)
- Security Group (allow rules only, stateful)
- Application/software level firewall (optional)

Can pair an ALB with WAF
- has a cost
- IP address filtering @ the ALB level
- lot of control and defense if your ALB is exposed directly

CloudFront
- can also put WAF on a CloudFront cache
- If your CloudFront is in front of an ALB then note that your NACL for your public subnet will not filter anything, becasue everything is proxied through the cloudfront distribution

## 367. High Performance Computing (HPC) on AWS

`EXAM`
- cloud is perfect place for HPC
- can create a very high number of resource in no time
- can speed up time to results by adding more resources
- you can pay only for the systems you have used

- perform genomic, computational chemistry, final risk modeling ,weather prdiction, ML, deep learning, etc

### Data Management and Transfer
- AWS DX
	- Move GB/s of data ot the cloud over private network
- Snowball & Snowmobile
	- Move PB of data to the cloud
	- good for one offs
- DataSync
	- Move large amoutns of data from on prem to S3, EFS, FSx for Windows

### Compute and Network
- EC2 Instances
	- CPU optimized, GPU optimized
	- Spot instances / spot fleets for cost savings + auto scaling
- EC2 Placement Groups: Cluster for good network performance
	- same rack, same AZ

### Further Improvements
- EC2 enhanced networking (SR-IOV)
	- higher bandwidth higher PPS (packet per second), lower latency
	- Option 1 `Elastic Network Adapter (ENA)` up to 100 Gbps `EXAM`
	- Option2: Intel 82599 VF up to 10Gbps - Legacy `EXAM`
- Elastic Fabric Adapter `EFA`
	- Improved ENA for HPC, only for Linux
	- Greate for inter-node communications, tightly coupled workloads
	- Leverages `Meessage Passing Interface` (MPI) standard
	- Bypasses the underlying Linux OS to provde low-latency, reliably

`Exam` ENI vs EFA vs ENA


### Storage
- Instance attached storage
	- EBS, scale up to 256,000 IOPS with io2 block express
	- Instance store: scale to millions of IOPS, linked to EC2 instance, low latency
- Network storage:
	- S3: larg blob, not a fiel system
	- EFS: scale IOPS based on total size, or use provisioned IOPS
	- Amazon FSx for Lustre
		- HPC optimized
		- backed by S3

### Automation and Orchestration
- AWS Batch
	- supports multi-node parallel jobs, can span multiple EC2 instances
	- easily schedule jobs and launch EC2 instances accordingly
- AWS Parallel Cluster
	- Open-source cluster management tool to deploy HPC on AWS
	- Configure with text files
	- Automate creation of VPC, Subnet, cluster type and instance types
	- `Ability to enable EFA on the cluster (improves network performance)`
		- EXAM


## 368. EC2 Instance High Availability


### Creating a highly available EC2 instance
- EC2 is default launched in one AZ

# Basic setup
- EC2 instance with EIP
- Standby instance
	- setup cloudwatch event or alarm based on a metric (i.e. CPU util 100%)
	- trigger a lambda function to start the standby EC2 instance & attach the EIP to the standby instance


### High availability using an ASG

interesting setup. ASG config:
1 min
1 max
1 desired
`>=` 2 AZs
this means if an instance fails in one AZ the next one will spin up in a different AZ


- spanning 2 AZs
- user talks to app using EIP
- user user data script to attach EIP at time of spinup (no lambda needed)
	- (would need Instance roles to allow the instance to make API calls)


### Highly available EC2 instance with ASG + EBS
- same setup but with EBS volumes
	- if an EC2 instance relies on an EBS volume
	- then we can use `ASG` on-Terminate `lifecycle hook`
		- to snapshot the EBS volume

## Quiz

