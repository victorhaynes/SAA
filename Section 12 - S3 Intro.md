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
