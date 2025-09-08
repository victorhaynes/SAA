
# Section 3 - getting started with AWS


## Regions and AZs

- `Region` - cluster of data centers, i.e. us-east-1, us-east-2
- most services are region scoped

Where should you host your application?
- sometimes compliance is a driver (i.e. data never leaves a region without explicit permission)
- proximity / latency
- available services - not all regions have all services
- pricing - varies from region to region

`Availability Zones`
- 3 - 7 AZs per region, usually 3
- if region is ap-southeast-2
	- there is:
		- ap-southeast-2a
		- ap-southeast-2b
		- ap-southeast2c
	- an AZ is one or more discrete data centers with redundant power, networking and connectivity

`Points of Presence (Edge Locations)`
More than 400 + PoP, 400+ edge lcations, 90+ cities, 40+ countries

Global Servies:
- IAM
- Route 53
- CloudFront
- WAF

Regional Examples:
- EC2 (server as a service)
- Elastic Beanstalk (platform as a service)
- Lambda (function as s service)
- Rekognition (Software as as service)



# Section 4 - IAM and AWS CLI


## 1-IAM Summary


`Users` - mapped to a physical user
`Groups` - contains users (groups cannot contain user groups)
`Policies`  - JSON document that outlines permissions for users or groups
`Roles` - for EC2 instance or AWS services
`Security` - MFA + password policies
`AWS CLI` - manage AWS services using command line interface
`AWS SDK` - manage AWS services using a programming language
`Access KEYS` - access AWS using the CLI or SDK
`Audit` - IAM credential reports & IAM access advisor


Policy statements are made up of:
- Effect
- Principal
- Action
- Resource


# Section 5 - EC2 Fundamentals


## 1-Instance Types


`User Data` - script to run on launch
`EC2 Instance Types` - m5.2xlarge
m: instance class
5: generation
2xlarge: instance size

`General Purpose EC2 Instance type`
- self explanatory

`Compute Optimized`
- Compute-intensive tasks
- Batch processing workloads
- media transcoding
- high performance web servers
- dedicated gaming servers
- ML
- start with `C` such as c6

`Memory Optimized`
- High performance that processes large data sets in memory
- high performance relational/non-rel database
- distributed web scale scache stores
- in-memory databasesd optimized for BI
- applications for big usntructured data

`Storage Optimized`
- great for storage-intensive task that require high sequential read and write to large data on local storage
- OLTP


## 2-Security Groups & Classic Ports Overview

- `Security Groups` control how traffic is allowed into or out of EC2 instances
- Only contain ALLOW rules
- "Firewall" on EC2 instances
	- Regulate access to ports
	- authorized IP ranges (IPv4 and IPv6)
	- protocol
	- control of inbound network
	- control of outbound network
- Security groups are tired to regions & VPC
- EC2 won't even see blocked traffic
- by default all inbound traffic is blocked
- all outbound is allowed

- Security groups can reference other security groups, mix & match like legos

`Classic Ports`
- 22 (SSH) - Linux instance 
- 21 (FTP) - upload files into a file share
- 22 (SFTP) - secure file transfer protocol - upload fiels using SSH
- 80 (HTTP) - access unsecured websites
- 443 (HTTPS) - access secured websites
- 3389 (RDP) - remote desktop protocol, log into a windows instance

`EC2 Instance Connect`
- AWS console/browser based SSH connect.
- No key necessary

`IAM Roles`
- can attach roles to an EC2 instance
- NOTE NEVER configure an IAM identity directly on an EC2 instance using SSH




## 3-EC2 Purchasing Options


- `On-Demand Instance`, short predictable pricing ,pay by second
- `Reserved` (1-3 years)
	- long workloads
	- specific instance type, region, tenancy, OS
	- can pay up front, partially up front, not upfront
	- steady-state usage application (i.e. database)
	- ` Convertible reserved instances`
		- can change instance type, region, tenancy, OS
- `Savings Plans` (1 - 3 yr) commitment to an amount of $ usage, long workloads
	- locked to a instance family (i.e. m5) & AWS region
	- flexible across:
		- instance size
		- OS
		- tenancy (host, dedicated, default)
- `Spot Instances` - short work, cheap, can lose at any time. Define a max price you are willing to pay. Good for workloads resilient to failure. Flexible start/end time. Not suitable for database or critical jobs
- `Dedicated Host `- book an entire physical server, control instance placement
	- compliance requirements
	- or using your existing server-bound software licenses (per-socket, per-core, per-VM)
	- Can reserve 1-3 years
	- visibility into lower level hardware.
- `Dedicated Instance` - dedicated hardware for just you, no-one else
- `Capacity Reservations` - reserve capacity in an AZ for any duration
	- no time commitment, no discounts, JUST reserving capacity
	- You are charged for on-demand pricing whether or not you launch the instances

## 4-EC2 Purchasing Option Review - Resort Example


- `On demand`: coming and staying whenver you like at a reosrt, pay full price

- `Reserved`: like planning ahead of time to stay for a long time (1-3 years), get a discount. 

- `Savings plan`: commit to paying a certain amount per time (i.e. 400 a day and can switch rooms)

- `Spot Instances`: hotel can run last minute discounts offers bids on empty rooms. But you can get kicked out at any time if someone pays morre

- `Dedicated host`: book an entire building @ the resort

- `Capacity Reservation`: book a room and have it available whether or not you stay in it

## 5-AWS IPv4 Charges

- Charge for all public ipv4 created in your account
- roughly $3.6 a month

- Per EC2 Instance
- Per RDS database

## 6-Spot Instances  & Spot Fleet

- Define a `max spot price` and get the instance while `current spot price < max`
- hourly spot price varies based on offer and capacity
- If the current spot price exceeds your max price you can choose to stop or terminate your instance within a 2 minute grace period

Legacy service `spot block` can claim an instance for 1-6 hours without interruptions. But this is recently deprecated

Used for batch jobs, data analysis, or workloads that are resilient to failure
BAD for critical jobs or datbases



## Spot Request
- maximum price
- desired number of instances
- launch specification
- request type: one-time | persistent
- valid from, valid until

EXAM
`Cancelling a spot request does not terminate instances`
- kind of like a spot fleet but must be much more specific about what exactly you want


## Spot Fleets
- set of spot instances + on-demand instance
- will try to meet the target capacity with price constraints
	- define possible launch pools (m5.large), OS, AZ
	- can have multiple launch pools
	- spot fleet stops launching instances when reaching capcity or max cst
- Strategies (EXAM)
	- `lowestPrice` - pool with lowest price
	- `diversified` - distr across all pools (great for availability, long workloads)
	- `capacityOptimized` - optimal capacity for num of instances
	- `priceCapacityOptimized` - pool with highest capacity avail, then select lowest price (best choice for most workloads, recommended)

- i.e. you are interested in a total amount of power based on diff strategies (diff AZs, OS, instance types)

# Section 6 - EC2 SAA Level


## 1-Private vs Public vs Elastic IP

- Network has two sorts of IPs. IPv4 and IPv6
	- IPv4 : 1.160.10.240 four numbers separate by 3 dots
	- 1pv6: long ugly string
- IPv4 is most common format used online
- IPv6 is newer and solves certain problems, good for IoT

- IPv4 allows for 3.7 billion different 
- IPv4 [0-255].[0-255].[0-255].[0-255]

- Public IP means machine can be identified on the internet (WWW)
- unique across the entire web
- can be geolocated easily


- Private IP - priv network only
- unique across the priv network
- diff priv networks can have the same priv IPs
- machines connect to WWW using a NAT + internet gateway (a proxy)
- only a specified range of IPs can be priv IPs

- Elastic IPs
- when you start or stop instances the EC2 public IP address changes
- can get a static EIP and attach it to your instance
- try to avoid using EIP - only get 5 per account
- often reflect poor architectural decisions
- instead use a random public IP and register a DNS name to it

## 2-Placement Groups

`EXAM`
Control of EC2 instance placement strategy

Choose a strategy
`culster` - instances in to a low latency group in a single AZ
`spread`- spread across underlying hardware (max 7 instances per group per AZ) critical application
`paritions` - spread across diff partitions which rely on different sets of racks within an AZ. Scales to 100s of instances per group

### Cluster
pros: great networking, low latency
cons: if the az fails, all instances fail at the same time
use case: 
- big data job, that need to complete fast
- application that needs extremely low latency and high throughput network between instances


### Spread
- pros: 
	- ec2 instances on different physical hardware
	- can span across AZs
	- reduced risk is simultaneous failure
	- (i.e. us-east1a has 2, us-east-1b has 2, us-east-1c has 2)
- cons
	- limited to 7 instances per AZ per placement group
- use case:
	- maximize high availability
	- critical application where instance failure must be isolated from each other

### Partition Groups
- each partition represents hardware racks in AWS
- up to 7 partitions per AZ
- can use multiple AZs in the same region
- the instances in a partition do not share racks with instances in other partitions
- EC2 instances get access to the partition information as metadata
- use cases:
	- big data applications

## 3-Elastic Network Interfaces (ENI)

- Logical component of a VPC that represents a virtual network card
	- primary private IPv4 (Eth0)
	- one or more secondary IPv4 (Eth1)
	- one elastic IP per private IPv4
	- one Public IPv4
	- one or more security groups
	- A MAC address
- bound to a specific AZ

## 4-EC2 Hibernate

- Stop the data on the disk (EBS) is kept intact
- Terminate (EBS volumes) are destroyed and lost

`Hibernate`
- whatever was in RAM (in-memory) is preserved
- instance boot is much fsater
- under the hood, the RAM state is written to a file in the root EBS volume
- the root EBS volume must be encrypted

### Use cases
- long running processing
- saving ram state
- services that take time to initialize

### Good to knows
- supports a lot of instance families
- does not work for bare metal instances
- many AMIs
- work for root volumes, must be encrypted

# Section 7 - EC2 Instance Store


## 1-EBS


`Elastic Block Store` - a network drive you can attach to an instance
- persists data, even after EC2 instance deletion

- like a hard drive accessed over a network

- Some EBS volumes provide a multi-attach feature

- bound to a specific availability zone

- ebs snapshots can move across AZs

- has provisioned capacity (GBs and IOPs)

## 10-EFS

Managed NFS (network file system) that can be mounted on many EC2
- works across AZs
- highly available, scalable, expensive (triple the price of a standard EBS volume). pay per use

Use cases
- content mangement, web serving, data sharing, wordpress
- needs securiy group
- compatible with LINUX based AMIs only (not Window)
- no capacity planning, scales automatically

EFS scale
- 1000s of concurrent NFS clients, 10+ GB/s throughput
- grow auomatically
Performance mode
- general purpose, latency sensitive use cases
- Max I/O - higher latency, throughput, highly parallel
Throughput Mode
- bursting mode
- provisioned mode
- elastic mode

### Storage classes
- storage tiers, lifecycle management feature
	- standard
	- Infrequent access (EFS-IA). cost to retrieve, low price to store
	- Archive, rarely accessed. Even cheaper
- can implement lifecycle policies to move files between storage tiers automatically


### Availability and durability
- standard (multi AZ)
- One Zone, one AZ, cheaper but less durable


## 11-EBS vs EFS


EBS Volumes
- one instance (Except io class multi attach)
- locked at the AZ level
- gp2 IO scales with disk size
- gp3 and io class can incrase IO indepdently

The Migrate an EBS volume across AZ
- take snapshot
- restore snapshots to another AZ
- turn application off is possible but not mandatory

Root EBS volumes get termianted by default if you termiante the EC2 instance but you can disable this



Elastic File System
- mounting 100s of instances across AZ, network file system
- Linux instances only
- more expensive
- can use storage tiers for cost savings

Instance Store
- physically attached
- ephemeral

## 2-EBS Snapshots

- back ups
- not necessary to detach volume to do snapshot but recommended
- can copy across AZs or regions

EBS Snapshot Features
- move to archvie tier, 75% cheaper
- takes 24-72 hours to restore
- Recycle Bin, setup rules for delete snapshots. specify retention

## 3-AMIs


AMI = Amazon Machine Image

AMI are a customization of an EC2 instance
- add your own software, configuration, operating system, monitoring
- benefit of faster boot / config becasue software is pre-packaged

AMIs are region specific (can be copied)
- public AMI
- your own AMI
- AWS marketplace AMI

AMI creation
- start an EC2 instance, customize
- stop the instance (for data integrity)
- build an AMI (will create EBS snapshots)
- Launch instances from other AMIs



## 4-EC2 Instance Store


- EBS volumes are NETWORK drives with good but limited performance
- IF you need high-performance hardware disk, use EC2 instance store

- better I/O performance
- EC2 store loses storage if they're stopped (if EC2 stops). They are EPHEMERAL
- Good for buffer, cache, scratch data, emporary content
- Risk of data loss if hardware fails
- Backups and replication are your responsibility


## 5-EBS Volume Types


EBS volumes come in 6 types
- gp2 / gp3 - general purpose SSD volumes
- io1 / io2 block express - highest performance SSD volume for mission-critical low latency, high throughput workloads
- st1 (HDD) - low host CDD volume designed for freuently accessed throughput intense workloads
- sc1 (HDD) low cost HDD volume for less freuently accessed throughput



### General Purpose SSD
- cost effective low latency
- `gp3`
	- baseline of 3000 IOPS and 125 MiB/s
	- can increase IOPS up to 16,000 and throughput up to 1000 MiB/s independently `EXAM`
- `gp2`
	- small gp2 volumes burst IOPS up to 3000
	- size of the volume and IOPS are linked, max IOPS is 16000
	- 3 IOPS per G
	- cannot increase IOPS independently `EXAM`

## Provisioned IOPS (PIOPS) SSD
- Critical business apps that need sustained IOPS performance
- Apps that need more than 16,000 IOPS
- Great for database workloads `EXAM`
- `io1` (4 GB - 16TB)
	- Max PIOPS 64,000 for Nitro
	- Can increase PIOPS independently
- `io2` (4 GB - 64TB)
	- even better than io1 basically
- supports EBS multi attach


### Hard Disk Drives (HDD)
- cannot be a boot volume, only SSDs can be boot volumes
- `st1`
	- throughput optimized
	- big data, warehouses, log processing
- `sc1`
	- infrequently accessed data
	- lowest cost

## 7-EBS Multi-Attach

Can attach same EBS volume to multiple EC2 instances in the same AZ
- `io` type EBS volumes only
- `io1`/ `io2`
each instance gets full read and write permission
- higher application availability in clustered linux applications
- applications must manage concurrent write
- Up to 16 EC2 instances at a time `EXAM`
- Must use a file system that is cluster-aware


## 8-EBS Encryption

- data at rest in encrypted
- data in flight (between instance and volume) is encrypted
- all snapshots are encrypted
- all volumes are created from the snapshot
- AWS manages this for you
- EBS encryption leverages leys from KMS (AES-256)

Encrypt an unencrypted EBS volume
- create snapshot
- encrypt the snapshot

# Section 8 - High Availability and Scalability


## 1-High Availability and Scalability


`Vertical Scalability` (scaling out / in)
- vertically scalability means increasing the size of the instance
- ie. .t2.micro -> t2.large
- i.e. RDS and ElastiCache's underlying servers can be scaled

`Horizontal Scalability`
- increasing the number of instances / systems for an application
- distributed system
- ASG
- load balancer

`High Availability` 
- goes hand in hand with horizontal scaling
- running your application in at least 2 data centers (== 2+ Availability Zones)
- goal of high availability is to survive a data center loss
- ASG multi AZ
- load balancer multi AZ


## 10-Elastic Load Balancer - Connection Draining



- Feature naming
- connection draining for CLB
- de registration delay for ALB and NLB

- Time to complete "in flight requests" while the instance is de-registering or unhealthy
- stop sending new requests to the EC2 instance which is de-registering


## 11-Auto Scaling Groups (ASG)

- load can change over time
- can create and quickly get rid of server
- can automate this using an ASG
	- scale out / horizontally scale to match an increased load
	- scale in (remove EC2 instance) to match a decreased load
	- can define minimum and maximum
	- automatically register new instances to a load baalncer
	- unhealthy instances can be automatically terminated

ASGs are free
- only pay for underlying resources


To use ASGs
- must create a launch template
- i.e.
- AMI, instance types
- EC2 user data
- ebs volumes
- security groups
- SSH key pairs
- IAM roles
- network + subnets
- load balancer information


## 12-Auto Scaling Group Scaling Policies

- Dynamic Scaling
	- target tracking scaling (think average)
		- simple to setup
		- i.e. I want the average ASG CPU to stay around 40%
	- simple / step scaling
		- when CPU > 70% then add 2 units
		- when below 30% remove 1
	- scheduled scaling
		- anticipate based on known patterns
		- i.e. fridays scale out
	- predictive scaling
		- continuously forecast load and schedule scaling ahead

Good metrics to scale on
- CPUUtilization (average)
- RequestCountPerTarget
- Average Network In / Out (if app is network bound)
- or any custom CloudWatch metric


Scaling Cooldowns
- after a scaling activity ASG will not scale anymore for a set time
- default 300 seconds

## 2-Elastic Load Balancing (ELB)

- spread load across multiple downstream instances
- expose a single point of access to your application
	- NLBs: one static IP address per AZ/EIP OK
	- ALB & CLB have static DNS  `EXAM`
- seamlessly handle downstream failures
- health checks
- provide SSL termination (HTTPS) for your websites
- Enforce stickiness with cookies
- high availability across zones
- separate public traffic from private traffic


- ELB is `managed` by AWS
	- takes care of upgrades, maintenance, high availability
	- provides a few configuration knobs
- well integrated

### Health Checks
- performed on a port and a route
- i.e. port 4567 /health

## Types of load balancers
1) `Classic Load Balancer` not recommended  / old
2) `Application Load Balancer` ALB - HTTP, HTTPS, WebSocket
3) `Network Load Balancer` NLB - TCP, TLS, UDP
4) `Gateway Load Balancer` - GWLB - IP Protocol

## Security
- Port 80 & 443 allow TCP connections in (Load balancer allows all traffic pretty much)
- EC2 instance then just allows inbound traffic from the source load balancer


## 3-1) Application Load Balancer

- Layer 7 (meaning HTTP)
- Load balances multiple HTTP applications across target groups
- can be via instances or containers
- supports HTTP/HTTPS/WebSocket protocol

- Can route based on URL i.e. /users vs /posts
- Can route based on hostname in URL one.example.com vs other.example.com
- Routing based on query string, headers etc. example.com/user?id=123

- ALB are a great fit for micro services & container based applications

ALB target groups can be:
- ec2 instances
- ECS tasks 
- Lambda functions
- private IPs

Health checks are the target group level


## Good to know
- given fixed hostname XXX.region.elb.amazonaws.com
- application servers dont see the IP of the client directly
	- the true IP of the client is inserted in the `X-Forwarded-For` headers

## 4-2) Network Load Balancer

- Layer 4
- Forward `TCP` and `UDP` traffic to your instances `EXAM`
- Once forwarded various protocols are allowed outbound towards the target groups (i.e. TCP in, HTTP out)
- ultra low latency
- for each AZ you want to use there is one static IP address assigned by AWS/or EIP `EXAM` (NLP ONLY)

- NLB has `one static IP per AZ` and supports assigning Elastic IP

- NLB: extreme performance, TCP, UDP think NLB

## Target Group
- EC2 instances
- Private IP addresses
- can have an NLB in front of an ALB (i.e. get fixed IP addresses from the NLB, then all the routing rules for the ALB)


## 5)-3) Gateway Load Balancer

- Layer 3 (lower level than the others) - IP packets
- all traffic of your network to go through a fire wall, deep packet inspection system, payload manipulation, prevention systems, intrusion detection
- the use case basically is to allow traffic to be analyzed before continuing to your application

- Combines the following functions
	- transparent network gateway - single entry/exit for all traffic
	- load balancer - distributes traffic to your virtual appliances

`EXAM` uses `GENEVE` protocol on port `6081`

### Target groups
- ec2 instance

## 7-ELB Sticky Sessions


- possible to implement stickiness so that the same client is always redirected to the same instance behind a load balancer
- works for Classic Load Balancer, Application Load Balancer, Network Load Balancer
- uses cookies
- use case: make sure the user doesn't lose their session data
- enabling stickiness can unbalance your load


Two types of a`pplication based cookies`
- `custom cookie`
	- generated by the target
	- can include any custom
- `application cookie`
	- generated by the load balancer


`Duration-based cookies`
- cookie generated by the load balancer


## 8-ELB Cross Zone Load Balancing


- each load balancer instance distributes evenly across all registered instances in all AZ
- will balance traffic downstream regardless of what AZ the target (EC2 instance) is

Can enable or disable this, without this if your targets as unbalanced by AZ you get unbalanced traffic


### Application load balancer
- enabled by default (can disable at the target group level)
- no charge for inter AZ data (normally you do pay for cross AZ traffic)

### NLB & GWLB
- disabled by default
- will pay & if you enable it


### Classic LB
- disabled by default

## 9-ELB SSL Certificates


### SSL/TLS - Basics
- SSL cert allows traffic between client and your load balancer to be encrypted in transit (in-flight enryption)
- SSL: Secure Socket Layer used to encrypt
- TLS: Transport Layer Security (new more adopted version) often still called SSL

- SSL certs are issued by Certificate Authorities (CA)
- Comodo, Symantec, GoDaddy etc.

- SSL certs have an expiration date (you set) & must be renewed

### Load Balancer - SSL Certs
- Load balancer uses X.509 cert (SSL/TLS server cert)
- Can manage certs using ACM (AWS certificate Manager)
- Can create your own certs if you want
- need HTTPS listener:
	- specify default cert
	- optional list of certs for multiple domains
	- clients can use SNI (server name indication) to specify the hostname they reach
	- ability to specify a security policy to support older versions of SSL/TLS (legacy)


### Server Name Indication (SNI) `EXAM`
- solves problem of loading multiple SSL certs onto one web server
- new protocol requires the client to INDICATE the hostname of the target server in the initial SSL handshake
- The server will then find the correct cert or return the default one


Only works for ALB, NLB, and CloudFront


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


# Section 10 - Route 53


## 1-What is a DNS

- `Domain Name System`
- translates human friendly hostnames into target server IP addresses
- hierarchical naming structure
	- .com
	- example.com
	- www.eample.com
	- api.example.com

### DNS Terminology
- Domain Registrar: Amazon Route 53, GoDaddy
- DNS Records: A, AAAA, CNAME, NS....
- Zone File: contains DNS records (the map)
- Name Server: resolves DNS queries
- Top Level Domain (TLD) .com, .org, .us etc
- Second Level Domain (SLD) amazon.com, google.com,


FQDN - Fully Qualified Domain name
http:///api.www.example.com.
- last . is the root
- .com is the TLD
- example.com is the SLD
- www.example.com Sub domain
- api.www.example.com FQDN
- http - protocol

## How DNS Works (new example)

![Screenshot 2025-08-08 at 10.11.13 AM.png](Screenshot%202025-08-08%20at%2010.11.13%20AM.png)

## 10-Latency Routing Policy

- redirect to the resource that has the lowest latency  to the requester
- Latency based on traffic between users and AWS regions
- Can be combined  with health checks

## 11-Route 53 Health Checks

- Check the health of `mainly` public resources
- health checks can enable automated failover
- 3 types of health checks
	- monitors an endpoint
	- calculated health check (composite health check, OR - AND - NOT, up to 256)
	- monitors a cloudwatch alarm

Health checkers come from all across the world
- Rule is if over 18% of the health checks pass then it is healthy
- can choose what location the health checkers check from (up to around 15)
- can also read text to search for content
- 2XX and 3XX are considered healthy
- configure firewall to allow incoming health checks


If your resource is private then health checks can't check it
- but you can publish a cloudwatch alarm

## 12-Failover Routing Policy

- Active-Passive 
- Primary record requires a health check

## 13-Geolocation Routing Policy

- Based on where the user is located (not latency)
- i.e. specify by continent, country, or by US state
- use cases: website localization, restrict content distribution, load balancing etc
- can be associated with health checks

## 14-Geoproximity - Routing Policy

- route based on the geographic location of users AND resources
- Using a number called a `bias` to shift more traffic to resoruces 
- To change the size of a geographic region specify a bias
	- expand 1-99 or shrink


`EXAM` - helpful to shift traffic from one region to another by increasing the bias

- resources can be
	- AWS resources (specify region)
	- Non-AWS resources (ex. on-prem, latitude and longitude)
- Must use Route 53 traffic flow (advanced) to use this feature

![Screenshot 2025-08-08 at 12.16.15 PM.png](Screenshot%202025-08-08%20at%2012.16.15%20PM.png)

vs


## 15-IP-based Routing Policy

- Routing is based on client's IP addresses
- You provide a list of CIDRs (IP rangers) for your clients
- I.e. certain end users get a certain endpoint

## 16-Multi-Value Routing Policy

- use when want to route traffic to multiple resources
- route 53 returns multiple values/resources
- can be associated with health checks (return only healthy)
- up to 8 health records are returned for each multi value query
- like client-side load balancing
	- `NOT A SUBTITUTE FOR HAVING AN ELB`

This is basically like a simple routing policy with multiple return values (seen before)
but the difference is these can have health checks and those cannot


## 17-3rd Party Domains & Route 53

- can buy your domain name with any Domain Registrar you want (i.e. Amazon Registrar, or GoDaddy)
- These domain registrars usually provide a DNS service to manage your DNS records
- But you can use another DNS services to manage your DNS records

I.e. GoDaddy domain with Route 53 DNS management

So GoDaddy has their own Name Servers, but if we want to use Route 53 then we need to go to GoDaddy and put the Route 53 the Name Servers from your hosted zone in their


## 18-Route 53 Resolvers & Hybrid DNS

`EXAM` - IMPORTANT

- by default Route 53 Resolver automatically answers DNS queries for
	- local domain names for EC2 instances
	- Records in private hosted zones
	- records in public name servers
- Hybrid DNS - resolving DNS queries between VPC and your own networks (on-prem for example)


### Resolver Endpoints
- Inbound Endpoint
	- DNS resolvers on your network can forward DNS queries to route 53 resolver
	- allows your DNS resolvers to resolve domain names for AWS resources (EC2 instances) and records in route 53 private hosted zones
- Outbound Endpoint
	- conditionally forward DNS queries to your (on prem) DNS resolvers
	- user resolver rules to forward DNS queries to your DNS resolvers

- associated with one or more VPCs in the same AWS region
- create in two AZs for high availability
- each endpoint supports 10,000 queries per second per IP address

### Resolver INBOUND Endpoints
![Screenshot 2025-08-08 at 12.34.02 PM.png](Screenshot%202025-08-08%20at%2012.34.02%20PM.png)
- going from on-prem network into AWS through your on-prem DNS resolver into an AWS inbound endpoint

### Resolver OUTBOUND Endpoints
![Screenshot 2025-08-08 at 12.36.17 PM.png](Screenshot%202025-08-08%20at%2012.36.17%20PM.png)
- works very similar, but in the opposite direction. from the cloud to on-prem

Note: remember to connect on-prem to the cloud you need a AWS Site-to-Site VPN, AWS Direct Connect DX, or NAT Gateway connection. And you need both inbound and outbound endpoints most likely


### Resolver Rules
- need a set of rules
- control which DNS queries are forwarded to DNS resolves on your network
- Conditional forwarding rules
	- i.e. for a specific domain and sub domain forward to TARGET IP ADDRESS
- System Rules
	- selectively override the defiend behavior (i.e. DONT forward DNS queries for a certain subdomain such as api.example.com)
- Auto-defined System Rules
	- Defines how DNS queries for selected domains are resolved (AWS internal domain names, private hosted zones)

If multiple rules matched the most specific is returned
Resolver Rules can be shared across accounts if you are using AWS RAM (Resource Access Manager)
- can manage them centrally in one account

## 2-Route 53 Overview

- Highly available, scalable, fully managed Authoritative DNS
	- Authoritative = you/customer can update the DNS record
- route 53 is also domain registrar
- ability to check the health of your services
- only AWS service that provides 100% availability SLA


### Records
- how you want to route traffic for a domain
- Each record contains:
	- Domain/subdomain name - example.com
	- Record type - A or AAAA
	- Value, 12.34.56.78
	- Routing Policy - how Route 53 responds to queries
	- TTL - amount of time the record cached at DNS Resolvers
- Must know DNS Record Types `EXAM`
	- A
	- AAAA
	- CNAME
	- NS
- There are more advanced ones also

### Record Types `EXAM`
- A - maps a hostname to IPv4
- AAAA - maps a hostname to IPv6
- CNAME - maps a hostname to another hostname
	- the target can be an A or AAAA record
	- can't create a CNAME record for the top node of a DNS name space (zone apex)
	- i.e. can't create a CNAME record for example.com but you can for www.example.com `EXAM`
- NS - Name Servers for the Hosted Zone
	- Control how traffic is routed to a domain

### Hosted Zones
- A container for records that define how to route traffic to a domain and its subdomains
- `Public Hosted Zones` - contains records that specify how to route traffic on the Internet (public domain names) - application1.mypublicdomain.com
- `Private Hosted Zones` - same but private (within a VPC) - application1.company.internal
- $0.50 per month per hosted zone


### Public vs Private Hosted Zones
- public - can answer queries from public clients
- private - clients from within your vpc only
![Screenshot 2025-08-08 at 10.22.03 AM.png](Screenshot%202025-08-08%20at%2010.22.03%20AM.png)


## 3-Route 53 registering a domain


## 6-TTL

- Don't want to query the DNS too often
- Records don't change that often

Two Extremes
- We can do a high TTL of 24 hours
- possible outdated records
- Low TTL for 60 seconds
- more traffic on route 53


## 7-CNAME vs Alias

- AWS Resoruces expose an AWS hostname
	- i.e. 1b1-1234.us-east-2.elb.amazonaw.com -> myapp.mydomain.com

### CNAME
- points a hostname to any other hostname (app.mydomain.com -> example.anything.com)
- only for non-root domain (example.com would not work) `EXAM` cannot use CNAME at the apex
### Alias (AWS Specific):
- Points a hostname to an AWS resource (app.mydomain.com -> blahblah.amazonaws.com)
- Works for root Domain and non root domain (example.com and api.example.com OK)
- free
- native health check capability
`EXAM`

![Screenshot 2025-08-08 at 11.18.20 AM.png](Screenshot%202025-08-08%20at%2011.18.20%20AM.png)

### Alias Record Targets
- ELBs
- CloudFront Distributions
- API Gateway
- S3 Websites
- Elastic Beanstalk Environments
- VPC Interface Endpoints
- Global Accelerator 
- Route 53 record in the same hosted zone

## 8-Simple Routing Policy

- Define how Route 53 responds to DNS queries
- not literal routing like a load balancer
	- it only responds to DNS queries

Supports:
- simple
- weighted
- failover
- latency
- geolocation
- multi value answer
- geoproximity

### Simple
- Typically route traffic a single resource
- you CAN specify/respond with multiple IPs for a query
- If you do, a random one is chosen by the `client`
	- If you use an `Alias` record you can only specify ONE resource `EXAM`

## 9-Weighted Routing Policy

- Control the % of the request that go to each specific resource (i.e. 70%, 20%, and 10%)
- don't need to add up to 100, but might as well
- DNS records must have the same name and type
- can be associated with health checks
- Use cases: 
	- load balancing between regions
	- testing
	- new application versions
- 0% -> no traffic

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


# Section 12 - S3 Intro


## 131. S3 Overview

- "Infinitely scaling" storage
- one of the main building boxes

- backup and storage
- disaster recovery
- archive
- hybrid cloud storage
- application hosting
- media hosting
- data lakes & big data lates, analytics
- software delivery
- static website

- S3 stores objects (files) in buckets (directories)
- buckets must be globally unique (across all accounts)
- buckets are defined at the region level
- S3 "looks" global but they are created in a region
- naming convention
	- no uppercase, no underscore
	- not an ip
	- must start lower cases
	- certain prefix/suffix restrictions

- `Objects` (files) have a `key`
- the `key` is the FULL path
	- s3://my-bucket/my_file.txt
	- s3://my-bucket/my_folder1/another_folder/my_file.txr

S3 doesn't ACTUALLY have directories, but keys are basically the same thing
- the key's value is the `object`
- if file over 5GB then must use multi-part upload
- can have metadata (list of text key/value pairs)
- tags - useful for security / lifecycle
- versio nID (if versioning is enabled)


Remember public URL
vs pre-signed URLs


## 133. S3 Security + Bucket Policy

- user-based security
	- IAM policy based for users
- resource-based
	- bucket policies, bucket wide rules from the S3 console--allowss cross account
	- object access control list (fine grained ACL)
	- bucket access control list (ACL) less common

An IAM principal can access an object if the
- IAM permission allows it OR the resource policy allows it
- and there is no explicitly deny

Encryption using encryption keys


Bucket Policies - JSON

Version:
- string
Statement:
 - 1. Resource: what object
 - 2. Effect: Allow / Deny
 - 3. Action: set of API calls to allow or deny
 - 4. Principal: the account or user this applies to
 - 6. Statement ID

If EC2 instances need access then they need an EC2 instance role

Can block all public access - on by default


### Static Website
- URL depends on the region
- can put a static website on the internet

### Versioning
- self explanatory
- enabled at the `bucket level`
- if we reupload the same key we get version
- a old file before versioning will have a version of null
- disabling versioning does not delete old versions

### Replication
- Asynchronous replication, source & target must need versioning
	- Cross Region Replication CRR
	- Same Region Replication SRR
	- must give proper IAM permissisions to S3

CRR use cases
- compliance, lower latency, replication across accounts
SRR 
- log aggregation, live replication between prod & test

- only NEW objects get replicated
- for existing objects need to use `s3 batch replication`
- can replicate DELETE operations `EXAM`
	- optional
	- can replicate
	- deletions with a version ID are NOT replicated
	- cannot "chain" replications 1 -> 2 -> 3 there is only one master . 3 <- 1 -> 2
	- note delete markers show up in version history

- `DELETE MARKER`: placeholder s3 adds when you delete a versioned object without specifying an version ID. keeps previous versions intact
- `PERMANENT DELETE`: removes an actual specific object version from S3 (or the entire object if versioning is disabled)

### Storage Classes `EXAM`
- Standard General Purpose
- Standard-Infrequent Access IA
- One Zone IA
- Glacier Instant Retrieval
- Glacier Flexible Retrieval
- Glacier Deep Archive
- Intelligent Tiering

Durability, represents how often an obejct will be lost by AWS
- S3 is highly durable, 11 9s -< if you store 10,000,000 objects on S3, on avg you would lose a single object every 10,000 years
- 11 9's everywhere for all tiers in S3

Availability
- how available a service is
- i.e. S3 standard has 99.99% availability, meaning not avail 53 minutes per year

### S3 Standard General Purpose
- 99.99% availability
- frequently accessed data
- low latency high throughput
- sustain 2 concurrent facility failures
- use case:
	- big data analytics
	- mobile
	- gaming
	- content distribution

### S3 Infrequent-Access
- less frequently accessed, but rapid retireval when needed
- lower cost
- 99.9% available
- cost per retrieval
- good for DR and backups
Standard and One-Zone

One-Zone
- 99.5% available
- good for secondary backups or for storing data that can be re-created

### Glacier 
- low cost
- pay for retrieval
- meant for archive
- Instant Retrieval
	- millisecond retrieval, minimum storage of 90 days
- Glacier Flexible Retrieval
	- 1-5 minutes retrieval, standard 3-5 hours, bulk 5-12 hours (free retrieval)
	- 90 days minimum
- Deep Archive
	- long term storage
	- standard (12 hours), bulk (48 hours)
	- 180 days min
	- lowest cost

### Intelligent Tiering (Automatic Option)
- move objects between access tiers based on usage

# Section 13 - Advanced S3


## 144. S3 Lifecycle Rules with S3 Analytics

Standard -> standard IA -> intelligent tiering -> one-zone ia -> glacier instant -> glaciar flexible -> glacier deep

`Transaction Actions` - configure object transitions

`Expirations actions` - delete files based on rules, delete old files, delete incomplete multi part uploads


### Store class analysis
- `S3 analytics` helps you decide when to transition objects to the right storage class
- creates CSV report
- updated daily
- does not work for One-Zone IA or Glacier
	- only for standard and standard IA


## 145. Reqeuster Pays

- `EXAM`
- In general, owner pays for all data transfer cost and storage
- Requester Pay Bucket makes the request pay for the networking cost (owner pays for storage)
- Helpful if you want to share large datasets with other accounts
- Request must be an AWS account (not anonymous, can't charge anonymous users)


## 147. S3 Event Notifications

S3:Object --- Created, Removed, Restore, Replication etc...
- Use case: automatically react to certain events
	- i.e. create thumbnails of images of images upadated
	- Can send event notifications to targets such as SNS, SQS, Lambda


S3 events need IAM permissions for sending notifications
- SNS Resource (access) policy
- SQS Resource (access) policy
- Lambda Resource (access) policy

`Exam`

`S3 events requires resource access policies`

Can also integrate with `EventBridge`
- from EventBridge can send events to over 18 different AWS services as destinations
- advanced filtering options (metadata, object size, name)
- Multiple destinations at a time

## 149. S3 Performance

- scales to high number of requests, low latency of 100-200ms
- 3500 put/copy/post/delete per second per prefix
- 5500 get/head requests per prefix in a bucket

### Optimization `EXAM`
-` multi-part upload`
	- recommended for files > 100 MB
	- must use for > 5GB
	- can help parallelize uploads (parallelize the parts then reconstitute)
- `S3 Transfer acceleration`
	- increase transfer speed by transferring a file to an AWS edge location which will forward the data to the s3 bucket int eh target
	- i.e. USA file -> fwd to Edge Location in USA (uses fast private AWS network, minimize slow public internet) -> land in S3 australia bucket
- `S3 Byte-Range Fetches`
	- Parallelize GETs by requests specific byte ranges
	- better resilience in case of failures
	- ` can be used to speed up download`
	- EXAMPLE FILE ->
		- Part 1 (byte range), Part 2, Part 3, Part N

## 150. S3 Batch Operations

- bulk operations on existing S3 objects with a single request
	- i.e. modify all object metadata and properties
	- encrypt all unencrpted objects `EXAM`
	- modify tags
	- restore from glacier
	- invoke lambda
	- copy between S3 buckets
- a job consisst of a list of objects, the action to perform, and operational parameters
- S3 Bach operations benefits
	- retries
	- progress tracking
	- notifications
	- generate reports


## 151. S3 Storage Lens

- understand analyze and optimzie storage across AWS organization
- discover anomalies, , identify cost efficiencies, apply data protection best practices
- aggregate data for organization, specific accounts, regions, buckets, prefixes
- default dashboard or create your own dashbaords
- can be configured to export metrics daily to an S3 bucket

### Default Dashboard
- summarizes insights and trends for both free and advanced metrics
- pre-configured by S3
- can't be deleted
- shows multi-region and multi-account data `EXAM`

### Storage Metrics `EXAM`
-` Summary Metrics`
	- general insights
	- storage bytes
	- object count
	- identiy fast growing or not used buckets and prefixes
- `cost optimization metrics`
	- noncurrentversion storage bytes (old item space usage)
	- incomplete upload bytes usage
- `data protection metrics`
	- insides for data protection features
	- identify buckets not following best practices
- `Access management metrics`
	- provide insights for s3 object ownership
- `Event Metrics`
	- insights for S3 event notifications
- `Performance Metrics`
	- insights for s3 transfer acceleration
- `Activity Metrics`
	- insights about how storage is requests
	- byes downlaoded etc
- `Detailed Status Code Metrics`
	- Provide insights for HTTP status codes
	- 200sm 403s, 404s etc

### Storage Lens Free vs Paid
- `Free MEtrics`
	- automatically available for all customers
	- around 28 usage metrics
	- data remains for 14 days
- `Advanced metrics recommendations`
	- additional
	- advanced metrics
	- cloudwatch publishing
	- prefix aggregation

# Section 14 - S3 Security


## 151.  Encryption

4 methods
- server side encryption (SSE)
	- SSE S3 - AWS managed keys nabled by default
	- SSE KMS - with KMS kjey
	- SSE-c - customer provided key
- Client side Encryption (encrypted before upload)

`EXAM`
### SSE-S3
- encryption using key handled managed and woend by AWS
- object is encrypted-sver-side
- encryption type is AES-256
- must set header "x-amz-server-side-encryption": "AES256"
- enabled by default

### SSE-KMS (+ new DSSE KMS option...double)
- manage your own keys using KMS (key managed services)
- user control of the keys, audit key usage using CloudTrail
- must set header "x-amz-server-side-encrypton": "aws:kms"

### SSE-KMS Limitations
- If you use SSE-KMS you may be impacted by the KMS limits
- When you upload it calls the GenerateDataKey KMS API
- When you download it calls the Decrypt KMS API
- Couns towards the KMS quota API calls per second
- may get throtteld `EXAM`

### SSE-C
- SSE
- managed outside of AWS
- S3 does NOT store the encryption key you provide
- HTTPS must be used
- encryption key must be provided in HTTP headers for HTTP request made
- user provides key for the upload and the read

### Client Side Encryption
- use libraries like amazon S3 Client-Side Encryption Library
- clients must encrypt themselves outside of S3
- clients must decrypt themvselves after reiving from S3
- customer fully manages the keys and encryption cycle

----

### Encryption in transit
- called SSL/TLS
- S3 has 2 endpoints
	- HTTP endpoint not encrypted
	- HTTPS endpoint in flight
- HTTPS strongly recommended
- HTTPS mandatory for SSE-C

----

### Force Enncryption in Transit
- aws:SecureTransport

## 154.  Default Encryption

- SSE-S3 encryption is automatically applied to new objects stored in S3 bucket

## 155. S3 Cors

- Cross-Origin Resource Sharing (CORS) `EXAM`
- Origin = scheme + host + port (protocol + domain + port)
	- SAME origin
		- http://example.com/app1
		- http://example.com/app2
	- Different Origin
		- http://www.example.com
		- http://other.example.com
- Requests wont be fulfilled unless the other origin allows for the request using CORS Headers (Example: Access-Control-Allow-Origin)

- If a client makes a cross-origin request on our S3 bucket, we need to enable the correct CORS headers
- popular exam question
- Can allow for a specific origin or * for all origins



## 156. MFA Delete & Acess Logs

- force MFA before doing important S3 operations
- must enabled versioning `EXAM` - only root account or bucket owner can enable this


### Access Logs
- can log all access
- any request, account,authorized, or denied will be logged in another S3 bucket
- target logging bucket be in the same AWS region

## 157. Pre-signed URLs

- Generate pre-signed URLs 
- has an expiration
	- 1 min up to 168 hours
- mirrors the permissions of the user that generated the URL


## 163. Glacier Vault Lock & S3 Objet Lock

- Adopt a WORM model
	- Write Once Read Many
- Create a volt lock policy
- lock the policy for future edits
	- cannot be changed or deleted by anyone
	- helpful for compliance

### S3 Object lock works similarly
- needs versioning
- Adopt a WORM model
- Block an object at the object level (not a bucket level)

Has `retention modes` - `EXAM`
- `Compliance` - basically Glacier lock but for S3
	- object versions can't be overwitten or deleted by any user
	- can't be changed, retention period can' be shorterned
- `Governance`
	- most users can't overwrite or delete an object version or alter the lock settings
	- some users have special permissiosn to alter
- `Retention Period`
	- protect for a fixed period can be extended
- `Legal Hold`
	- hold indefinitely

## 164. S3 Access Points

- alternative to making complex bucket policies for managing groups of user's access


A Finance Group can get a Finance Access Point Policy
- grants Read/Write to the /finance prefix in S3

Sales group gets Sales Access Point Policy
- grants Read/Write to the /sales prefix in S3

etc.

Each access point has:
	it's own DNS (internet origin or VPC origin)
	access point policy (similar to a bucket policy)

### VPC Origin
- must create a VPC endpoint to access the access point

## 165. S3 Object Lambda

- Use AWS Lambda functions to change the object before it is retrieved by the caller application
- Only one S3 bucket is needed, on top of which we create S3 Access Point and S3 object lambda access points


# Section 15 - CloudFront and Global Accelerator


## 166.  Overview

- CDN
- improves read performance, content is cached at the edge
- improves user experience
- 216 points of presence globally
- DDoS protection, integrates with Shield, and AWS Web Application Firewall

## Origins
- S3 bucket
	- for distributing and caching them at the edge
	- uploading files to S3 through cloudfront
	- secured using Origin Access Control (OAC)
- VPC origin
	- for applications hosted in VPC private subnets
	- Application load balancer / NLB / EC2 instances
- Custom Origin (HTTP)
	- any S3 static website
	- any public HTTP backend

### CloudFront vs S3 Cross Region Replication
CloudFront
- global edge network
- files are cached for a TTL
- great for static content that must be available everywhere
S3 Cross Region Replication
- must be setup for each region you want replication to happen
- files are updated in near real time
- read only
- great for dynamic content that needs to be available at low-latency


## 168. ALB and EC2 as Origin

VPC Origins
- allows you to deliver content from your applications hosted in your VPC privates
- Deliver traffic to PRIVATE
	- application low balancer
	- network load balancer
	- EC2 instances


Old method - before VPC origin method existed
- Using public network
- public EC2 instance / ALB same idea
- list pf edge location public ips
- had to allow these ips into your ec2 instance

New method - VPC origins


## 169. CloudFront Geo Restriction

- can restrict who can access your distribution based on the country
- country is determined by a 3rd party GEO IP database

## 170. CloudFront - Price Classes

`EXAM`
- edge locations are all around the world
- price of data out varies across the world

Can reduce the number of edge locations around the world to reduce cost
Three classes available
- Price Class ALL - best performance
- Price class 200: most regions, excludes the most regions

## 171. Cache Invalidation

- cloudfront backend origins won't know about changes to the backend origin until the TTL of cached data has expired
- you can force an entire or partial cache refresh


## 172. Global Accelerator

- Problem: global app, global users but application is only deployed in one region (public ALB in India)
	- numerous hops for global users to get into the application
- We want to get into the AWS network as fast as possible

### Unicast IP
- one server holds one IP address

### Anycast IP
- all servers hold the same IP address and the client is routed to the nearest one
- so client gets sent to the closest server instead of a specific one

### AWS Global Accelerator
- built on Anycast IP
- instead of sending traffic from my client to the target on the public internet
- we can connect to the nearest edge location then ride the internal fast AWS network from there
- your application gets 2 IPs
- good for non-HTTP use cases such as gaming, IoT, or Voice over IP
	- good for HTTP that requires static IP addresses
	- HTTP that requires deterministic, fast regional failover

targets can be public or private
no issue with client cache (ip doesnt change)
built in health checks
automatica failover

Security
- only 2 external IPs need to be whitelisted
- DDoS protection due to AWS shield

### AWS Global Accelerator vs CloudFront
- both have edge networks

# Section 16 - AWS Storage Extras


## 174. AWS Snow Family


### Snowball
- highly secure portable devices to `collect` and or `process` data at the edge 
	- and migrate data into and out of AWS
	- can do edge computing out in the field where there is no internet access for example
- compute optimized
- storage optimized
- physically sent to you, ship it back to AWS
- integrates with S3

- Solves for
	- limited connectivity
	- limited bandwidth
	- high network cost
	- shared bandwidth
	- connection stability


### Solution Architecture: Snowball into Glacier `EXAM`
- cannot snowball import directly into glacier

## 177. Amazon FSx

- launch 3rd party high performance file systems on AWS
- fully managed service
- Can lust Lustre for FSx, or Windows File Server, NetApp, OpenZFS `EXAM`
	- basically like EFS but third party

### FSx for Windows
- FSx for Windows is a fully managed windows file sytem sahre drive
- supports SMB protocol and windows NTFS
- microsoft active directory integraiton, ACL, user quotas
- cannot be mounted on linux EC2 instance `EXAM`
- supports Microsoft's Distributed Fiel System (DFS) Namespaces (can integrate with on-prem file system)
- scales extremely well

- Storage options
	- SSD latency sensitive workloads, IOPS intensive, random file operations
	- HDD cheaper but slower (good for home directory)
- Can be accessed from your on-prem infrastructure
- can be multi AZ
- backed up to S3

### FSx for Lustre
- parallel distributed file system for large-scale computing
- Lustre = Linux + cluster
- Used for Machine Learning and HPC (High Performance Computing) `EXAM`
- Video Processing, Financial Modeling, Electronic Design Automation
- scales extremely well
- Storage options
	- SSD latency sensitive workloads, IOPS intensive, random file operations
	- HDD throughput-intensive workloads, large and sequential file operations
- seamless integration with S3
	- can "read" s3 as a file system through FSx
	- can write to S3 through FSx `EXAM`
	- integrates with on-prem

### FSx File System Deployment Options `EXAM`
- `Scratch file system`
	- temporary
	- not replicated or persisted
	- high burst
	- high performance
	- low cost
	- short term processing
- `Persistent File System`
	- long-term storage
	- data is replicated within same AZ
	- replica failed files within minutes
	- long term processing, sensitive data


### FSx for NetApp ONTAP
- managed NetApp ONTAP on AWS
- compatible with NFS, SMB, iSCSI protocol
- Move workloads running ONTAP or NAS on-prem into AWS (use case)
- Works with numerous OS
	- Linux
	- Windows
	- MacOS
	- VMware Cloud
	- EKS etc
- Storage shrinks or grows (auto scaling)
- snapshots, replication, low-cost, compression, and data de-duplication
- Point-in-time instantaneous cloning (helpful for testing new workloads)

### FSx for OpenZFS
- managed OpenZFS on AWS
- compatible with NFS protocol only
- move workloads running on ZFS or AWS (use case)
- broad OS compatibility
- snapshots, compression, low-cost
- DOES NOT SUPPORT DATA DE-DUPLICAITON

## 179. Storage Gateway

- AWS is pushing for "hybrid cloud"
	- part is on-prem
	- part is in AWS
- Due to many reasons
	- strategy
	- long cloud migrations
	- security requirements
	- compliance requirements

- S3 itself is a propeitary storage technology (unlike EFS or NFS) 
- to expose S3 to on-prem you need

(reminder:
BLOCK - EBS/EC2 instance store
File - EFS / FSx
Object - S3 / glacier
)
### Storage Gateway
- bridge between on-prem data and cloud
- Use cases:
	- disaster recovery
	- backup and restore
	- tiered storage
	- on-prem cache & low-latency file access
- Types of storage gateway:
	- S3 file gateway
	- volume gateway
	- tape gateway

### File Gateway
- Standard network file system (NFS or SMB protocol)
- to connect on-prem storage to S3
- over HTTPS
- Most recently used data is cached in the file gateway
- supports diff storage tiers -> can transition from s3 -> glacier using lifecycle policies `EXAM`
- bucket access using IAM roles for each file gateway
- SMB protocol and integrate with active directory for auth

### Volume Gateway
- block storage using iSCSI protocol
- connect on-prem storage to EBS
- backed by EBS snapshots which can help restore on-prem volumes
- Cached volumes: low latency access t most recent data
- Stored volumes: entire dataset is on premise, scheduled backups to S3

### Tape Gateway
- physical tape backups
- same process but in the cloud
- Virtual Tape Library VTL backed by S3 and Glacier
- back up data using existing tape-based processes

## 181.  AWS Transfer Family

- Fully managed service for file transfers into and out of S3 or EFS using the FTP protocol
	- supportS FTP
	- FTPS (encrypted ssl)
	- SFTP (encrypted)
- Managed infra, scalable, reliable, available

## 182. DataSync Overview

`EXAM`
- move large amounts of data to and from place
	- on prem or other clouds to AWS - needs an agent to run on-prem or on another cloud
	- AWS to AWS - no agent needed
- can synchronize to:
	- S3 including any storage tier INCLUDING glacier unlike most other services
	- EFS
	- FSx
- replication tasks can be scheduled
- File permissions and metadata and preserved (i.e. linux permissions) `EXAM`
- one agent can sue up to !0 GBps - can set a limit

Remember if you have poor network then you can still use a AWS Snowcone device
`EXAM`


## 183. Storage Options Compared

`S3`: object storage
`S3 Glacier`: object archival
`EBS Volume`: Network storage for on EC2 instance at a time (io1 and io2 can multi attach)
`Instance Storage`: Physical storage with extreme performance, ephemeral
`EFS`: Network file system for linux instances, POSIX filesystem
`FSx for Windows: `NFS for Windows servers
`FSx forLustre:` HPC Linux file system
`FSx for NetApp ONTAP`: self explain
`FSx for OpenZFS`: self explain
`Storage Gateway:` S3 & FSx file gateway, volume gateway, tape gateway
`Transfer Family`: FTP, FTPS, SFTP interface on top of S3 or EFS
`DataSync`: Schedula data from on-prem to AWS or AWS to AWS
`Snowcone/Snowball/Snowmobile`: order a physical device to move large amounts of data
- snowcone comes with datasync agent in it already

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

# Section 18 - Containers, ECS, Fargate, ECR, EKS


## 200. Docker

- packed containerized apps that can run on any OS
- any machine
- no compatibility issues
- predictable behavior
- easier maintenance
- use case: microservice architecture, lift and ship apps from on prem to the cloud


Docker imags / hub
- find base images for many technologies or OS (Ubuntu, MySQL)

vs Amazon's ECR
- public and private options

### Virtualization-like technology
- resources are shred with the host, can have many containers on one server
- EC2 for instance is ran by a hypervisor that runs on the physical server
- instead of a hypervisor docker relies on a docker daemon to orchestrate its containers


### Getting started
- need Dockerfile
- build using a docker image
- push image to dockerhub (public) or Amazon ECR (private)
	- can pull image
- docker image can than be ran


### ECS
- Amazon's own container platform

### EKS
- Amazon's managed version of Kubernetes

### Fargate
- own severless container platform

## 201. ECS

### EC2 Launch Type
- ECS = elastic container service
- a launch docker container on AWS = launch ECS tasks on EC2 clusters
- EC2 Launch Type: you must provision & maintain the infrastructure (the EC2 instances)
- each EC2 instance must run the ECS agent to register in the ECS cluster
- AWS takes care of starting/stopping containers 

### Fargate Launch Type
- launch docker containers on AWS
- do no provision infra
- serverless
- just create task definitions
- AWS runs ECS Taks for you based on the CPU/RAM needed
- to scale just increase the number of tasks. Simple no EC2 to manage
- `EXAM`

### IAM Roles for ECS
- EC2 Instance Profile (EC2 Launch Type only)
	- used by the ECS agenet
	- make api calls to ECS service
	- send container logs to cloudwatch
	- pull docker image from ECR
	- reference sensitive data in secrets manager or SSM parameter store
- ECS Task role:
	- allows each task to have a specific role
	- different roles for different services
	- task role is defined in the task definition

### Load Balancer Integrations
- Can put an ALB in front of an ECS cluster
- NLB recommended only for high throughput / high performance uses cases or pair it with AWS Private Link `EXAM`
- Classic Load Balancer works but not commended (does not work with Fargate)

### Data Persistence on ECS
- Mount EFS file system onto ECS tasks
- Works for both EC2 and fargate launch types
- Tasks running in any Az will share the same data in the EFS file system
- Fargate + EFS = Serverless
- Use Cases: persistent multi-AZ shared storage for your containers
- Note:
	- S3 CANNOT be mounted as a file system for ECS tasks




### ECS Hands On 203
Three Infrastructure Options
- AWS Fargate Pay as you go
- EC2 instances
- External instances using ECS anywhere (on-prem)

### ECS Service Hands on 204
- need task definition


`Review ECS`

## 205. ECS Service Auto Scaling

- can manually or automatically increase desired number of ECS tasks
- Can use AWS Application Auto Scaling
	- can scale on service average cpu util
	- service average memory util
	- ALB request count per target
- Target tracking
- Step Scaling
- Scheduled scaling

Task level scaling != EC2 auto scaling `Review`
Fargate auto scaling is much easier to setup
`EXAM`


### Auto Scaling EC2 Instance - EC2 Launch Type
- accommodate ECS service scaling by adding underlying EC2 instance
- Auto scaling group scaling
	- scale ASG basd on cpu util
	- add ec2 instances over time
- ECS cluster capacity provider
	- new/advanced
	- used to automatically provision and scale the infra for your ECS tasks
	- capacity provider paired with an ASG
	- add EC2 instances when you're missing capacity
	- `best option most of the time EXAM`

## 206. ECS Solution Architectures

### ECS tasked invoked by Event Bridge
Serverless object processing architecture using Event Bridge, ECS, and Fargate
![Screenshot 2025-08-18 at 1.39.41 PM.png](Screenshot%202025-08-18%20at%201.39.41%20PM.png)

### Event Bridge Schedule (ex. every 1 hour)
serverless hourly batch processing![Screenshot 2025-08-18 at 1.40.37 PM.png](Screenshot%202025-08-18%20at%201.40.37%20PM.png)

### SQS Queue
![Screenshot 2025-08-18 at 1.43.44 PM.png](Screenshot%202025-08-18%20at%201.43.44%20PM.png)

### EventBridge to intercept events within your ECS cluster
i.e. if a task exists it gets captured by EventBridge and SNS can then email an admin![Screenshot 2025-08-18 at 1.44.41 PM.png](Screenshot%202025-08-18%20at%201.44.41%20PM.png)


## 208. ECR

Elastic Container Registry
- store and manage docker images on AWS
- Private and public storage options
- Fully integrated with ECS backed by amazon S3

EC2 instance would need an IAM Role to pull an image from ECR


## 209. EKS

### Elastic Kubernetes Service
- Way to launch managed kuerbentes clusters on AWS

### Kubernetes
- open-source system for automatic deployment, scaling and management of containerized application
	- think of it as an open source alternative to ECS. similar usage but different  API
	- use case: already using kubernetes on prem or in another cloud
	- then use EKS on AWS to migrate
	- kubernetes is cloud-agnostic `EXAM` while ECS is not

EKS pods are like ECS tasks
EKS pods run on EKS nodes
EKS nodes can be managed by an ASG
Public and privte LBS can eb used

### EKS Node Types
- Managed Node Groups
	- creates and manages Nodes (EC2 instance) for you
	- aprt of an ASG managed by EKS
	- supportson demad and sport isntance
- Self managed nodes
	- nodes created by you and registered to the EKS cluster and maanged by an ASG
	- can sue prebuilt AMI Amaazon EKS Optimized AMI
	- Supports on demand or spot isntance
- Fargate
	- No maintenance required, no nodes managed

### EKS Data Volumes
- must specify a `StorageClass` manifest on your EKS cluster `EXAM`
- Leverage a `Container Storage Interface` (CSI) compliant driver `EXAM`

Support for
- EBS
- EFS
- FSx for Lustre
- FSx for NetApp ONTAP

### 207 Hands On

## 211. App Runner

- fully managed service that makes it easy to deploy web applications and APIs at scale
- no infra experience required
- start with your source code or container image
- configure settings like CPU, RAM, ASG yes/no, health checks
- then automatically builds and deploy the web app
- automatic scaling, high availability, low balancer
- VPC access support
- can connect to database, cache, message queue services
- Use cases: web apps, APIs, microservices, rapid production deployments etc


## 213. App2Container

- CLI tool for migrating and modernizing Java and .NET web apps into Docker Containers
- Lift-and-shift your apps running on-prem or other clouds to AWS
- Accelerate modernization, no code changes, migrate legacy apps
- Generates CloudFormation Templates
- Register generated Docker containers to ECR
- Deplyo to ECS, EKS, or App Runner
- Supports pre-built CI/Cd pipelines


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

# Section 20 - Serverless Architectures


## 232. Mobile App - MyTodoList

- Requirements
	- expose a REST API witH HTTPS endpoints
	- serverless
	- users diretly interact with their own folder in S3
	- users have serverless amanged authentication
	- users can write and read to dos, but mostly read
	- database should scale with high read throughput


mobile client -> Amazon API gateway -> lambda -> dynamo
		Cognito Authentication


`Temporary crednetials stored in cognito NOT on mobile client`
`EXAM`


## 233. Mobile App - MyBlog.com

- global scaling
- rare writing, often reading
- website is purely static files
- caching must be implemented where possible
- new subs need a welcome email
- photos should have thumbnail generation

client -> cloudfront -> s3

Give S3 a bucket policy:
only authorize from cloudfront distribution (prevents direct access if a user knows the s3 url)


## 234. MicoServices Architecture

synchronous patterns
- API gateway, load balancers
Asynchronous patterns

## 235. Software updates distribution

- we host the patch on ec2
- many incoming requests whenever patches are required

just put cloudfront infront of your existing classic architecture


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


# Section 23 - Machine Learning


## 258. Rekognition

- find objects, people, text, scenes in images and videos using ML
- Facial analysis and facial search to do user vertification people counting
- Create a database of "familiar faces" or compare against celebrities
- use cases
	- labeling
	- content moderation
	- text detection
	- face detection and analysis
	- face search and verification
	- celebrity recognition

can set minimum confidence threshold

## 259. Transcribe

- automatically convert speech to text
- deep learning process called automatic speech recognition (ASR)
- automatically remove PII using redaction
- Supports Automatic Language Identification for multi-lingual audio

## 260. Polly

- opposite of transcribe
- turn text into speech
- can use speech synthesis markup language, like HTML
- can customizie pronunciation with pronunciations lexicons
	- can add breaths
	- pauses
	- newcaster speaking style

## 261. Translate

- natural and accurate language translation

## 262. Lex + Connect

- Same technology that powers amazon alexa
	- automatic speech recognition (ASR) speech to text
	- Natural Language Understanding to recognize the intent of text callers
	- helps build `chatbots` and `call center bots`
- Amazon Connect:
	- receive calls, create contact flows, cloud-based virtual `contact center`
	- can integrate with CRM systems or AWS

## 263. Comprehend

`For natural language processing (NLP)`
managed, serverless service
uses machine learning to find insights and relationships in text

i.e. language, sentiment analysis, key phrases, events, people in the text etc

## 264. Comprehend Medical

- Like comprehend but for medical
- detects and returns sueful information in unstructured `clinical text`

## 265. SageMaker AI

- managed service for develoeprs/data scientists to build ML models
- unlike the other services, SageMaker is where you can create your `OWN model`
- Typically difficult to do all the processes in one place + provision servers

## 266. Kendra

- document search

## 267. Personalize

- fully managed ML service to build apps with real-time personalized recommendations
- i.e. somebody bought gardening tools--so recommend next one to buy
- same technology used on amazon.com store

Can feed from S3
or can use the API


## 268. Textract

- automatically extracts text, handwriting, and data from any scanned documents using AI and ML
- Extract data from forms and tables

## 269. Machine Learning Summary


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

# Section 25 - IAM Advanced


## 287.  Organizations

- global service
- allows to manage multiple AWS accounts
- the main account is the `management account`
- other accounts are `member accounts`
- member accounts can only be part of one organization
- consolidated billing across all accounts - single payment method
- `pricing benefits from aggregated usage`
- share reserved instances and savings plans discounts across accounts
- API is available to automate AWS account creation

### Organizational Units (OU) - Examples
i.e. can have business units, environment OUs (prod, dev, staging), or project-based
can organize however you want

### Advantages
- multi account vs one account with multiple VPCs
- use tagging standards for billing purposes
- enable cloudtrail on all accounts, central s3 storage
- send cloudwatch logs to central logging account
- establish cross account roles for admin purposes

`Security: Service Control Policies (SCP)`
- IAM policies applied to OU or Accounts to restrict users and roles
- they do not apply to the management account (full admin power)
- must have an explicitly allow from the root through each OU in the direct path to the target account (does not allow anything by default like IAM)

### SCP Hierarchy
- SCPs cannot apply to the mangement account period `EXAM` no matter what


## 289. Organizations Tag Policies

- helps standardize tags across resources in an AWS organization
- ensure consistent tags, audit tagged resources, maintain proper resource categorizations
- define tag keys and their allowed values
- helps with AWS cost allocation tags and attribute-based access control
- prevent non-compliant tagging operations
- generate compliance reports
- can use EventBridge to monitor non-compliant tags

## 290. IAM Advanced Policies

### IAM Conditions
- `aws:SourceIp` restrict the client FROM which the API calls are being made (caller's IP address)
- `aws:RequestedRegion` restrict the region the API calls are made TO
- `ec2:ResourceTag` restrict based on tags
- `aws:MultiFactorAuthPresent` to force MFA

### Example IAM Policy for S3
```json
{
	"Verison": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": ["s3:ListBucket"],
			"Resource": "arn:aws:s3:::test"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:GetObject",
				"s3:DeleteObject"
			],
			"Resource": "arn:aws:s3:::test/*"
		},
	]
}
```
`s3:ListBucket` is a bucket level permission
```json
			"Resource": "arn:aws:s3:::test"
```

`s3:GetObject` or get/put/delete are OBJECT level permissions so `bucket-name/<object-name>`
```json
			"Resource": "arn:aws:s3:::test/*"
```
`EXAM`
### Resource Policies & `aws:PrincipalOrgID`:

## 291. IAM Resource based Policies vs IAM Roles

IAM Roles vs Resource Based Policies

- Cross Account
	- attaching a resource-based policy to resource (Example s3 bucket policy)
	- OR using a role as proxy (user in account A can assume a role in account B)

- when you assume a role, you give up your original permissions and take the permissions assigned to the role
- when using a resource-based policy, the principal (the who)
- doesn't have to give up their permissions

	S3, SNS topics, SQS queues, lambda, API gateway all support `resource based policies` `EXAM`

### EventBridge Security
- when a rule runs it needs permissions on the target
- if the target doesn't support resource based policies then it will rely on IAM role (i.e. ec2 auto scaling)

## 292. IAM Policy Evaluation Logic

- `IAM Permission Boundaries` supported for users and roles (not groups)
- advanced feature to use a managed policy to set the maximum permissions an IAM entity can get

- Basically think of it as a "higher level" permission that sets what a lower level can do, even if the lower level has an explicit allow

- Can be used in combinations of AWS Organizations SCP

![Screenshot 2025-08-25 at 2.04.28 PM.png](Screenshot%202025-08-25%20at%202.04.28%20PM.png)

Use cases
- delegate responsibilities to non administrators within their permission boundaries
- allow for developers to self-assign policies and manage their own permissions while enforcing boundaries
- restrict individual users, without applying an SCP to your entire account

`Denies override allows`


## 293. AWS IAM Identity Center

- successor to SSO
- one login for all your 
	- AWS accounts in AWS organizations
	- Business cloud applications (salesforce, Box, Microsoft)
	- SAML2.0-enabled applications
	- EC2 windows instances
- Identity providers
	- Built-in identity store in IAM identity center
	- 3rd party: Active Directory (AD), OneLogin, Okta


Can integrate with something like Active Directory or the built-in IAM Identity Center Identity Store

- define `permission sets`

`EXAM` - review
![Screenshot 2025-08-25 at 2.15.14 PM.png](Screenshot%202025-08-25%20at%202.15.14%20PM.png)

AWS Fine-grained permissions and assignments
- multi-account permissions
	- manage across AWS accounts in your Org
	- permission sets - a collection of one or more IAM policies assigned to users and groups to define AWS access
- application assignments
	- SSO access to many SAML 2.0 business applications (salesforce, box, microsoft 365)
	- provide required URLs, certs, metadata
- attribute-based access control (ABAC)
	- fine-grained permissions based on user's attributes stored in IAM identity center identity store
	- use case: define permission once, then modify AWS access by changing the underlying attributes

## 294. AWS Directory Services

### What is Microsoft Active Directory (AD)
- found on any windows server with AD domain services
- Database of objectS: User Accounts, Computers, Printers, File Shares, Security Groups
- Centralized security management, account creation, assign permissions
- Objects are organized into trees, a group of trees is a forest

### AWS Directory Services
- a way to create an AD on AWS
- `AWS Managed Microsoft AD`
	- create your own AD in AWS, manage users locally, supports MFA
	- can establish a 'trust' connection with your on-prem AD
	- think: both are valid/source of truth
- `AD Connector`
	- direct gateway (proxy) to redirect to on-prem AD, supports MFA
	- Users are managed on the on-prem AD
- `Simple AD`
	- AD-compatible managed directory on AWS
	- cannot be joined with on-prem
	- think: if you do not have any on-prem AD

### IAM Identity Center - AD Integration
- Connect to an AWS Managed Microsoft AD 
	- out of the box integration
- Connect to a self-managed AD
	- create a `two-way trust relationship` using AWS managed microsoft AD

## 296. AWS Control Tower

- easy way to setup and govern a secure and compliant multi-account AWS environment based on best practices
- AWS control tower uses AWS organizations to create accounts

- benefits
	- automate the setup of environment in a few clicks
	- automate ongoing policy management using `guardrails`
	- detect violations
	- dashboard

### Guardrails
- Provide ongoing governance for your control tower environment (AWS Accounts)
- Preventative Guardrail - using SCP (restrict regions across all accounts)
- detective guardrail - using AWS config (identity untagged resources)


# Section 26 - Security, Encryption, KSM, SSM Parameter Store, Shield, WAF


## 297. Encryption 101

### Encryption  in flight (TLS / SSL)
- remember TLS is just a newer SSL
- encrypted before sending, decrypted after receiving
- TLS certs help with encryption (HTTPS)
- can send data over public networks, prevent MITM attacks (man in the middle)
- client will TLS encrypt, only target can TLS decrypt

### Server-side encryption at rest
- data is encrypted after being received by the server
- data is decrypted before being sent
- it is stored in an encrypted form with a key
- the encryption/decryption keys must be managed somewhere, and the server must have access to it

### Client-side encryption
- data is encrypted by the client and never decrypted by the server
- data will be decrypted by a receiving client
- the server should not be able to decrypt the data

## 299. KMS Overview

### Key Management Server
- AWS encryption likely is using KMS
- AWS manages encryption keys for us
- fully integrated with IAM
- easy way to control access to your data
- Able to audit KMS key usage using CloudTrail `EXAM`
- Seamlessly integrated into most AWS services (EBS, S3, RDS, SSM)
- never ever store your secrets in plaintext, or in code
	- KMS Key Encryption also available through API calls (CDK, SLI)
	- Can encrypt your own secrets with KMS keys and these can be used in your code as environment

### KMS Key Types
- `Symmetric (AES-256)`
	- single encrption key that is used to encrypt and decrypt data
	- AWS services that are itnegrated with KMS use symmetric key
	- You never get access to the KMS Key unencrypted (must call KMS API to use)
- A`symmetric (RSA & ECC Key pairs)`
	- public (encrypt) and private (decrypt) pair
	- public key is downloadable but you can't access the private key unencrypted
	- use case: encryption done outside of AWS by users who don't have access to KMS API

### Types of KMS Keys
- AWS owned (free, SSE-S3, SSE-DDB etc)
- AWS Managed key free (start with `aws/`)
- Customer managed keys in KMS: $1/month
- Customer managed keys imported $1/month
- + pay for API call to KMS $.03 / 10,000 calls

- Automatic key rotations
	- AWS managed auto every 1 y ear
	- customer managed: automatic and on-demand
	- imported: manual only

![Screenshot 2025-08-25 at 2.55.06 PM.png](Screenshot%202025-08-25%20at%202.55.06%20PM.png)

`EXAM` - cannot have the same KMS key in two regions

### KMS Key policies
- control access to KMS keys "similar" to S3 bucket policies
- difference: you cannot control access without them

- Default KMS policy
	- created if you don't provide a specific KMS key policy
	- complete access to the key to the root user = entire AWS account
- custom KMS key policy
	- define users, roles that can access the KMS
	- Define who can administer the key
	- useful for cross-account access of your KMS key

### Copying snapshots across accounts
1. create a snapshot, encrypted with your own KMS key (customer managed key)
2. attach a KMS key policy to authorize cross-account access
3. Share the encrypted snapshot
4. in target- create a copy of the snapshot, encrypt it wit ha CMK in your account

## 301. KMS - Multi-Region Keys

- primary key in one region
- can replicate key into other regions
- same key ID
- identical KMS keys, used interchangeably
- exactly the same
- enables: encrypt in one region, decrypt in others
	- can skip re-encrypt or making cross-Region api calls
- KMS Multi-Region are NOT global (primary + replicas)
- Each multi-region is managed independently
- use case: global client-side encryption in one region & decryption in another `EXAM`


### DynamoDB Global Tables - Client-Side encryption
- We can encrypt specific attributes client-side in DynamoDB using the `Amazon DynamoDB Encryption`
- if the table is global then a client in a different region then encryption would work the exact same using a replicated multi region key

### Global Aurora
- same concept works here with Aurora

## 302. S3 Replication with Encryption

- unencryped obejcts and encrypted objects with SSE-S3 are replicated by default
- object with SSE-C (customer) CAN be replicated
- For objects encrypted with SSE-KMS need to enable
	- specify which kms key to encrypt the objects within the target bucket
	- adapt the ksm key policy for the target key
	- an iam role with kms:Decrypt for the source KMS key and kms:Encrypt for the target KMS Key
	- You might get KMS throttlign errors, in which case you can access for a service quotas increase

## 303. Encrypted AMI Sharing Process

`EXAM`
1. AMI in source account is encrypted with KMS key from source account
2. modify the AMI property to add a `launch permission` add target AWS Account ID
3. Must share the KMS key used to encrypt the snapshot/AMI reference with the target account/IAM role
4. The IAM Role/user in the target account must have the permissions to describekey, reencrypt*, creategrant, decrypt

## 304. SSM Parameter Store Overview

- secure storage for configuration and secrets
- optional seamless encryption using KMS
- serverless scalable, durable, easy SDK
- Version tracking of configurations / secrets
- Security through IAM
- Notifications with Amazon EventBridge
- Integration with CloudFormation

### Store Hierarchy
- /my-org/
	- /my-app/
		- /dev
			- db-url
			- db-password
		- /prod
			- db-url
			- db-password
- /other-deparment/

Etc. self explanatory, but remember


### Tiers
- `Standard` - 4KB, $ free
- `Advanced` - 8KB $0.05 per month
	- parameter policies (advanced only)
		- can assign a TTL for parameters

## 306. AWS Secrets Manager - OVerview

- Newer service
- meant for storing secrets
- Different from SSM store
- Capability to force rotation every X days
- Automate generation of secrets on rotation (uses Lambda)
- Integrates well with RDS, Aurora, other AWS services (i.e. can store DB credentials here)
- `secrets? RDS/aurora integration == Secrets Manager`  EXAM

### Multi-Region Secrets
- Replicate secrets across multiple AWS regions

## 308. AWS Certificate Manager (ACM)

- provision, manage, deploy TLS (SSL) certificates
	- provide in-flight encryption for websites (HTTPS)

i.e. would integrate an ALB with ACM, then user access the ALB via HTTPS, and your web app can then communicate with HTTP protocol if desired

- Free of charge for publicTLS certificates
- integrate with ELBs
- CloudFront
- APIs on API Gateway
- `CANNOT USE ACM ON AN EC2 instance directly`

### ACM Requesting Public Certificates
1. list domain names to be included in the certificate
	1. list fully qualified domain name (FQDN) corp.example.com
	2. or wildcard domain *.example.com
2. select validation method, DNS validation or email
	1. DNS is preferred for automation
	2. Email validation will send emails to contact addresses in the WHOIS database
	3. DNS validation will leverage a CNAME record to DNS config (route 53)
3. Takes a few hours to get verified
4. The public certificate will be enrolled for automatic renewal
	1. ACM auto renews 60 days before expiry

### Importing Public Certs
- if you generated it outside of AWS/ACM you can import it
- No automatic renewal
	- ACM sends daily expiration events 45 days prior to expiration
		- appears in EventBridge as an event
		- then from EventBridge you can trigger handling like SNS or Lambda
	- AWS Config
		- managed rule provided that can check for expiring certificates
			- sends non-compliance event

### ACM - Integration with ALB
- On ALB redirect HTTP -> HTTPS redirect rule

### API Gateway - Endpoint Types
- edge-topimzied (default): for global clients
	- requests are routed through the cloudfront edge locations
	- API gateway still lives in only one region
- regional
	- for clients within the same region
	- could manualyl combine with cloudfront (more control over the chaching strat/and distr)
- private
	- can only be accessed from your VPC usingan interface VPC endpoint (ENI)

### Integrating with API Gateway
- create a custom domain name in API gateway
- edge optimized (default) for global clients
	- TLS certs must be in the same region as CloudFront us-east-1
	- then setup a CNAME (or better) A-Alias record in Route 53
- Regional:
	- for clients within the same region
	- TLS cert must be imported on API gateway in the same region 

## 308. Web Application Firewall (WAF

- Protects your web app from common web exploits (Later 7)
- Layer 7 is HTTP (vs layer 4 which is TCP/UDP)
- Can be deployed on
	- ALB
	- API Gateway
	- CloudFront
	- AppSync, GraphQL API
	- Cognito User Pool
	- `EXAM` cannot deploy on a `NLB`

- define web ACL (access control list) rules:
	- IP set: up to 10,000 IP addresses use multiple rules for more IPs
	- HTTP headers, HTTP body, or URI strings protect from common attacks (SQL injection, cross-site scripting)
	- Size constraints, geo-match (block countries)
	- rate-based rules - for DDoS protection
- Web ACL are regional except for CloudFront
- A rule group is a reusable set of rules that you can add to a web ACL

### Fixed IP while using WAF with a Load Balancer
- WAF does not support the NLB (cuz it's layer 4, and ALBs dont support fixed IPs `EXAM`)

## 310. Shield - DDoS Protection

- Distributed Denial of Service - many requests at the same time
	- goal is to overwhelm and attack infra
- AWS shield standard
	- activate for every AWS customer
	- provide protection from attacks, and layer 3/4 attacks
- Shield Advanced
	- optional DDoS mitigate service ($3,000 per month per org)
	- more sophisticated protection on EC2, ELB, CloudFront, Global Accelerator, Route53
	- 24/7 access to AWS DDoS response team DRP
	- Protect against higher fees during usage spikes due to DDoS

## 311. Firewall Manager

- Manage rules in all accounts of an AWS org
- Security policy: common set of security rules
	- WAF rules, ALBs, API gateways, cloudfront
	- AWS shield advanced (ALB, CLB, NLB, Elastic IP, cloudfront)
	- security groups for EC2, ALB and ENI resource in VPC
	- AWS Network Firewall (VPC level)
	- Route53 Resolver DNS firewall
	- Policies create at the regional level
- Rules re applied to new resources as they are created (good for compliance) across all and future accounts in your ORG

### WAF, Firewall Manager, Shield
- used together
- WAF: web ACL rules, granular protection
- Firewall Manager: cross-acount WAF, accelerate configuration

## 313. DDoS Protection Best Practices

- BPI - cloudfront
	- web application delivery at the edge
	- protect from DDoS common attacks
- BPI - globla accelerator
	- access your app from the edge
	- integration with shield for DDoS protection
	- helpful if your backend is not compatible with cloudfront
- BPI - Route53
	- DNR is at the edge


- Infrastructure layer defense (BP1, BP3, BP6)
	- protect EC2 against high traffic
	- Global Accelerator, Route53, CloudFront, ELB
- EC2 with auto scaling (BP7)
	- helps scale in  case of a sudden flash or DDoS attack
- ELB (BP6)
	- scales with traffic and will distribute traffic to many ec2 instances


- application layer defense
- detect and filter malcious web reqeuts (BP1, BP2)
	- cloudfront cache static content and serve it from edge location protecting your backend
	- WAF used on top of CF and ALB to filter and block requests based on signatures
	- WAF rate-based rules can atuo block IPs of bad actors
	- WAF has manged rules
	- CF can block specific geographies
- Shield advanced (BP1, B2, BP6)
	- DDoS protection
	- WAF layer 7 protection

- attack surface reduction
- obuscating AWS resources (BP1, BP4, BP6)
	- using CloudFront, API Gateway, ELB to hide your backend resources
- Security groups and network ACLs (BP5)
- Protecting API endpoints (BP4)
	- hide ec2, lambda, elsewhere
	- edge optimized mode, or cloudfront + regional mode
	- WAF + API


## 314. Amazon GuardDuty

- Intelligent threat discovery to protect your AWS account
- uses ML algo, anomaly detection
- One click (30 day trial) no installations
- Input data includes
	- CloudTrail Events Logs - unusual API calls, unauthorized deployments
	- VPC flow Logs
	- DNS logs
	- Optional features - EKS audit logs, RDS and Aurora logs, EBS, Lambda, S3 Data Events
- EventBridge Rules to be notified in case of findings
- EventBridge rule cant target AWS lambda or SNS
- `Good for protecting against Crypto Currency attack` `EXAM`


## 315. Amazon Inspector

- Run automated security assessments
- on EC2 instances
	- leverages AWS Systems Manager (SSM) agent
	- analyze against unintended network accessibilities
	- analyze OS against known vulnerabilities
- Container images push to ECR
	- analyzed by inspector
- lambda functions
	- software vulnerabilities, package dependencies


- can report findings to AWS Security Hub
- can send findings to Amazon Event Bridge

### Evaluates:
only for running `EC2 isntance, container images, lambda functions`
that's it
`EXAM`

- package vulnerabilities (all) vs database of CVE
- network reachability (EC2)

## 316. Amazon Macie

- fully managed data security and privacy service that uses ML and pattern matching to discover and protect your sensitive data in AWS
- helps you identify and alert you to sensitive data such as PII
	- can integrate with EventBridge
	- i.e. `find sensitive data in your S3 bucket`
	- apparently S3 only

## Quiz

## Servicer side Encryption (SSE) definition:
encryption and decryption happens on the server, client is unaware


## Do customer-managed CMKs in KMS support automatic key rotation and retention periods?
if you enable automatic rotation on your KMS key, backing key is rotated every year.

## What is a backing key when it comes to KMS?

## You have a secret value that you use for encryption purposes, and you want to store and track the values of this secret over time. Which AWS service should you use?
AWS KMS Versioning feature? or SSM Parameter Store


## GuardDuty scans the following EXCEPT
CloudTrail
VPC Flow Logs
DNS Logs
CloudWatch Logs <-- got it right, intuition is this seems too granular compared to other options

## SQL injection preventing-service?
WAF

## Secrets Manager vs SSM Parameter store?
think RDS integration -> secrets manager


## What even is cloudHSM?


## You have created a Customer-managed CMK in KMS that you use to encrypt both S3 buckets and EBS snapshots. Your company policy mandates that your encryption keys be rotated every 6 months. What should you do?
- enabled automatic key rotation and specify the desired retention period
- follow up: IMPORTED keys (different from CMK in KMS) do not support this


## You have generated a public certificate using LetsEncrypt and uploaded it to the ACM so you can use and attach to an Application Load Balancer that forwards traffic to EC2 instances. As this certificate is generated outside of AWS, it does not support the automatic renewal feature. How would you be notified 30 days before this certificate expires so you can manually generate a new one?


## Where is the only place you can create ACM certificates?
us-east-1


AWS GuardDuty does what?


# Section 27 - Networking - VPC


## 317. CIDR, Private vs Public IP

`Classless Inter-domain Routing`
method for allocating IP adddresses
- used in security group rules and AWS networking in general
- help define an IP range

0.0.0.0/0 0 -> one IP

### components
- CIDR consists of two components
- `BASE IP`
	- represents an IP contained in the range (XX.XX.XX.XX)
	- Example 10.0.0.0, 192.168.0.0
- `Subnet Mask`
	- Defines how many bits can change in the IP
	- Ex. /0 /24 /32
	- AWS uses the slash form but:
		- /8 <-> 255.0.0.0
		- /16 255.255.0.0
		- /24 244.244.255.0
		- /32 255.255.255.255
### Subnet Mask

192.168.0.0/32 -> 1 IP -> 2^0 -> 192.168.0.0 (1)  
192.168.0.0/31 -> 2 IPs -> 2^1 -> 192.168.0.0 through 192.168.0.1 (2)  
192.168.0.0/30 -> 4 IPs -> 2^2 -> 192.168.0.0 through 192.168.0.3 (4)  
192.168.0.0/29 -> 8 IPs -> 2^3 -> 192.168.0.0 through 192.168.0.7 (8)  
192.168.0.0/28 -> 16 IPs -> 2^4 -> 192.168.0.0 through 192.168.0.15 (16)  
192.168.0.0/27 -> 32 IPs -> 2^5 -> 192.168.0.0 through 192.168.0.31 (32)  
192.168.0.0/26 -> 64 IPs -> 2^6 -> 192.168.0.0 through 192.168.0.63 (64)  
192.168.0.0/25 -> 128 IPs -> 2^7 -> 192.168.0.0 through 192.168.0.127 (128)  
192.168.0.0/24 -> 256 IPs -> 2^8 -> 192.168.0.0 through 192.168.0.255 (256)

...

192.168.0.0/16 -> 65,536 IP -> 2^16 -> 192.168.0.0/ through 192.168.255.255 (65,536)

...

192.168.0.0/0 -> all IPs -> 2^32 -> 0.0.0.0 -> 255.255.255.255 -> 4.3B total IPv4 Addresses


Remember IP addresses are made up of 4 octets

/32 - no octet can change
/24 last octet can change
/16 last 2 octets can cahnge
/8 last 3 octets can change
/0 all octets can change

basically every `/32 -8` == octet number that can change

think `/0./8./16./24` and `/32` ==  exactly one IP


### Public vs Private IP
Private IP can only allow certain values
- 10.0.0 - 10.255.255.255 (10.0.0.0/8)

## 319. Default VPC Overview

- all new accounts have default VPC
- new EC2 instances are launched into the default VPC is no subnet is specified
- has internet connectivity and EC2 instances inside it have a public IPV4 addresses
- get a public and private IPV4 DNS name


## 320. VPC Overview

- VPC - virtual private cloud
- multiple vpc in an AWS region, max 5 per region soft limit
- max CIDR per VPC is 5, for each CIDR
	- `min size /28` (16 ip addresses)
	-` max sizes /16` (65536 IP addresses) `EXAM`
- Because VPC is private, only `Private IPv4 ranges` are allowed
	- 10.0.0.0 - 10.255.255.255 (10.0.0.0/8)
	- 172.16.0.0 - 172.31.255.255 (172.16.0.0/12)
	- 192.168.0.0 - 192.168.55.255 (192.168.0.0/16)

remember VPC CIDR should not overlap with your corporate or onprem networks if you want to connect it to AWS


## 322. Subnet Overview

### Subnet (IPv4)
- AWS reserves 5 IP addresses (First 4 and last 1) in each subnet
- `These 5 addresses are not available for use` and can't be assigned to an EC2 instance
- Example if CIDR block 10.0.0.0/24 then reserved IP addresses are
- 10.0.0.0 - > 10.0.03 and the last one

`Number of IP addresses formuka`
numIP = 2^(32-slashNum)

I.e. /27   =>  2^(32- 27) = 32

But remember 5 are reserved by AWS. So if you need 29....32-5 = 27
not enough
`EXAM`

Remember the smaller the number in the `/num` for the CIDR block the more IP addresses you have

![Screenshot 2025-08-28 at 11.26.46 AM.png](Screenshot%202025-08-28%20at%2011.26.46%20AM.png)

- Subnets belong to an AZ
- Small CIDR blocks are good like 10.0.0.0/24 for a subnet

## 324. Internet Gateway & Route Tables

- IGW - `allows resources in a VPC to connect to the internet`
	- said differently, enables traffic OUTSIDE of the VPC
- scales horizontally and is highly available
- must be created separately from a VPC 
- stateful
- `VPC has 1:1 relationship with IGW`
- IGWs on their own do not allow internet access
	- Route tables are needed too
	
![Screenshot 2025-08-28 at 11.49.52 AM.png](Screenshot%202025-08-28%20at%2011.49.52%20AM.png)


- must manually attach an IGW to your VPC
- Need a `route table` now for internet access
	- Private route able
		- add private subnets
	- Public route table
		- add public subnets
			- by default there is `10.0.0.0/16`/whatever your VPC CIDR is which routes locally 

## 326. Bastion Host

- Way to give users on the public internet access to resources in our private subnet
- `EC2 Instance Bastion Host` in the public subnet
	- give users SSH access to bastion host / proper security group
	- bastion host has a security group / SSH access to the private subnet via it's private IP address
	
- `EXAM` bastion hope host allow inbound access from the internet on port 22 FOR SSH
	- to be secure you can restrict the IP addresses, such as your public corporate CIDR

	![Screenshot 2025-08-28 at 12.10.32 PM.png](Screenshot%202025-08-28%20at%2012.10.32%20PM.png)

Think SSH and port 22


## 328. NAT Instances

- `Outdated` but still on the exam
- `NAT` network address translation
	- think: NATs rewrite network packets, both ways
- allows EC2 instances in private subnet to connect to the internet
- must be launched in a public subnet
- `must disable EC2 setting: source/destination check`
- must have elastic IP attached to it
- Route tables must be configured to route traffic form private subnet to the NAT instance

![Screenshot 2025-08-28 at 12.24.23 PM.png](Screenshot%202025-08-28%20at%2012.24.23%20PM.png)

- not highly available or resilient out of the box

## 330. NAT Gateways

- preferred solution over nat instances
- AWS managed, higher bandwidth, high availability, no administration
- Pay per hour for usage
- NATGW is created in a specific AZ, uses an EIP
- Can't be used by instances in the same subnet (only from other subnets)
- Requires an IGW (private subnet -> NATGW -> IGW)
- No security groups required
- high bandwidth up to 100 GBPS

![Screenshot 2025-08-28 at 12.34.45 PM.png](Screenshot%202025-08-28%20at%2012.34.45%20PM.png)


### High availability
- resilient within a single AZ (redundant in an AZ)
- `must create multiple NAT gateways in multiple AZs for fault tolerance`


## 332. NACL & Security Groups

- NACL - Network ACL
	- stateless
- Security Group
	- statefull (if inbound request is allowed, the outbound response is allowed)
		- if it was allowed in is allowed out
		- this is different from inbound/outbound rules which operate below this logic

![Screenshot 2025-08-28 at 2.10.16 PM.png](Screenshot%202025-08-28%20at%202.10.16%20PM.png)

### Summary
SG rules get evaluated once
NACL rules get evaluated twice

### NACL
- like a firewall which control traffic to and from subnets
- One NACL per subnet
- NACL have rule
	- rule 1 takes priority over rule 2,000
	- first match drives the decision
	- last rule is an asterisk (`*`) denies a request in case of no match
	- `great for blocking IP addresses at a subnet level`

### Default NACL
- accepts everything inbound/outbound with the subnet it's associated with
- `EXAM`
- generally, do not modify this
- create a custom NACL

### Ephemeral Ports
- for any 2 endpoints to establish a connection they must use ports
- Clients connected to a `defined` port, and expect a response on an `ephemeral` port
- Client will open a temporary port on itself for the duration of the connection so it can receive the response
	- Different OSs have different ranges

### NACL with Ephemeral Ports
- basically you need rules that consider the range of possible ephemeral ports
- if you want a public subnet with its own NACL to communicate with another private subnet with its own NACL
 
![Screenshot 2025-08-28 at 2.18.26 PM.png](Screenshot%202025-08-28%20at%202.18.26%20PM.png)

### Security Group vs NACL
`Security Group`
- instance level
- ALLOW rules only
- stateful: meaning return traffic is auto allowed, despite any rules
- All rules are evaluated
- Applies to an EC2 when applied to one
`NACL`
- subnet level
- ALLOw and DENY rules
- stateless (traffic is evaluated in both directions)
- Rules are evaluated 1st to Nth, first match wins

## 334. VPC Peering

- Privately connect tow VPCs using AWS's network
- Make them behave as if they were the same network
	- different regions, different accounts etc
	- if they are connected cannot have overlapping CIDRs
	- (connected VPCs do not connective transitively, they must have explicit peering connections setup)
	- must update the route tables in each subnet for this to work

### Good to know
- cross account
- cross region
- can reference security groups from peered VPCs (cross account or same region)![Screenshot 2025-08-28 at 2.33.56 PM.png](Screenshot%202025-08-28%20at%202.33.56%20PM.png)


## 336. VPC Endpoints (AWS PrivateLink)

- Gives AWS instances directly through the private AWS network to another AWS service
	- i.e. DynamoDB, S3, CloudWatch are typically accessed through the public internet

- deployed within the VPC, can make an EC2 instance go directly to a resource
- Every AWS service is publicly exposed (public URL)
- Removes the need for IGW, NATGW if you just want to connect to AWS resources
- see diagram for equivalent setups
	- note if you want to connect to a S3 bucket via a VPC endpoint you still need an IAM role on the requesting EC2 instance
### Two different aways to connect EC2 instances to SNS

![Screenshot 2025-08-28 at 2.59.41 PM.png](Screenshot%202025-08-28%20at%202.59.41%20PM.png)

1: public -> IGW -> SNS
1: private -> NAT Gateway ($) -> IGW -> SNS
2: any -> VPC Endpoint -> SNS


### Types of Endpoints
- `Interface Endpoints (powered by PrivateLink`
	- Provisions an ENI (private IP address) as an entry point (needs an SG)
	- Supports most AWS services
	- $ per hour + $ per GB
	- preferred if you want private access from an on-prem network or a different VPC
	
- `Gateway Endpoint`
	- Provisions a gateway and must be used as a TARGET in a route table
	- Only supports `S3` and `DynamoDB`
		- for these services it is preferred
		- also free

## 338. VPC Flow Logs

- capture information about IP traffic going into your interfaces
- VPC level, Subnet level, ENI level
- Helps monitor and troubleshoot connectivity issues
- Flow logs can go to S3, cloudWatch Logs, and Kinesis DataFireHose
- Captures network from AWS managed interfaces too: ELB, RDS, ElastiCache, redshift, workspaces, NATGW, transit gateway


## 340. Site to Site VPN, Virtual Private Gateway & Customer Gateway

- Connect corporate data center / on prem network to your VPC
- through customer gateway
- over public network
- but it is encrypted

### Virtual Private Gateway (VGW)
- VPN concentrator on the AWS side of the VPN connection
- VGW is created and attached to the VPC from which you want to create the Site-to-Site VPN connection
- Possibility to customize the ASN 

###  Customer Gateway
- software or physical device on customer side of the VPN connection

### Site-to-Site VPN Connections
- Customer gateway device (on-prem)
	- what IP address to use?
		- public internet-routable IP adress for your customer gateway device
		- If it is behind a NAT device that's enabled for NAT traversal (NAT-T) use the public IP address of the NAT device
	- Important Step
		- enable route propagation for the virtual private gateway in the route table that is associated with your subnets
- If you need to ping your EC2 instances from on-prem, make sure you have the ICMP protocol inbound allowed for your security group
- `THIS IS ALL EXAM MATERIAL`
- `MAKE SURE YOU UNDERSTAND THIS`


![Screenshot 2025-08-28 at 5.03.47 PM.png](Screenshot%202025-08-28%20at%205.03.47%20PM.png)


### AWS VPN CloudHub
- imagine you have multiple corporate networks with their own customer gateway
- you can have them all communicate with each other through a VGW on AWS CPN CloudHub
- hub-and-spoke model
- to setup connect multiple VPN connections on the same VGW, setup dynamic routing and configure route tables


## 342. Direct Connect + Direct Connect Gateway

(DX)
- dedicated physical `private` connection from your remote network to your VPC
- think physical fiber link
	- site to site VPN is not dedicated
- on the same connection you can access both public an private resources on the same connection
- Use cases:
	- increases bandwidth throughput, lower cost
	- more consistent private network
	- hybrid environments
- IPv4 and IPV6

### Direct Connect Gateway
- how you setup Direct Connect to one or more VPC in many different regions (same account)

### Direct Connect -- Connection Types
- `Dedicated Connections,` 1, 10, and 100 Gbps capacity
	- physical ethernet port dedicated to a customer
	- Request made to AWS first then completed by AWS DX partner
	- think dedicated, faster/better performance
	- "1 gig" internet min
- `Hosted Connections`: 50 MPbs, 500 MPbs, 10 Gbps
	- connection requests are made via AWS DX Partners
	- Capacity can added or removed on demand
	- "less than 1 gig" internet options
- Lead time are often longer than 1 month `EXAM` so for quick projects DX not an option


### DX Encryption
- data in transit is not encrypted bt is private
- AWS DX + VPN provides an IPsec-encrypted private connection
- extra level of security

### DX Resiliency
- `EXAM
- `High Resiliency for Critical Workloads`
	- two different DX locations
	- 2 total connections across 2 locations
- `MAXIMUM Resilliency for Critical Workloads`
	- two DX locations that each have 2 locations

## 343. Direct Connect + Site to Site VPN

- In case DX fails, you can set a backup connection (expensive) or a site-to-site VPN connection (CloudHub)
- if primary connection fails then we can fall back to site to site VPN which uses the public internet (which is likely more reliable...it is the public internet)

## 344. Transit Gateway

- network topologies can be complicated
- solves this

- For `transitive peering` between thousands of VPCs, on-prem, hub-and-spoke (star) connection
	- basically with transit gateway we can have transitive peering between VPCs, site to site VPNs, and DX connection
- Regional, can work cross-region
- Need route tables for your transit gateway to limit
- `Only service that supports IP Multicast` `EXAM`


### Transit Gateway ECMP
- Equal Cost Multi Path routing
- Routing strategy to allow forward packet over multiple best path
- Use case: create multiple site to site VPN connections to increase the bandwidth of your connection to AWS
	- basically you can use more tunnels `EXAM` to double, triple etc throughput
	- think of this as "enabling" alternate routes of the same length. instead of standard routing which will always take the same path
	- `uses multiple VPN or DX connections in parallel instead of keeping one(s) idle`


## 345. VPC Traffic Mirroring

- allows you to capture and inspect network traffic in your VPC
- non-intrusive
- route traffic to security appliances that you manage
- capture the traffic
	- from (source) ENI - (think of ENIs like a wifi card on an EC2 instance)
	- to (targets) - an ENI or NLB
	- optional filtering

use cases

## 346. IPv6 for VPC

- IPv4 was designed to provide 4.3 Billion addresses...will eventually run out
- IPv6 is the sucessor
- designed to provide an incredible amount of new IP addresses
- Every IPv6 address in AWS is public
- format is x.x.x.x.x.x.x.x 
- `::/0` is the everything notation for IPv6

### IPv6 in VPC
- IPv4 cannot be disabled
- You can enable IPv6 `they're public ip addresses`

- your EC2 instances get at least an internal IPv4 and a public IPv6
- They can communicate using either through an IGW

### IPv4 troubleshooting `EXAM`
- if you cannot launch an EC2 instance in your subnet
	- it is likely no available IPv4 addresses lest in your subnet
- `solution`: need a new IPv4 CIDR in your subnet


## 348. Egress Only Internet Gateway

- Used only for IPv6
	- similar to a NAT Gateway put for IPv6
	- but IPv6 does not use NAT gateways
	- stateful--allows SOLICITED inbound traffic only (i.e. the response to your request but not new connection)
- allows instances in your VPC outbound connections over IPv6 while preventing the internet to initiate an IPv6 connection to your instances
- `You ust update the route tables`




## 351. VPC Section Summary

`CIDR` - IP Range
`VPC` - virtual private cloud, IPv4 and IPv6 OK
`Subnets` - tied to an AZ, define a CIDR for each, make up a VPC
`IGW` - at the VPC level, provides IPv4/6 internet access
`Route Tables` - must be edited to add routes from subnets to the IGW/VPC Peering Connections/VPC endpoints `review`
`Bastion Host` - Public EC2 instance with SSH access to EC2 instance(s) in private subnet(s)
`NAT Instance` - deprecated, gives Interface access to EC2 instances in private subnet via public EC2 instance. Must disable source/destination check flag
`NAT Gateway` - new managed, way of giving private EC2 instances internet access if the target is an IPv4 address (IPv6 does not need NAT) 

`NACL` - stateless, subnet rules for inbound/outbound traffic, remember ephemeral ports
`Security Groups` - stateful, operate at the EC2 instance level
`VPC Peering` - connect two VPCs with non overlapping CIDR, non transitive
`VPC Endpoints` - provide private access to AWS Services (S3/DynamoDB Gateway Endpoints, everything else CloudFormation/SSM) within a VPC
`VPC Flow Logs`- can be setup at the VPC /Subnet / ENI Level for ACCEPT and REJECT traffic, helps identify attacks, analyze using Athena or CloudWatch Logs Insights
`Site to Site VPN` - Setup a Customer Gateway on DC, a Virtual Private Gateway on VPC, and site to site VPN over public Internet
`AWS VPN CloudHub` hub-and-spoke VPN model to connect your sites

`Direct Connect` - setup a Virtual Private Gateway on VPC, and establish a direct private connection to an AWS Direct Connect Location
`Direct Conenct Gateway` - setup a DX to many VPCs in different AWS regions `review`
`AWS PrivateLink/VPC Endpoint Services` 
- Connect services privately from your service VPC to customers VPC
- Doesn't need VPC peering, public Internet, NAT Gateway, Route tables
- Must be used with NLB & ENI
`ClassicLink` - deprecated, connect EC2-Classic EC2 instance privately to your VPC
`Transit Gateway` - transitive peering connections for StS VPN, DX
`Traffic Mirroring` - copy network traffic from ENIs for further analysis
`Egress-only Internget Gateway` - just like a NAT Gateway but for IPv6 (outbound traffic)


`review`
Virtual Private Gateway
StS VPN setup
Customer Gateway
PrivateLink
Transit Gateway

How referencing a SG works for a downstream target i.e. source -> ALB -> ASG/EC2s (if the ASG references the ALB's SG it isn't copying it's rules, it's saying allow traffic from any ENI with this SG attached. The SG is a dynamic reference to the ALB--which is a managed resource)

CIDR Math

## 352. Networking Costs in AWS

### Per GB - Simplified
- Traffic into EC2 is free
- Free traffic within an AZ (use private IPs)
- cross-AZ is not free
	- private cross-AZ is half price of
	- public cross-AZ
	- `private always cheaper and better network performance`

- cross-region is not free
	- $0.02/GB

- keeping things in same AZ decreases availability but increases savings


### Minimizing egress traffic network cost
- `egress` -> AWS outbound
- `ingress` -> inbound traffic (typically free)
- try to keep as much interface traffic within AS to minimize costs
- if using DX, location should be co-located in the same AWS Region result in lower costs for egress network

### S3 Data transfer Pricing - analysis for USA
- S3 ingress: free
- s3 to Internet: $0.09 per GB
- S3 transfer acceleration
	- additional cost for better performance
- S3 to CloudFront - free between these
- CloudFront to internet
	- per-request much cheaper
	- per GB rate also slightly lower
- S3 Cross region replication
	- pay per GB

### Nat Gateway vs Gateway VPC Endpoint
- VPC Endpoints are much cheaper if the goal is to target a public AWS resource like S3
- private subnet -> NAT GATEWAY -> IGW is for external targets

## 353. AWS Network Firewall

- Seen
	- NACLs
	- VPC SGs
	- AWS WAF (malicious http requests)
	- AWS Shield / Advanced (DDoS)
	- AWS Firewall Manager (managed WAF and Shield across accounts)

### AWS Network Firewall
- protect entire amazon VPC
- from layer 3 to layer 7
	- `can inspect any traffic in any direction`
- Internally, firewall uses AWS Gateway Load Balancer
- Rules can be centrally managed by accounts

### Network Firewall - FineGrained Controls
- Supports 100s of rules
- regex pattern matching
- allow, drop, alert based on matches

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

# Section 31 - WhitePapers and Architectures


## 385. AWS Well-Architected Framework & Well-Architected Tool


- stop guessing your capacity needs
- test systems at production scale
- automate to make architectural experimentation easier
- allow for evolutionary architectures
	- design based on changing requirements
- drive architecture using data
- improve through game days
	- simulate applications for flash sale days

### 6 Pillars
1) operational excellence
2) security
3) reliability
4) performance efficiency
5) cost optimization
6) sustainability
- `EXAM`
- these are not something to balance or trade-off, they are mostly synergistic

### Well Architected Tool
- free tool to review your architectures against he pillars
- enter a workload
- can use custom lens

## 386. Trusted Advisor

- high level account assessment
- checks:
	- do you have public EBS or RDS snapshots?
	- are you using the root account inappropriately?
	- MFA?
	- unrestricted port access in SGs
	etc.
6 Categories
- cost optimization
- performance
- security
- fault tolerance
- service limits
- operational excellence

Business & Enterprise support plan
- full set of checks
- programmatic access using AWS Support API


## 387. More Architecture Examples


- explored patterns
	- classic: EC2, ELB, RDS, ElastiCache
	- serverless: S3, Lambda, DynamoDb, CloudFront, API Gateway etc

more reference architectures
- aws architecture center

# Section 32 - Exam prep

