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
