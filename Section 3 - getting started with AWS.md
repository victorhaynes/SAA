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


