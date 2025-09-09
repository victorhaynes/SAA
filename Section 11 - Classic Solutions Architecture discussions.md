# Section 11 - Classic Solutions Architecture discussions

## 125. WhatsTheTime.com


Stateless Web App: WhatIsTheTime.com

- allows people to know what time it is
- don't need a database
- want to start small, can accept down time

## 126. MyClothes.com

Stateful web app: myclothes.com
- shopping cart
- hundreds of users
- web app should be as stateless as possible (while maintaining necessary statefulness [shopping cart])
- details in database


Introducing ELB stickiness
- `stickiness/session affinity` allows for statefulness (stored on EC2) across the targets of an ELB
	- but if an instance gets terminated then the state is lost
- alternative: `user cookies`
	- alternative to `session affinity`
	- cookies make the application stateless
	- HTTP requests are heavier
	- cookies must be validated
	- cookies must also be less than 4KB
	- prone to attacks
- alternative `sever session`
	- may rely on `elasticache` underneath, i.e. cart content is stored in elasticache and is retrievable by ID
	- basically stores session data in a cache (rather than a relational database or cookie)

- storing user data in a database
	- store details in RDS
	- (relational databases)
	- note that most users just want to look things up in our app
	- so we can make DB read replicas to scale the reads
		- and or we can use `lazy loading`
		- looks for a cache hit or miss before responding
			- hit -> serve
			- miss -> GET from DB then write -> serve

- Disaster survive strategy
	- multi AZ load balancer (ALB open HTTP/HTTPS)
	- ASG across multiple AZs - EC2 can only be accessed by ALB
	- multi AZ RDS
	- multi AZ Elasticache (redis only)

## 127. MyWordPress.com

- Stateful web app: mywordpress.com

- Trying to create a fully scalable WordPress website
- want the website to access and correctly display picture uploads
- user data, blog content, should be stored in MySQL
- need global scaling

- `Revisit the purpose/benefit of Aurora for PSQL/MySQL`

Image storing options
- storing images with EBS
	- not scaling-friendly, if we scale horizontally then not every LB target/EC2 instance has the same data
	- good for one instance
- `EFS`
	- network file system
	- connects ENIs in each AZ
	- each EC2 instance can now access the EFS
	- EFS is complete shared with all the instance

- `Consider the practical difference of EFS vs S3 for storage`
- is EFS strictly private? `EXAM`

## 128. Intanstiating Applications Quickly

- Can take a lot of time to
	- install apps
	- insert or recover data
	- configure everything
	- launch the app

Can speed this up with a `golden AMI`
- Install your app, OS dependencies beforehand and create an AMI from it
- Then we launch our app/scale horizontally from the Golden AMI
- `Bootstrap using User Data` for dynamic configuration, user Data scripts
- `Hybrid` mix golden MAI and User Data (Elastic Beanstalk)


For RDS databases
- restore from a snapshot: the database will have schemas and data ready
- as opposed to doing a mass number of inserts
EBS Volumes
- restore from a snapshot the disk will already be formatted and have data


## 129. Elastic Beanstalk Overview

- manging gets complex
- deploying code
- configruing all the databases, load balancers,
- scaling cocnerns

- most web apps have similar architecture


- `Elastic Beanstalk` is a developer-centric view of deploying an application on AWS
- It uses all the component's we've seen before
- managed service
	- hands provisioning, load balancing , scaling, application health monitoring, instance config
- you bring the code
- free by itself but you pay for the underlying resources such as EC2 instances and databases
- requires a service role to have the ability to do stuff
	- underlying EC2 instances need an IAM instance profile with managed policies also
- runs on `CloudFormation` events under the hood


Beanstalk Components
- application (collection of components)
- application version
- environment
	- collection of AWS resources running an application version (only one version can run at a time)
	- tiers: web server environment tier, worker environment tier
	- can create multiple environments (dev, test, prod)

Beanstalk supports multiple platforms, from Node.js to docker to Ruby etc


Two man tiers
### Web Server Tier vs Worker Tier
Web server is classic web app relying on a client

![Screenshot 2025-08-11 at 1.37.04 PM.png](Screenshot%202025-08-11%20at%201.37.04%20PM.png)
worker tier
- scales based on the number of SQS messages
- can push messages to SQS queue from another web server tier `EXAM`

`EXAM`
### Deployment Modes
- single instance - great for dev

## 130. Beanstalk Hands On

