# SSM Inventory

Automatic software and configuration tracking
across EC2 fleet using AWS SSM Inventory.

## Results From Our EC2 Instance

### Instance Information
| Field | Value |
|---|---|
| Instance ID | i-0263a2b3237a5b6e6 |
| Computer Name | ip-10-0-6-194.us-east-2.compute.internal |
| IP Address | 10.0.6.194 |
| Platform | Amazon Linux 2023 |
| Platform Type | Linux |
| SSM Agent | amazon-ssm-agent v3.3.4515.0 |
| Status | Active |
| Resource Type | EC2Instance |

### Network Interfaces
| Interface | IPv4 | IPv6 | MAC Address |
|---|---|---|---|
| enX0 | 10.0.6.194 | fe80::40:cdff:fe12:f0f3 | 02:40:cd:12:f0:f3 |
| docker0 | 172.17.0.1 | - | 02:42:91:f8:a1:e6 |

### Applications Installed
- Total packages tracked: 50
- Collection schedule: every 30 minutes
- Sample packages found:
  - perl-Digest 1.20
  - vim-filesystem 9.2.240
  - perl-Data-Dumper 2.191
  - ncurses-libs 6.6
  - perl-Net-SSLeay 1.94
  - docker 25.0.14
  - amazon-ssm-agent 3.3.4515.0

### Patch Compliance
| Metric | Count |
|---|---|
| Installed Patches | 53 |
| Missing Patches | 0 |
| Failed Patches | 0 |
| Status | Compliant |

## Association Details
| Field | Value |
|---|---|
| Association ID | 329bd303-c0c1-4ed6-9e86-0b1152f5fedc |
| Document | AWS-GatherSoftwareInventory |
| Schedule | rate(30 minutes) |
| Target | i-0263a2b3237a5b6e6 |

## Commands Used

### Enable Inventory Collection
```powershell
# Create association to collect inventory every 30 mins
# association = scheduled task linking document to instance
aws ssm create-association `
  --name "AWS-GatherSoftwareInventory" `
  --targets "Key=InstanceIds,Values=i-0263a2b3237a5b6e6" `
  --schedule-expression "rate(30 minutes)" `
  --parameters '{}' `
  --region us-east-2 `
  --query "AssociationDescription.AssociationId" `
  --output text
```

### Query Installed Applications
```powershell
# AWS:Application = all installed software packages
# Returns name and version of each package
aws ssm list-inventory-entries `
  --instance-id "i-0263a2b3237a5b6e6" `
  --type-name "AWS:Application" `
  --region us-east-2 `
  --query "Entries[*].[Name,Version]" `
  --output table
```

### Count Total Packages
```powershell
# length(Entries) = count all entries returned
# Returns single number = total packages
aws ssm list-inventory-entries `
  --instance-id "i-0263a2b3237a5b6e6" `
  --type-name "AWS:Application" `
  --region us-east-2 `
  --query "length(Entries)" `
  --output text
# Result: 50 packages
```

### Query OS Information
```powershell
# AWS:InstanceInformation = OS and SSM agent details
# Returns all fields about the instance
aws ssm list-inventory-entries `
  --instance-id "i-0263a2b3237a5b6e6" `
  --type-name "AWS:InstanceInformation" `
  --region us-east-2 `
  --query "Entries[*]" `
  --output table
# Result: Amazon Linux 2023, SSM agent 3.3.4515.0
```

### Query Network Interfaces
```powershell
# AWS:Network = all network interfaces
# Returns name, IP, MAC for each interface
aws ssm list-inventory-entries `
  --instance-id "i-0263a2b3237a5b6e6" `
  --type-name "AWS:Network" `
  --region us-east-2 `
  --query "Entries[*]" `
  --output table
# Result: enX0 (10.0.6.194) and docker0 (172.17.0.1)
```

## Inventory Types Available
| Type | Description | What It Shows |
|---|---|---|
| AWS:Application | Installed software | Package names and versions |
| AWS:InstanceInformation | OS details | OS, agent version, IP |
| AWS:Network | Network config | IPs, MACs, interfaces |
| AWS:Service | System services | Running/stopped services |
| AWS:WindowsUpdate | Windows patches | Windows only |

## Why Inventory Matters
SECURITY AUDIT:

"Do any servers have unauthorized software?"

→ Query AWS:Application across all servers

→ Find any unexpected packages instantly
COMPLIANCE:

"Are all servers running approved versions?"

→ Query AWS:Application for specific package

→ Get version from every server at once
INCIDENT RESPONSE:

"What changed on this server before it crashed?"

→ Compare inventory snapshots over time

→ See exactly what was installed/removed
VULNERABILITY MANAGEMENT:

"Which servers have this vulnerable package?"

→ Query AWS:Application for package name

→ Get list of affected servers instantly

→ Patch them all with Run Command
## Real World Example
```powershell
# Find all servers with a specific package
aws ssm list-inventory-entries `
  --instance-id "i-0263a2b3237a5b6e6" `
  --type-name "AWS:Application" `
  --region us-east-2 `
  --query "Entries[?Name=='docker'].[Name,Version]" `
  --output table
# Shows: docker 25.0.14
# If you had 100 servers you would see
# which ones have docker and which version!
```
