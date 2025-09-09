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
