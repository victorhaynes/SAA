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
