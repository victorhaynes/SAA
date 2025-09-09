# Section 14 - S3 Security

## 151.  Encryption

4 methods
- server side encryption (SSE)
	- SSE S3 - AWS managed keys nabled by default
	- SSE KMS - with KMS kjey
	- SSE-c - customer provided key
- Client side Encryption (encrypted before upload)

`EXAM`
### SSE-S3
- encryption using key handled managed and woend by AWS
- object is encrypted-sver-side
- encryption type is AES-256
- must set header "x-amz-server-side-encryption": "AES256"
- enabled by default

### SSE-KMS (+ new DSSE KMS option...double)
- manage your own keys using KMS (key managed services)
- user control of the keys, audit key usage using CloudTrail
- must set header "x-amz-server-side-encrypton": "aws:kms"

### SSE-KMS Limitations
- If you use SSE-KMS you may be impacted by the KMS limits
- When you upload it calls the GenerateDataKey KMS API
- When you download it calls the Decrypt KMS API
- Couns towards the KMS quota API calls per second
- may get throtteld `EXAM`

### SSE-C
- SSE
- managed outside of AWS
- S3 does NOT store the encryption key you provide
- HTTPS must be used
- encryption key must be provided in HTTP headers for HTTP request made
- user provides key for the upload and the read

### Client Side Encryption
- use libraries like amazon S3 Client-Side Encryption Library
- clients must encrypt themselves outside of S3
- clients must decrypt themvselves after reiving from S3
- customer fully manages the keys and encryption cycle

----

### Encryption in transit
- called SSL/TLS
- S3 has 2 endpoints
	- HTTP endpoint not encrypted
	- HTTPS endpoint in flight
- HTTPS strongly recommended
- HTTPS mandatory for SSE-C

----

### Force Enncryption in Transit
- aws:SecureTransport

## 154.  Default Encryption

- SSE-S3 encryption is automatically applied to new objects stored in S3 bucket

## 155. S3 Cors

- Cross-Origin Resource Sharing (CORS) `EXAM`
- Origin = scheme + host + port (protocol + domain + port)
	- SAME origin
		- http://example.com/app1
		- http://example.com/app2
	- Different Origin
		- http://www.example.com
		- http://other.example.com
- Requests wont be fulfilled unless the other origin allows for the request using CORS Headers (Example: Access-Control-Allow-Origin)

- If a client makes a cross-origin request on our S3 bucket, we need to enable the correct CORS headers
- popular exam question
- Can allow for a specific origin or * for all origins



## 156. MFA Delete & Acess Logs

- force MFA before doing important S3 operations
- must enabled versioning `EXAM` - only root account or bucket owner can enable this


### Access Logs
- can log all access
- any request, account,authorized, or denied will be logged in another S3 bucket
- target logging bucket be in the same AWS region

## 157. Pre-signed URLs

- Generate pre-signed URLs 
- has an expiration
	- 1 min up to 168 hours
- mirrors the permissions of the user that generated the URL


## 163. Glacier Vault Lock & S3 Objet Lock

- Adopt a WORM model
	- Write Once Read Many
- Create a volt lock policy
- lock the policy for future edits
	- cannot be changed or deleted by anyone
	- helpful for compliance

### S3 Object lock works similarly
- needs versioning
- Adopt a WORM model
- Block an object at the object level (not a bucket level)

Has `retention modes` - `EXAM`
- `Compliance` - basically Glacier lock but for S3
	- object versions can't be overwitten or deleted by any user
	- can't be changed, retention period can' be shorterned
- `Governance`
	- most users can't overwrite or delete an object version or alter the lock settings
	- some users have special permissiosn to alter
- `Retention Period`
	- protect for a fixed period can be extended
- `Legal Hold`
	- hold indefinitely

## 164. S3 Access Points

- alternative to making complex bucket policies for managing groups of user's access


A Finance Group can get a Finance Access Point Policy
- grants Read/Write to the /finance prefix in S3

Sales group gets Sales Access Point Policy
- grants Read/Write to the /sales prefix in S3

etc.

Each access point has:
	it's own DNS (internet origin or VPC origin)
	access point policy (similar to a bucket policy)

### VPC Origin
- must create a VPC endpoint to access the access point

## 165. S3 Object Lambda

- Use AWS Lambda functions to change the object before it is retrieved by the caller application
- Only one S3 bucket is needed, on top of which we create S3 Access Point and S3 object lambda access points

