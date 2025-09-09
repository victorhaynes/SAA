# Section 21 - Databases

## 236. Database Types

`RDBMS` = SQL/OLTP: RDS, Aurora, great for joins
`NoSql` = DynamoDB, ElasitCache, Neptune, DocumentDB, Keyspaces, no joins, no SQL
`Object Store` big objects
`Glacier` backups and archives
`Data Warehouse` SQL Analytics/BI: Redshift (OLAP), Athena, ERM
`Search` OpenSearch - free text, unstructured searches
`Graphs` Amazon Neptune - displays relationships between data
`Ledger` Amazon Quantum Ledger Database
`Time Series` Amazon Timestream



## 237. RDS

### Summary
- Managed PostgreSQL, MySQL, Oracle, SQL Server, DB2, MariaDB, Custom
- Provisioned RDS isntance Szie and EBZ Volume Type & Size
- Auto scaling capability for storage
- support for read replicas and multi AZ (recovery only, for HA)
- Security through IAM, security groups, KMS, SSL in transit
- Automated backup with point in time restore feature (up to 35 days)
- Manual DB snapshot for longer-term recovery
- managed and scheduled maintenance (with downtime)
- support for IAM authentication, integration with. secrets manager
- RDS custom for access to customize the underlying isntance (Oracle & & SQL Server)


## 238. Aurora

- Compatible for PostgreSQL and MySQL
- Storage and compute is separate
- Storage
	- stored across 6 replicas across 3 AZs, highly available, self-healing, auto scaling
- Compute:
	- cluster of DB instance across multiple AZ, auto-scaling of read replicas
- Cluster: custom endpoints for writer and reader DB instances
- Same security, monitoring, maintenance features as RDS
- Know the backup and restore options for Aurora `EXAM`
- `Aurora Serverless` - for unpredictable / intermittent workloads, no capacity planning
- `Aurora Global` up to 16 DB read Instances in each region, < 1 second storage replication `EXAM`
- `Aurora Machine Learning` perform ML using SageMaker & Comprehend on Aurora
- `Aurora Database Cloning` new cluster from existing one, faster than restoring a snapshot

## 239. ElastiCache

- Managed Redis / Memcached (like RDS for caches)
- in memory data store, sub-millisecond latency
- select an ElastiCache instance type (i.e. cache.m6g.large)
- Support for Clustering (REdis), multi Az, read replicas/sharding
- security through IAM, security groups, KSM, redis auth
- backup / snapshot / point in time restore feature
- managed and scheduled maintenance
- `Requires some application code change to integrate ElastiCache`


## 240. DynamoDB

- Proprietary technology, managed serverless NoSQL database, millisecond latency
- Capacity modes
	- Provisioned: smooth workload
	- On-Demand capacity: auto scaling, unpredictable workloads
- Can replace ElastiCache as a key/value store (good for storing session data, supportS TTL)
- Highly Available, MultiAZ, read and writes are decoupled, transaction capability
- `DAX cluster for reach cache, microsecond read latency` `EXAM`
- Security is done through IAM
- Event processing: dynamoDB streams to integrate with AWS lambda, or kinesis data streams
- Global Table feature: active-active replication across multiple regions
- Automated backups, must enable PITR up to 35 days, or can do on-demand backups and store them as long as you want
- Export table to S3 without using an RCU within the PITR window, can import from S3 without using WCU
- `Great to rapidly evolve schemas`


## 241. S3

- key/value store for objects
- great for big objects
- serverless
- infinite scaling
- max 5TB object size, versioning
- Tiers: S3 standard, IA, intelligent, glacier + life cycle policies
- Features: versioning, encryption, replication, MFA-delete, access logs
- Security: IAM, bucket policies,l ACL, access point, object lambda, CORS, object/vault lock
- Encryption: SSE-S3, SSE-KMS, SSE-C, client-side, TLS in transit, default encryption
- Batch operations: on objects using S3 batch, listing files using S3 Inventory
- Performance: multi-part upload, S3 transfer accelerations, S3
- automation: s3 event notifications (SNS, SQS, Lambda, EventBridge)


## 242. DocumentDB

- Aurora is an AWS-implementation of PostgreSQL/MySQL
- `DocumentDB` is an AWS-implementation for MongoDB (noSQL `EXAM`)
- used to store query and index JSON data
- similar deployment concepts as Aurora
- Fully managed, highly available with replication across 3AZ
- DocumentDB storage automatically grows in increments of 10GB


## 243. Neptune

- Fully managed `graph` database `EXAM`
- Example graph data set is a social network
- Highly available across 3 AZ, with up to 15 read replicas
- Build and run applications working with highly connected datasets, optimized for these complex and hard queries
- can store up to billions of relations and query the graph with milliseconds latency
- highly available for with replications across multiple AZs
- great for knowledge graphs (wiki), fraud detection, recommendation engiens, social networking

Graph database <-> Neptune


### Neptune Streams
- think logs
- `real-time ordered sequence` of every change in your database
- Changes are available immediately after writing
- No duplicates, strict order
- Streams data is accessible in an HTTP Rest API
use cases:
	send notifications when certain changes are made
	maintenance data synchronization in a different data store

## 244. Keyspaces for Apache Cassandra

- Apache Cassandra is an open-source NoSQL distributed database
- Managed, Apache Cassandra-compatible database service
- serverless, scalable, highly avail, fully managed by AWS
- Automatically scales tables up/down based on the applications's traffic
- Tables are replicated 3 times across multiple AZ
- Using the cassandra query language (CQL)
- Single-digit millisecond latency at any scale, 1000s of requests per second
- Capacity: On-Demand mode or provisioned mode with auto-scaling 
- Encryption: backup, point in time recovery PITR up to 35 days

Use cases: store IoT devices info, time-series data


## 245. Timestream

- managed, fast, scalable serverless `time series database`
- automatically scales up/down to adjust capacity
- store and analyze trillions of evnets per day
- 1000s times faster & 1/10th the cost of relational databases
- scheduled queries, multi-measure records, SQL compatibility
- Data storage tiering:
	- recent data kept in memory and historical data kept in cost optimized storage
- Buitl-in time series analytic functions (helps identity patterns in near real time)
- Encryption in transit and at rest

Use cases: IoT apps, operational apps, real-time analytics

### Architecture
Can received data from AWS IoT
Kinesis Data Streams through Lambda or Kinesis Data Analysis For Apache Flink
Amazon MSK through Kinesis Data Analytics For Apache Flink

can connect to other AWS services or anything that accepts JDBC connection

