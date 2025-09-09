# Section 17 - Decoupling Applications - SQS, SNS, Kinesis, Active MQ

## 184. Intro to Messaging

- apps will need to communicate with another
- two patterns
	- synchronous communication (app to app, direct connect)
		- service 1 <---> service2
	- asynchronous / event based (a middleware queue)
		- service 1 -> QUEUE -> service 2

- Synchronous apps can be problematic if there are sudden spikes
- decoupling with scaling can solve this
- these services can scale independently from the application


## 185. SQS Simple Queue Services


- `producer` whatever sends a message -> send to queue
- `consumer` poll the messages in the queue -> process & delete message in queue

### SQS Standard Queue
- oldest offering
- managed
- used to decouple applications
- Attributes
	- unlimited throughput, unlimited number of messages in queue
	- default retention of messaging, 4 days max 14 days
	- low latency
	- limitation of 256KB per message sent (small)
- Can have duplicate messages (at least once delivery, possible)
- can have out of order messages (best effort ordering)
- unlimited throughput

### Consumers
- applications, can be cloud compute services or on-prem apps
- self explanatory
- responsible for deleting messages in the queue
- can have multiple consumers attached to the same queue / parallel processing
	- at least once delivery
	- best-effort message ordering
	- consumers delete messages after processing
	- can scale consumers horizontally to improve the throughput

Integrates perfectly with EC2 ASG (auto scaling groups)
- can scale based on Cloudwatch Metric: ApproximateNumberOfMessages

### SQS Security
supports encryption
- in flight using HTTPS by default
- at rest using KMS keys
- client side encryption support
access controls
- IAM policies to regulate access to SQS API
SQS access policies (similar to S3 bucket policies)
- useful for cross-account access to SQS queues

## 187. Message Visibility Timeout

- after a message is polled by a consumer it becomes invisible to other consumer
- default 30 seconds
- other consumer's polls will not show
- messages can be processed twice
	- to prevent this the consumer should call `ChangeMessageVisibility` API if it needs more time
	- will make the message not appear for X amount of time
`EXAM`

## 188. Long Poling

- a consumer must "wait" for messages to arrive if nothing is in the queue
- it can wait until something arrives then instantly consumer it
- this is called "LongPolling", basically doing a long API call instead of numerous shorter API Calls
- decrease latency
- can long-poll between 1-20 seconds. 
- preferably to short polling

## 189. FIFO Queues

- First in First Out (basically line a line of customers)
	- for generic SQS queues messages can be received out of order
- limited throughput, 300 msg/s without batching 3000 msg/s with
- exactly-once send capability
- messages processed in order by consumer
- Ordering by `Message Group ID` mandatory parameter

## 190. SQS + Auto Scaling Groups

- imagine a huge burst of traffic and a database would be overrun
- instead of writing to database all at once we can send transaction data into SQS (use as a buffer)
- then receive the message and insert it int othe database
- then delete the message from the queue

![Screenshot 2025-08-14 at 5.34.02 PM.png](Screenshot%202025-08-14%20at%205.34.02%20PM.png)

Note the client won't get an instant true confirmation because the database write happens later/eventually

`timeout`
`decoupling`
`scaling a lot`
`unlimited throughput`
think SQS

## 191. Amazon Simple Notification Service (SNS)

- what if we want to send one message to many recevers
- use `pub/sub` pattern


SERVICE -> publishes SNS topic
many RECEIVERS subscribe to the topic

- note receivers can filter messages
- can have millions of subs, and 1000s of topics

SNS
- can send emails
- SMS and mobile notifications
- HTTP(S)
- SQS
- Lambda
- Kinesis Data Firehose

SNS can RECEIVE data from
- cloudwatch alarms
- aws budgets
- s3
- lambda
- ASGs
- cloudfront etc
- AWS DMS
- RDS events etc...

### AWS Publushing
- Topic Publish (using SDK)
	- create a topic
	- create a subcription
	- publish to the topic
- Direct Publish (for mobile apps SDK)
	- create platform app
	- create paltform endpoint
	- pubish to platform endpoint
	- intergrates with google GCM, amazon APSN/amazon ADM
### Security
- Encryption
	- default in flight encryption
	- at rest KMS key encryption
	- can do client side encryption
- Access controls
	- IAM policies
- SNS Access Policies
	- similar to S3 bucket policies
		- useful for cross-account access to SNS topics

## 192. SNS and SQS Fan Out Pattern

- Push once in SNS, receive in all SQS queues that are subscribers (all SQS queues or subscribers will receive the message)
- Fully decoupled
- no data loss
- SQS allows data persistence, delayed processing, retries
- can all for more subs over time
- make sure SQS queue access policy allows write for SNS queue
- cross-region delivery

- For the same combo of `event type` and `prefix` you can only have one S3 Event rule
- if you want to send the same S3 event to many SQS queues then you use the fan-out topic
- this is a good workaround

- SNS has direct integration with KDF
- can send to Kinesis and then send to any KDF destination (i.e. S3 etc.)

### SNS FIFO Topic
- FIFO = ordering messages
- SNS works with FIFO
- but you get limited throughput as with any FIFO

### SNS Message Filtering
- JSON policy used to filter messages sent to SNS topics subscription
- if a sub doesn't have a filter policy it receivers every message


## 194. Amazon Kinesis Data Streams

- collect and store `streaming` data in `real time` `EXAM`
- could be click streams, IOT devices, metrics & logs 

To send to Kinesis we need a Producer
- could be an application
- could be a kinesis agent on your server

Need consumer applications in real time
- could be an application
- could be lambda
- could be Amazon Data Firehouse
- Managed Service for Apache Flink

### Kinesis Data Stream
- retention up to 365 days
- can reprocess (replay) data by consumers
- can't delete from kinesis (it must expire)
- Data up to 1MB - typically use lots of small real-time data
- data ordering guarantee for data with the same partition ID
- at rest KM encryption, in flight HTTPs encryption
- Kinesis producer library (KPL) - lib for optimizing kinesis producers
- Kinesis consumer library  (KCL) - lib for optimized kineses clients


### Kinesis Data Streams - Capacity Modes
- provisioned mode:
	- chose number of shards
	- each shard gets 1MB/s in or 1000 records per second
	- each shard gets 2MB/s out
	- scale manually to increase or decrease the number of shards
	- pay per shard provisioned per hour
- on-demand mode
	- no need to provision or manage capacity
	- 4 MB/s in or 4000 records per second
	- Scales based on observed peak in last 30 days
	- Pay per stem per hour and data in/out per GB


## 196. Amazon Data Firehose

- Load streaming data from sources into targets
- fully managed
- used to be called kinesis data firehose (KDF)
- automatic scaling, serverless, pay for what you uise
- near-real-time `EXAM` with buffering based on size/time
- supports CSV, JSON, txt, binary, parquet
- can transform using Lambda

PRODUCERS
- apps
- clients
- SDK
- Kinesis Agent
- Kinesis Data Stream
- Amazon CloudWatch Logs/Events
- AWS IoT

--> Amazon Data Firehose -->

Optional can transform using lambda function

---> Batch writes into various destinations

AWS specifid estinations
- S3
- Redshift
- Opensearch
3rd Party Destinations
- Data dog
- Splunk
- mongoDB
Custom Destinations
- HTTP Endpoint


### Data Streams vs Aamzon Data Firehose
Kinesis Data Streams KDS
- streaming data collection
- producer and consumer code
- real-time
- provisioned and on-demand mode
- storage for up to 365 days
- replay capability
Amazon Data Firehose ADF
- load streaming data into S3/Redshift/OpenSearch/3rd Party/custom HTTP
- fully managed
- Near real-time
- auto scaling
- no storage
- no replay capability



## 198. SQS vs SNS vs Kinesis


### SQS
- Consumers poll data
- Data is delted after being consumed by consumer
- Can have as many workers as you want
- managed service
- infinite scaling
- ordering guarantees only on FIFO queues
- Inndividiaul message delay capabilities

### SNS
- push data to many subs
- millions of subs per topic
- data is not persisted 
- pub/sub
- 1000s of topics
- no throughput provisioning
- Can `fan out` and combine SQS with SNS
- FIFIO capability for SQS FIFO

### Kinesis `EXAM` review
- standard: consumers pull data
	- 2MB per shard
- enhanced fan out: push data
	- 2 MB per shard per consumer
- possibly to replay data
- meant for real time big data, analytics and ETL
- ordering at the shard level
- data expires after X days
- Provisioned mode or on-demand capacity mode


## 199.  Amazon MQ


### Amazon MQ
- SQS and SNS are cloud-native proprietary protocols from AWS
- If you have traditional on-prem open protocols such as MQTT, AMQP, STOMP, Openwire, WSS etc.
- When migrating ot the cloud you may not want to re-engineer your application
- Here we can use Amazon MQ instead
- Amazon MQ is a managed message broker services for 
	- RabbitMQ
	- ActiveMQ

- Amazon MQ doesn't scale as much as SQS/SNS
- Amazon MQ run on sewrvers, can run in multi-az with failover
- Amazon MQ has both queue feature ~SQ (lokos like) and topic features ~SNS (lokos like)


### Amazon MQ High Availability
- active MQ broker in active AZ
- standby in MQ broker in separate AZ
- EFS is storage system that connects both
- EFS required for automatic failover
