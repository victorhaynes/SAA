# Section 13 - Advanced S3

## 144. S3 Lifecycle Rules with S3 Analytics

Standard -> standard IA -> intelligent tiering -> one-zone ia -> glacier instant -> glaciar flexible -> glacier deep

`Transaction Actions` - configure object transitions

`Expirations actions` - delete files based on rules, delete old files, delete incomplete multi part uploads


### Store class analysis
- `S3 analytics` helps you decide when to transition objects to the right storage class
- creates CSV report
- updated daily
- does not work for One-Zone IA or Glacier
	- only for standard and standard IA


## 145. Reqeuster Pays

- `EXAM`
- In general, owner pays for all data transfer cost and storage
- Requester Pay Bucket makes the request pay for the networking cost (owner pays for storage)
- Helpful if you want to share large datasets with other accounts
- Request must be an AWS account (not anonymous, can't charge anonymous users)


## 147. S3 Event Notifications

S3:Object --- Created, Removed, Restore, Replication etc...
- Use case: automatically react to certain events
	- i.e. create thumbnails of images of images upadated
	- Can send event notifications to targets such as SNS, SQS, Lambda


S3 events need IAM permissions for sending notifications
- SNS Resource (access) policy
- SQS Resource (access) policy
- Lambda Resource (access) policy

`Exam`

`S3 events requires resource access policies`

Can also integrate with `EventBridge`
- from EventBridge can send events to over 18 different AWS services as destinations
- advanced filtering options (metadata, object size, name)
- Multiple destinations at a time

## 149. S3 Performance

- scales to high number of requests, low latency of 100-200ms
- 3500 put/copy/post/delete per second per prefix
- 5500 get/head requests per prefix in a bucket

### Optimization `EXAM`
-` multi-part upload`
	- recommended for files > 100 MB
	- must use for > 5GB
	- can help parallelize uploads (parallelize the parts then reconstitute)
- `S3 Transfer acceleration`
	- increase transfer speed by transferring a file to an AWS edge location which will forward the data to the s3 bucket int eh target
	- i.e. USA file -> fwd to Edge Location in USA (uses fast private AWS network, minimize slow public internet) -> land in S3 australia bucket
- `S3 Byte-Range Fetches`
	- Parallelize GETs by requests specific byte ranges
	- better resilience in case of failures
	- ` can be used to speed up download`
	- EXAMPLE FILE ->
		- Part 1 (byte range), Part 2, Part 3, Part N

## 150. S3 Batch Operations

- bulk operations on existing S3 objects with a single request
	- i.e. modify all object metadata and properties
	- encrypt all unencrpted objects `EXAM`
	- modify tags
	- restore from glacier
	- invoke lambda
	- copy between S3 buckets
- a job consisst of a list of objects, the action to perform, and operational parameters
- S3 Bach operations benefits
	- retries
	- progress tracking
	- notifications
	- generate reports


## 151. S3 Storage Lens

- understand analyze and optimzie storage across AWS organization
- discover anomalies, , identify cost efficiencies, apply data protection best practices
- aggregate data for organization, specific accounts, regions, buckets, prefixes
- default dashboard or create your own dashbaords
- can be configured to export metrics daily to an S3 bucket

### Default Dashboard
- summarizes insights and trends for both free and advanced metrics
- pre-configured by S3
- can't be deleted
- shows multi-region and multi-account data `EXAM`

### Storage Metrics `EXAM`
-` Summary Metrics`
	- general insights
	- storage bytes
	- object count
	- identiy fast growing or not used buckets and prefixes
- `cost optimization metrics`
	- noncurrentversion storage bytes (old item space usage)
	- incomplete upload bytes usage
- `data protection metrics`
	- insides for data protection features
	- identify buckets not following best practices
- `Access management metrics`
	- provide insights for s3 object ownership
- `Event Metrics`
	- insights for S3 event notifications
- `Performance Metrics`
	- insights for s3 transfer acceleration
- `Activity Metrics`
	- insights about how storage is requests
	- byes downlaoded etc
- `Detailed Status Code Metrics`
	- Provide insights for HTTP status codes
	- 200sm 403s, 404s etc

### Storage Lens Free vs Paid
- `Free MEtrics`
	- automatically available for all customers
	- around 28 usage metrics
	- data remains for 14 days
- `Advanced metrics recommendations`
	- additional
	- advanced metrics
	- cloudwatch publishing
	- prefix aggregation
