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
