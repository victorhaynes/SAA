# Section 7 - EC2 Instance Store

## 1-EBS


`Elastic Block Store` - a network drive you can attach to an instance
- persists data, even after EC2 instance deletion

- like a hard drive accessed over a network

- Some EBS volumes provide a multi-attach feature

- bound to a specific availability zone

- ebs snapshots can move across AZs

- has provisioned capacity (GBs and IOPs)

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
