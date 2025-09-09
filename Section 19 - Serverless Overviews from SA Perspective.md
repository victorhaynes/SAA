# Section 19 - Serverless Overviews from SA Perspective

## 215. Serverless



Serverless  Services in AWS
- Lambda
- DynamoDB
- AWS Cognito
- AWS API Gateway
- S3
- SNS & SQS
- Kinesis Data Firehose
- Aurora Serverless
- Step Functions
- Fargate


## 216. Lambda



- Virtual functions - no servers to manage
- limited by time - short executions ( <= 15 mins)
- run on-demand
- scaling is automated

Easy pricing
- pay per request and compute time
- generous free tier
many programming networks
Cloudwatch monitoring
increasing ram will improve network & cpu performance
can provision ram (up to 10GB) `EXAM`

Can run containers on Lambda but ECS and Fargate is the perferred solution


### Lambda Integration

API Gateway:  create api and trigger lambda from there
Kinesis: data transformations on the fly
DynamoDB:  create triggers, lambda can be triggered
S3: events trigger lambda functions
cloudfront: lambda at the edge
cloudwatch events eventbridge: invoke lambda function
cloudwatch logs: stream logs
SNS: reac to notifs
SQS: process messages

## 218. Lambda Limits and Concurrency

limits - per region `EXAM`
Execution
- memory 128MB to 10GB (1MB increments)
- increases the vCPU
- Max execution time 900 / 15 minutes
- Environment variables 4KB
- Disk capacity (ephemeral storage) 512MB to 10GB
- concurrency executions 1000 (can be increased)
Deployment
- lambda function deployment sized 50 MB
- Uncompressed 250 MB
- Can use the /tmp directory to load other files at startup
- size of environment variables 4KB


### Concurrency and throttling
- up to 1000 concurrent executions
- can set a` reserved concurrency` (at the function limit) exam
- each invocation over the conurrency limit will trigger a "Throttle"
- Throttle behavior
	- sync - returns 429
	- async - retries (internal event queue) for up to 6 hours then go to DLQ
		- exponential backups
- Can request a higher limit

### Lambda Concurrency Issue:
if users have the ability to invoke your lambda functions through a UI for example then one source of traffic may consume all of the scaling capacity



### Cold start:
new instance -> code is loaded and code outside the handler run (init)
so first request served by new instances has latency than the request

provisioned concurrency:
- workaround to the cold start
- application auto scaling can manage concurrency (schedule or target utilization)

Note:
- this has been reduced in significance but the concept still matters


### Lambda SnapStart
- improves lambda function performance up to 10x at no extra cost for
	- java
	- python
	- .NET
If you disable this:
we have init -> invoke -> shutdown

If you use snapstart
- function is pre-initialized behind the scenes

## 222. Lambda@Edge & CloudFront Functions


### Customization at the edge
- many modern apps execute some form of logic at the edge
- edge function
	- code that you write and attach cloudfront distribution
	- runs close to your users to minimize latency
- Two options
	- CloudFront Functions
	- Lambda@Edge

- Don't have to manage any servers, global
- Use case: customize content coming out of CDN


### Use cases:
- web security and privacy
- dynamic web application at thee dge
- SEO
- intent routing
- bot mitigation at the edge
- A/B resting
- real time image transformation
- user priority etc

### Cloudfront Functions
CLIENT -> `viewer response` -> CLOUDFRONT -> origin request -> ORIGIN
ORIGIN -> `origin response` -> CLOUDFRONT -> viewer response -> CLIENT
- Lightweight functions written in JS
- high scale, latency sensitive CDN customization
- sub-ms start up, millions req/s
- `used to change viewer requests and responses`
- cloudfront native
- cheaper than Lambda@Edge
- up to 1ms of execution time
### Lambda@Edge
CLIENT -> `viewer response` -> CLOUDFRONT ->` origin request` -> ORIGIN
ORIGIN -> `origin response` -> CLOUDFRONT -> `viewer response` -> CLIENT
- lambda functions written in NodeJS or Python
- Scales to 1000s of requests/second (less)
- `Used to change ALL CloudFront requests and responses`:
- Author your function in one AWS region *us-east-1* then AWS will create these functions globally
- up to 10 sec of execution time

### Use Cases
#### CloudFront Functions (think fast and inbound)
- cache key normalization
- header manipulation
- URL rewrites or redirects
- requests authentication & authorization

#### Lambda@Edge
- longer execution time
- adjustable CPU or memory
- can load dependencies, AWS DSK or AWS
- network access

## 223. Lambda in VPC

- `lambda is launched outside your VPC`
- therefore it cannot access your resoruces (RDS, ElastiCache, internal ELB etc)
- workaround:

### Lambda in VPC
- must define the VPC ID, the subnets, and security groups
- lambda will create an ENI (elastic network interface) in your subents

### Lambda with RDS proxy
- dont want concurrenct lambda functions connecting directly to a database (too many connections)
- solve this with an `RDS proxy` to pool and manage connections then the proxy connects to the RDS DB instance
	- improved scalability
	- improved failover time
	- enforced IAM authentication (@ RDS proxy level)
- remember: `MUST launch Lambda in VPC because an RDS proxy is strictly private` for this to work

## 224. RDS - Invoking Lambda & Event Notifications

- Invoke Lamda functions from within your DB instance
- Allows you to process data events from within a database
- Supported for RDS for PostgreSQL and aurora MySQL
- Must allow outbound traffic to your Lambda function
- from within your DB instance (Public, NAT GW, VPC Endpoints)
- DB instance msut have the required permissions to invoke the lambda function (lambda resource-based & IAM policy)
- `invoking Lambda from RDS/Aurora` gives you access to the DB data itself `EXAM`

this is in front of:
### RDS Event Notifications
- notifications that tell you information about the DB instance itself (Created, stopped, start)
- Do NOT have information abotu the data itself `EXAM` (think metadata)
- Subscribe to the follow: DB instance, snapshot, parameter group, security group, proxy etc.
- Near-real time events

## 225. DynamoDB

Fully managed, highly available with replication across multiple AZs
No SQL database - not a relational database - with transaction support
Scales to massive workloads, internally distributed databases
Extreme scaling capability
Single millisecond performance
Integrated with IAM
low cost and auto scaling
no maintenance or patching, always available
standard class & infrequent access (IA) table class


### Basics
- DB already exists
- you just create `tables`
- each table has a primary key PK
- infinite number of items/rows
- attributes
- `easy schema modification (unlike relational DBs)` EXAM
- max size of an item is 400KB `EXAM`

### Read/Write Capacity Modes
- control the the table capacity
	- `Provisioned Mode (default)`
		- provisioned in advanced
		- planned in advanced
		- specify reads/writes per second
		- pay for provisioned read capacity and write capacity units RCU/WCU
		- possibility to add auto-scaling mode for RCU & WCU
			- can set min and max targets and % util for auto scaling
		- cheaper
		- best for known workloads, slow scaling
	- `On-Demand Mode`
		- auto scaling
		- planning for what you use
		- pay for what you use, but higher rate
		- great for unpredictable workloads, steep sudden spikes

## 227. DynamoDB Advanced Features


### DynamoDB Accelerator (DAX) 
- fully managed, highly available, seamless in-memory cache for DynamoDB
- Help solve read congestion by caching
- Microseconds latency for cached data `EXAM`
- doesn't require any application log modification

### DAX vs. ElastiCache
Elasticache:
- store aggregation result / big computation result
DAX:
- individual object cache
- query & scan cache

### Stream Processing
- stream of item-level modifications (crud) in a table
- use cases
	- react to changes in real-time (welcome email)
	- real time usage analytic
	- insert into derivative tables
	- implement cross-region replication
	- invoke AWS lambda or changes to your DynamoDB table

### DynamoDB Streams
- 24 hours retention
- limited # of consumers
- process using AWS lambda triggers or dynamodb stream kinesis adapter

### Kinesis Data Streams
- 1 year retention
- high # of consumers
- process using AWS lambda, kinesis data naalytics, kinesis data firehosue, aws glue streaming ETL

### DynamoDB streams
Application crud -> TABLE -> Dynamo DB streams - > processing layer (lambda/dynamoDB KCL adapter)


Application crud -> TABLE -> Kinesis Data Streams -> Data Firehose


### DynamoDB Global Tables
- table replication cross region
- two-way replication
- low latency in multiple regions
- active-active replication (both read and write)
- DynamoDB Streams must be enabled `EXAM`

### DynamoDB TTL
- automatically delete items after an expiry timestamp

### DynamoDB - backups for disaster recovery (DR)
- continuous backups using PITR recovery (point in time recovery)
	- optionally enabled for the last 35 days
	- any time in the window
	- recovery process creates a new table
- on-demand backups
	- full backups for long term retention until explicitly deleted
	- doesn't affect performance or altency
	- can be integrated with AWS backup (enables cross-region copy)
	- recovery creates a new table

### DynamoDB with S3
- export to S3 (must enable PITR)
	- then run Athena on top of S3
	- can be for ETL user
	- snapshots for auditing
- import from S3
	- import CSV, JSON, ION format
	- creates new table

## 228. API Gateway Overview

Building a serveless API

Client -> API Gateway (REST API) -> Lambda <- CRUD -> DynamoDB

- Supports the websocket protocol
- handle API versioning
- handle different environments (dev, test, prod...)
- handle security (authentication and authorization)
- create API keys, handle request throttling
- swagger / open API import to quickly define APIs
- Transform and validate requests and responses
- Generate SDK and API specs
- cache API responses

### Integrations High Level
- Lambda
	- most common way to expose a REST API backed by AWS
- HTTP
	- expose HTTP endpoints in the backend
	- example: internal HTTP API on-prem, ALB
	- add rate limiting, caching, user auth, API keys etc
- AWS Service
	- expose ANY AWS API through the API gateway
	- add authentication, deploy publicly, rate control

### Deployment Options (Endpoint Types)
- Edge-Optimized (defaut): global clients
	- requests routed through cloudfront edge locations (low latency)
	- the api gateway still lives in only one region
- Regional:
	- for clients within the same region
	- could manually combine with cloudfront (fine control over the level of caching and distribution)
- Private
	- can only be accessed from your VPC using an interface VPC endpoint (ENI)
	- use a resource policy to define access

### API Gateway - Security
- User authentication through
	- IAM roles (useful for internal applications)
	- Cognito (for external users)
	- Custom authorizer (your own logic, in Lambda)
- HTTPS security through integration with ACM
	- cert must be in us-east-1 if using an edge- optimized endpoint
	- if using a regional endpoint the cert must match region
	- must setup CNAME or a-alias record in route53

## 230. Step Functions

- build a serverless visual workflow to orchestrate your lambda functions
- (kind of like visual scripting)
- integrates with EC2, ECS, on-prem servers, API gateway, SQS queues
- can integrate human approval etc
- Use cases: order fulfillment, data processing , web application, any workflow


## 231. Amazon Cognito Overview

- give user identity to interact with web or mobile application (users outside of our AWS account)
- `Cognito User Pools`
	- sign in functionality for app users
	- integrate with API gateway & ALB
	- cognito identity pools
- `Cognito Identity Pools`
	- provide AWS credentials so they can access AWS resource directly

- Cognito vs IAM: hundreds of user s+, mobile users, authenticate with SAML
### `Cognito User Pools `(CUP) - User features
- serverless database of user for your web and mobile apps
- simple login
- password reset
- MFA
- email and phone verification
- federated identities (google, facebook, SAML OpenID, etc)

### CUP Integrations
- integrates with API Gateway and ALB `EXAM`

### `Cognito Identity Pools` (Federated Identities)
- get identities for users so they obtain temporary AWS credentials
- users source can be cognito user pools, 3rd party logins
- then Users can access AWS services directly
- Can have guests inherit IAM roles
