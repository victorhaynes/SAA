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
