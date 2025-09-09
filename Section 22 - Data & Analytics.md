# Section 22 - Data & Analytics

## 246. Athena



`need to review entire section`

- serverless query service to analyze data stored in S3
- uses SQL to query files built on Presto
- Supports CSV, JSON, ORC, Avro, Parquet
- Pricing: $5.00 per TB of data scanned
- Commonly used with Amazon Quicksight for reporting/dashboards

Use cases: BI, analytics, reporting, analyze & query VPC flow logs, ELB logs, CloudTrail trails

`EXAM`: analyze S3 data using serverlss SQL

### Athena Performance
- use `columnar data` for cost-savings (less scanning = less scans)
	- Recommend format is `Apache Parquet` or `ORC` format
	- huge performance improvement
	- Use `Glue` to convert your data to `Parquet` or `ORC`
- Compress data for smaller retrievals (zip)
- Partition data sets in S3 for easy querying on virtual columns
- Example:
	- s3://athena-examples/flight/parquet/year=1991/month-1/day=1/
- Use larger files to minimize overhead


### Federated Query
- allows you to run SQL quewries across data stored in relational, non-relational, object and custom data sources (AWS or on-prem)
- Uses data source connectors that run on AWS lambda to run federated queries (eg cloudwatch logs, dynamoDB, RDS)

## 248. Redshift

- Based on PostgreSQL but NOT used for OLTP
- USed or `OLAP`
- 10x better performance than other data warehouses
- Columnar sotrage (isntead of row based) and parallel query engine
- Two modes
	- provisioned cluster
	- serverless cluster
- SQL interace for performing the queries
- BI tools such as Aamaozn quicksigfht or Tableu
- `vs Athena` faster queries, joins, aggregations thanks to indexes...but not serverless

### Redshift Cluster
- Leader node: for query planning and results aggregation
- Computer node: for performing the queries, send results to leader
- Provisioned mode:
	- choose instance types in advance
	- can reserve instances for cost savings

### Snapshots & DR
- single AZ for most clusters
- multi AZ for some cluser types
- snapshots are PIT backups
- snapshots are icnremental
- can restre snapshots into a new cluster
- autoamted, every 8 hours, or every 5 GB, or on a schedule set retention
- manual snapshot is retained until you delete it

You can configure amazon redshift to automatically copy snapshots
- can restore cross-region from a snapshot

### Loading data into redshift
`large inserts are much better`
- Amazon Kinesis Data Firehose
- S3 using COPY command
- EC2 instance JDBC driver

### Redshift Spectrum
- query data that is already in S3 without loading it
- must hav a redshift cluster already available

## 249. OpenSearch (ex. ElasticSearch)

- Successor to ElasticSearch
- In DymanoDB you can only query by PK or indexes
- With OpenSearch you can search any field, even on partial matches
- Common to use OpenSearch as a compliment to another database
- Two modes: managed cluster or serverless cluster
- does not natively support SQL
- Ingestion from KDF, AWS IoT, Cloudwatch logs
- Security through cognito & IAM, KMS encryption, TLS
- comes with OpwnSearch Dashbaords (visualization)


### OpenSearch patterns
- DynamoDB table -> dynamoDB stream -> lambda function -> open search

Same thing works for CloudWatch Logs but using CloudWatch & a Subscription Filter
or can send to Kinesis DAta Firehose (instead of Lambda) for near-real time

### OpenSearch patterns Kinesis Data Streams & Kinesis Data Firehose
`Review Kinesis` - `EXAM`

## 250. EMR

- Elastic MapReduce
- helps create `Hadoop` clusters (big data) to analyze and process vast amount of data
- Clusters have be provisioned, can be hundreds of EC2 instances
- EMR comes bundled with apache Spark, HBase, Presto, Flink
- EMR takes care of provisioning and configuration
- Auto scaling enabled and integrated with spot instances

Use cases: data processing, machine learning, web indexing, big data `EXAM`

### Node TypeS & Purchasing
- Master Node: manage the clsuter, coordinate manage health - long running
- Core Node: Run tasks and store data - long running
- Task Node (optoinal): just to run tasks - usually spot instances
- Purchasing options:
	- on-demand reliable, predicable, won't be terminated
	- Reserved (min 1 year): cost savings (EMR will automatically use if available)
	- Spot Instances: cheaper, can be terminated, less reliable
- Can have long-running cluster, or transiet (temporary) cluster

## 251. QuickSight

- Serverless machine learning powered BI services to create interactive dashboards
- fast, automatically scalable, embeddable, with per-session pricing
- Use cases
	- self explanatory
	- also 3rd party sources such as salfesforce, Jira, JDBC, teradata
	- can import
		- CSL
		- CSV
		- TSV
		- JSON
		- ELF/CLF (log format)
		- then if we import we can do in-memory SPICE engine computation for fast performance
- Integrated with many data sources
- In-memory computation using `SPICE` engine if data is actually IMPORTED into QuickSight `EXAM`
- Enterprise editionL Possible to setup Column-Level security (CLS)
### Dashboard & Analaysis
- Define Users and Groups
- These users and groups only exist within QuickSight not IAM
- A dashbaord
	- is a read only snapshot of an analysis that you can share
	- preservers the configuration of the analysis (filtering, parameters, controls, sort)
- You can share the analysis or the dashboard with Users or Groups
- To share a dashboard, you must first publish it
- Users who see the ashboard can also see the underlying data

## 252. Glue

- Managed ETL service 
- useful to prepare and transform data for analytics
- fully serverless

`EXAM`
### Convert data into Parquet (columnar) format
- If you have CSV files in S3
- convert it to Parquet using Glue 
- into an ouput S3 bucket
- Then can use Athena for a better analysis (Cheaper/faster)

Can put Event notifications on S3 PUT then have lambda automate this process

### Glue Catalog: catalog of datasets
- `AWS Glue Data Crawler`
	- write all metadata to a AWS Glue data catalog (tables, metadata)
	- can connect to s3, rds, dynamodb, on-prem JDBC etc
- Athena
- Redshfit Spectrum
- EMR all rely on glue data catalog


`EXAM`
### Other things to know
- `Glue Job Bookmark` prevent re-processing old data
- `Glue DataBrew` clean and normalize data using pre-built rasnformation
- `Glue Studio`: new GUI to create, run and monitor ETL jobs in Glue

## 253. Lake Formation

- Helps create data lakes
- Central place to have all your data for analytical purposes
- managed services that makes it easy (days rather than months)
- discover, cleans, transform, and ingest data into your data lake
- automates many complex manual steps
- combine structured and unstructured data in the data lake
- out of the box source blueprints: S3, RDS, on-prem SQL, NoSQL DB etc
- Can have `fine grained access control` for your applications (row and column-level)
- Built on top of AWS Glue

### Lake Formation

## 254.  Amazon Managed Service for Apache Flink

- Flink (Java, Scala or SQL) a framework for processing data streams in real time

Amazon MAnaged Service for apache Flink can read data from `Kinesis Data Streams` or `Apache Kafka`
- can run any Apache Flink application on a managed cluster on AWS
	- provisioned compute resources, parallel computation, automatic scaling
	- application backups
	- use any Flink programming features to transform data

## 256.  MSK - Managed Streaming for Apache Kafka

- Alternative to Amazon Kinesis
- Fully managed Apache Kafka on AWS
- Allows to create update and delete clusters 
- MSK creates ,manages, kafa broker nodes and zookpeeper nodes for you
- automatic recovery from common apache kafka failures
- data is stored on EBS volumes for as long as you want

Can use
- MSK Serverless
- Run Apache Kafka on MSK without managing the capacity
- MSK automatically provisions resources and scales compute and storage

### Apache Kafka at a high level

- MSK cluster
	- n-brokers
Producers (your code)

sends data from various sources to write to topic
Consumers then poll from topic

### Kinesis DAta Streams vs Amazon MSK
KDS
- 1MB message size limit
- Data Streams with Shards
- Shard Splitting & Merging shards
- TLS In-flight encryption
- KMS at rest encryption
Amazon MSK
- 1MB default, can configure higher
- Kafka Topics with Partitions
- Can only add partitions to a topic
- PAINTEXT or TLS In-flight Encryption
- KMS at-rest encryption
- can store data as long sa you want in EBS

### Amazon MSK Consumer
Kinesis DAta Analytics for Apache Flink can consume
AWS Glue for ETL jobs
Lambda
Write Kafka consumers on whatever you want like EC2/ECS/EKS


## 257. Big Data Ingestion Pipeline

- want the intention pipeline to be serverless
- collect in real time
- transform the data
- query usin SQL
- reports can be stored in S3
- want to load that data into a warehouse and create dashboards

### Big Data ingestion pipeline

IoT Devices -> send data in real-time -> Kinesis data streams -> kinesis data firehose (every 1 minute, and Lambda can be linked to data firehose-> s3 bucket (ingestion)

from S3 we can trigger a SQS queue (optional) -> lambda -> amazon athena SQL query
-> store report in S3 from S3 can then feed into quicksight or redshift


### Big Data Ingest Pipeline discussion
- `IoT Core` allows you to harvest data from IoT devices
- Kinesis is  great for real-time data collection
- Firehose helps with data delivery in near-real time to S3 (1 minute min)
- Lambda can trigger S3 notifications to SQS
- Lambda can subscribe to SQS
- Athena is serverless SQL service and results are stored in S3
- The reporting bucket contains analyzed data and can be used by reporting tool such as AWS quicksight, redshift, etc

