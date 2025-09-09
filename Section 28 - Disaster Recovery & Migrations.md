# Section 28 - Disaster Recovery & Migrations

## 354. Disater Recovery in AWS

`important`
- Disater: any event that as a negative impact on a company's business continuity or finance
- DR: preparing for and recovering from a disaster
- What kind of DR?
	- on prem -> on-prem
	- on prem -> AWS hybrid
	- cloud region A -> cloud region B

`RPO` recovery point objective `EXAM`
- how often we run back ups
- delta between last backup and disaster == data loss

`RTO` recovery time objective
- downtime
- delta between disaster and recovery (i.e. 1 minute, 24 hours)

### Strategies (slowest to fastest RTO, most to least RPO)
- Backup and restore
- pilot light
- warm standby
- hot site /multi site approach

### Backup and restore (high RPO)
- imagine using snowball weekly from on-prem to S3. 
	- RPO would be a week
- if you do EBS snapshots
	- RPO is however often you do snapshots
- `cheap` recreate infra when needed
- only cost is storing your backups

### Pilot Light
- small version of the app is always running in the cloud
- useful for the critical core (pilot light)
- very similar to backup and restore
- faster then back up and restore as critical systems are already up
	- EX. data replication between on prem DB and RDS always happening
	- EC2 isn't running but you only have to create that

### Warm Standby
- full system is up and running, but a minimum size
- upon disaster, we can scale to production load


### Hot Site / Multi Site approach
- Very low RTO (minutes or seconds) - very expensive
- Full Production Scale is running AWS and On Prem
	- basically active-active setup


### DR Tips
- backups
	- snapshots, automated backups
	- pushes to S3 (tiers)
	- From on-prem to cloud: snowball or storage gateway
- high availability
	- use route53 to migrate DNS over from Region to Region
	- RDS Multi Az, elasticahce multi AZ, EFS, S3
	- site to site VPN as a recovery option from DX
- Replication
	- RDS replication, AWS aurora + global databases
	- database replication from on-prem to RDS
	- storage gateway
- Automation
	- CloudFormation / Elastic Beanstalk to re-create whole new environment
	- Recovery / reboot EC2 instances with CloudWatch if alarms fail
	- AWS lambda functions for customized automations
- Chaos

## 355. Database Migration service (DMS)

- Quick and secure way to migrate on-prem DB to AWS (resilient, self healing)
- Source DB remains available during the migraiton
- Suports
	- homogenous (Oracle -> Oracle)
	- heterogenous migration (i.e. Microsoft SQL server -> Aurora)
- Continuous Data Replication using CDC
- You must create an EC2 instance to perform the replication tasks


### DMS Sources and target
- on prem DBs
- EC2 instance DBs
- SAP, SQL Server, Azure SQL Database, RDS, PostgreSQL etc

Targets
- on-prem and EC2 instance databases
- Amazon RDS
- Redshift, DynamoDB, S3
- Opensearch Service,
- Kinesis Data Streams etc.


I..e the point is you can take an on-prem database and migrate it to anything that AWS offers


### What if the engines are different?
- `AWS SChema Conversion Tool (SCT)`
- Convert your databases schema from one engine to another
- Example OLTP (SQL Server or Oracle) to MySQL or PostgreSQL
- Example OLAP (Teradata or Oracle) to Amazon Redshift
- Only need if you are migrating with DIFFERENT DB engines


### DMS Continuous Replication
- example on prem oracle DB
- on-prem server with AWS SCT installed
	- schema conversion into Amazon RDS in the cloud
- DMS replication instance
	- perform the data migration (Oracle DB -> Amazon RDS)

### AWS DMS Multi AZ deployment
- When multi-az enabled, DMS provisions and maintains a synchronously stand replica in a different AZ


### DMS Hands On
- 3 types discover and assist
- convert
- migrate
	- homogenous one db -> same db
	- serverless replication
		- heterogenous oracle -> PGSQL 
	- instance-based migrations
			- heterogenous oracle -> PGSQL 

## 357. RDS & Aurora Migrations

`EXAM`
- RDS MySQL to Aurora MySQL
	- Option 1: DB snapshots from RDS MySQL restored as MySQL Aurora DB
	- Option 2: Create an Aurora Read replica from your RDS MySQL, and when the replication lag is 0, promote it into its own DB cluster (can take time and cost $)
- External MySQL to Aurora MySQL
	- Option 1
		- use Percona XtraBackup to create a file backup in S3
		- Create Aurora MySQL DB from S3
	- Option 2
		- Create an Aurora MySQL DB
		- Use mysqldump utility to migrate MySQL into aurora
- Use DMS if both databases are up and running
	- continuous replication


### RDS & PostgreSQL Migraiton
- RDS MySQL to Aurora MySQL
	- Option 1: DB snapshots from RDS PostgreSQL restored as PostgreSQL Aurora DB
	- Option 2: Create an Aurora Read replica from your RDS PostgreSQL, and when the replication lag is 0, promote it into its own DB cluster (can take time and cost $)
- External PostgreSQL to Aurora PostgreSQL
	- Option 1
		- use Percona XtraBackup to create a file backup in S3
		- import using aws_s3 Aurora extension
- Use DMS if both databases are up and running

## 358. On-Prem Strategies with AWS

`EXAM` high level

- `Ability to download Amazon Linux 2 AMI as a VM (.iso format)`
	- can load into VM-creation software VMWare, KVM, VirtualBox etc
	- can run this AMI on-prem
- `VM Import / Export`
	- Migrate existing applications into EC2
	- Create a DR repository strategy for your on-prem VMs
	- Can export back the VMs from EC2 to on-premise
- `AWS Application discovery service`
	- gather information about your on-prem servers to plan a migration
	- server utilization and dependency mappings
	- track with AWS migration hub
- `AWS Database Migration service (DMS)`
	- replicate on-prem -> AWS
	- AWS -> AWS
	- AWS -> on-prem
- `AWS Server Migration Service (SMS)`
	- Incremental replication of on-prem live servers to AWS

## 359. AWS Backup

- fully managed
- centrally managed and automate backups across AWS services
- no need for custom scripts or manual processes
- supported services
	- EC2
	- EBS
	- S3 
	- RDS, Aurora, DynamodDB
	- DocumentDB/Neptune
	- EFS / FSx (Lustre & Windows File Server)
	- AWS Storage Gateway
- Cross-region backups
- cross-account backups



- PITR for supported services
- on-demand and scheduled backups
- tag-based backup policies (i.e. tagged production)
- you create backup policies known as backup plans
	- backup frequency
	- backup window
	- transition to cold storage
	- retention period


Create a backup plan + assign resources -> backed up to internal S3 bucket


### BAckup Vault Lock
- Enforce WORM (write once read many) state for all the backups that you store in your AWS backup vault
- additional layer of defense against
	- changing the retention periods
	- inadvertent or malicious deletes
- Even root user cannot delete backups when enabled


## 361. Application Migration Service (MGN)

- Starting fresh? no migration needed
- If you have an on-prem DC you need to plan your migration
- Scan servers
- server utilization data and dependency mapping are important for migrations
- Agentless Discovery (AWS Agentless Discovery Connector)
	- VM inventory, configuration, and performance history such as CPU, memory, and disk usage
- Agent-based Discovery (AWS Application Discovery Agent)
	- system configuration, performance, running processes, and details of the network 

- resulting data can be viewed within AWS migration hub

### `Application Migration Service` (`MGN`)
- simplest way to migrate
- lift-and-shift (rehost) solution which simplifying migration applications to AWS
- Converts your physical, virtual, and cloud-based servers to run natively on AWS
- replicate data continuously, then cutover
- supports wide range of platforms, OSs, and databases
- Minimal downtime, reduced costs


## 362. Transferring Large datasets into AWS

### Summary Lecture

EX. trasnfer 200 TB for data into the cloud, with a 100 Mbps internet
- Over the internet / site-to-site VPN
	- immediate to setup
	- will take
	- 200TB * 1000 GB * 1000MB * 8Mb / 100 Mbps = 16,000,000s = 185 days...
- Over direct connect with 1Gbps
	- long initial setup (over a month)
	- 200TB * 1000 GB * 1000MB * 8Mb / 1 Gbps= 1,600,000s = 18.5 days...
- Snowball
	- takes about 1 week for the end to end transfer
	- can be combined with DMS
	- more for one-off transfers
- For on-going replication / transfers: site-to-site VPN or DX with DMS or DataSync



## 363. VMware Cloud on AWS

- some customers use VMWare Cloud to mange their on-prem Data Center
- may want to extend their Data Center capacity to AWS, but keep using VMware cloud
- Can extend `VMware Cloud on AWS`
- Use cases
	- migrate your VMware based workloads to AWS
	- run your production workloads across multiple workloads
	- disaster recovery strategy

## Quiz

