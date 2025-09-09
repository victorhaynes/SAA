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
