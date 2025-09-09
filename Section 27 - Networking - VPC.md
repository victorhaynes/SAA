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
