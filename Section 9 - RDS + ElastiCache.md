# Section 9 - RDS + ElastiCache

## 1-RDS Overview

- Relational Database Services
- Managed DB service for SQL databases
- Engines `EXAM`
	- PSQL
	- MySQL
	- MariaDB
	- Oracle
	- Microsoft SQL Server
	- IBM DB2
	- Aurora (AWS propietary)

### Benefits
- RDS is managed
- automated provisioning, OS patching
- continuous backups, restore to timestamp
- monitoring dashboards
- read replicas
- multi AZ setup for disaster
- recovery
- maintenance windows
- scaling capability
- storage backed by EBS

But CANNOT SSH into the underlying instance

### Storage Auto Scaling
- helps increase storage dynamically
- automatically
- can set maximums
- can set scaling rules
	- i.e. low storage at least 5 mins
	- 10% of allocated storage

## 2-RDS Read Replicas vs Multi AZ

`EXAM`

## Read replicas
- help scale the READS
- up to 15 within the same AZ, Cross AZ, or Cross Region `EXAM`
- replication is asynchronous, will eventually produce consistent reads
- replicas can be promoted to their full database
- application must update the connection string to leverage read replicas

### Classic Use case
- prod database is taking on a normal load
- want to run reporting and analytics on the data
	- but this will produce more stress on the DB
- solution: create read replica and run the analytics on the read replica
- READ operations only (i.e. SELECT never INSERt, UPDATE, DELETE)

### Network Cost
- normally it costs to send data from one AZ to another in AWS
- For RDS read replicas if they are in the same REGION cross-AZ traffic is FREE
- this is typically how this works for managed services

## RDS Multi AZ (Disaster Recovery)
- SYNCHRONOUS replication
- One DNS name - automatic app failover to standby
- increase availability
- failover in case of loss of AZ, loss of network, instane or storage failure
- NOT USED for scaling -- no one can manually read or write to it
- Note the read replicas can be setup as multi AZ for disaster recovery

These are two different concepts


`EXAM`
Turning a single-AZ database to Multi-AZ

## 3-RDS Custom for Oracole and Microsoft SQL Server

- managed oracle and microsoft SQL server database with OS and databae customization
- custom: access to the nuderlyin database and OS
	- configure settings
	- install patches
	- enabled native features
	- access the underlying EC2 instance using SSH or SSM manager
- de-activate automation mode to perform your customization, better to take a DB snapshot before
- RDS vs RDS custom
	- RDS will manage entire database an the OS to be managed by AWS

## 4-Amazon Aurora

- proprietary tech from AWS
- compatible with Postgres and MySQL only
- Aurora is "AWS cloud optimized", claims 5x performance over MySQL on RDS and 3x performance on RDS
- Aurora storage atuomatically grows in increments of 10GB up to 129TB
- Up to 15 read replicas
- Failover in Aurora is instanenous 
- Aurora is more expensive than RDS but is much more efficient

### Aurora High Availability and Read Scaling
- 6 copies of your data across 3 AZ
	- 4 copies out of 6 needed for writes
	- 3 copies out of 6 needed for reads
	- self healing with peer-to-peer replication
	- storage is striped across 100s of volumes
- One Aurora (master) instance takes writes
- Automated fail over in less than 30 seconds
- Master + up to 15 read replicas
- Read replicas support cross region replication
	- `Reader Endpoint`
		- helps with connection load balancing, basically a load balancer / single point of origin for your read replicas which can auto scale `EXAM`
		- note this is at the connection level, cannot load balancer read replicas based on queries
- shared storage volume that automatically expands

- isolation and security
- industry compliance
- backtrack restore at any point in time
- advanced monitoring
- automated patching etc


### Capacity
- can set the underlying instance

## 5-Aurora Advanced Concepts

### Aurora Replicas - Auto Scalings
- writing through the writer endpoint
- reading through the reader endpoint
	- the replicas underneath can be auto-scaled
- not that all of these use shared storage volume


- note we can use `custom endpoints`
	- to point to more powerful underneath replicas (i.e. db.r3.large vs db.r5.2xlarge)
- generally speaking if you are custom endpoints you stop using the generic `reader endpoint`


### Aurora Serverless
- automated database instantiation and auto scaling based on actual usage
- good for infrequent, intermittent, or unpredictable loads

### Global Aurora
- cross region read replicas
	- useful for disaster recovery
	- simple to put in place
- Aurora global database
	- 1 primary region
	- up to 5 secondary read-only regions, replication lag is less than 1 second
	- up to 16 read replicas per secondary region
	- promoting another region for DR has an RTO of less than 1 minute
	- `Typically takes less than1 second for cross-region replication` EXAM

### Machine Learning
- enables you to add ML based predictions to your applications via SQL
- simple, optimized, and secure integration between aurora and ML services
	- integrates with SageMaker
	- Comprehend
- use case
	- fraud detection
	- ads targeting
	- sentiment analysis
	- product recommendations


### Babelfish for Aurora PostgreSQL
- Allows Aurora PostgresSQL to understand commands targeted for MS SQL Server (T-SQL language)

## 6-RDS & Aurora Backup and Monitoring

- Automated backups
	- daily full backup during the backup window
	- transaction logs are backed up every 5 minutes
	- can restore to any point in time (from 5 minutes ago)
	- 1 to 35 days of retention, set 0 to disable automated backups
- Manual DB snapshots
	- manually triggered by the user
	- retention of backup for as long as you want


- Cost optimizing trick for low-use database
- say you only need it 2 hours per day
- : in a stopped RDS database, you will still pay for storage. If you plan on stopping it for a long time, you should snapshot & restore instead `EXAM`

### Aurora Backups
- automated, cannot be disabled
- point in time recovery

### Manual DB snapshots
- manually triggered by user
- retention of backup as long as you want

### RDS & Aurora restore options
- restore from snapshot creates a new database

Restoring MySQL RDS database from S3
- create a backup of your on-premise database
- Store it on Amazon S3 (object storage)
- Restore the backup file onto a new RDS instance running MySQL

Restoring MySQL Aurora cluster from S3
- create a backup of your on-prem database using Percona XtraBackup
- Store the backup file on Amazon S3
- Restore the backup file onto a new Aurora cluster running MySQL


### Aurora Database Cloning
- Create a new Aurora DB Cluster from an existing one
- clone prod cluster to a staging cluster
- uses `copy-on-write` protocol
- very fast & cost effective


## 7-RDS and Aurora Security

- at rest encryption
	- database master & replications encrypted using AWS KMS, must be defiend at launch time
	- if master is not encrypted, replicas cannot be encrypted
	- to encrypt something already existing, snapshot it then RESTORE AS encrypted
- in flight encryption
	- TLS ready be default, use the AWS TL root certificates client-side
- IAM authentication
	- IAM roles to connect to your database (instead of username/passwords)
- Security groups
	- control network access to your RDS / Aurora DB
- No SSH available
	- except if you use RDS custom
- Audit logs can be enabled
	- sent to cloudwatch logs for longer retention time


## 8-RDS Proxy

- Fully managed database proxy for RDS
- Allows apps to pool and share DB connections established with the database
	- if you have a lot of connections
	- improves db efficiency
	- reduces stress, CPU, RAM
	- minimize open connections and timeouts `EXAM`
- Serverless, auto scaling, highly available multi AZ
- Reduces RDS & failover time by up to 66%
- Supports RDS and Aurora
- no code change for most apps, just connect to proxy instead of the database directly
- Can enforce IAM authentication for DB (IAM access-only, if you want to enforce that `EXAM`), can store credentials in AWS secrets manager
- RDS proxy is never publicly accessible (must be accessed from VPC)


## 9-ElastiCache Overview

- Managed Redis or Memcached databases
- caches are in-memory databases with reeally high performance, low latency
- Helps reduce load off of databases
- helps make your application stateless
- AWS takes care of OS maintenance, patching, optimizations, setup, configuration, monitoring
- Using ElastiCache involves code-change (assuming you had no cache before)

- Cache hit? serve from elasticache
- cache miss? read from DB, write to cache

### other strategy
user session store
- user logs into any of the application
- the application writes the session data into ElastiCache
- the user hits another instance of our application
- the instance retrieves the data and the user is already logged in
- further helps make the application stateless


### Redis vs Memcached
Redis
- multi AZ with auto failover
- read replicas for high availability
- Data durability using AOF persistence
- backup and restore features
- supports sets and sorted sets
	- replication

Memcached
- multi node for partitioning of data (sharding)
- No high availability (replication)
- Non persistent
- Backup and restore (serverless option only)
- Multi-threaded architecture
	- sharding


## 10-ElastiCache for Solution Architects

- ElastiCache supports IAM Authentication for Redis only 
- IAM policies on ElastiCache are only used for AWS API-level security
- Redis AUTH
	- You can set a "password/token" when you create a Redis cluster
	- This is a nextra level of security for your cache (on top of your security roups)
	- Support SSL in flight encryption
- Memcached
	- supports SASL-based authentication (advanced)

### Patterns for ElastiCache
- Lazy Loading: all the read data is cached, data can be become stale in cache
- Write through: adds or update data in the cache when written to a DB (no stale data)
- Session Store: store temporary session data in a cache (using TTL features)


### ElastiCache - Redis Use Case
- `Gaming Leaderbaords` a are computationally complex
- `Redis sorted sets` guarantee both uniqueness and element ordering
- Each time a new element added, it's ranked in real time then added in the correct order

## 11-List of important ports

Important ports:
- FTP: 21
- SSH: 22
- SFTP: 22 (same as SSH)
- HTTP: 80
- HTTPS: 443

vs RDS Database Ports:
- PSQL: 5432
- MySQL: 3306
- Oracle RDS: 1521
- MSSQL Server: 1433
- MariaDB: 3306 (same as MySQL)
- Aurora: 5432 or 3306 - PSQL or MySQL base

