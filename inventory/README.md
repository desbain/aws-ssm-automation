# SSM Inventory

Automatic software and configuration tracking
across EC2 fleet using AWS SSM Inventory.

## What We Collected

### Instance Information
- Agent: amazon-ssm-agent v3.3.4515.0
- OS: Amazon Linux 2023
- Instance: i-0263a2b3237a5b6e6
- Status: Active

### Network Interfaces
| Interface | IPv4 | MAC |
|---|---|---|
| enX0 | 10.0.6.194 | 02:40:cd:12:f0:f3 |
| docker0 | 172.17.0.1 | 02:42:91:f8:a1:e6 |

### Applications
- 50 packages tracked
- Schedule: every 30 minutes
- Association ID: 329bd303-c0c1-4ed6-9e86-0b1152f5fedc

## Commands

### Enable Inventory
```powershell
aws ssm create-association `
  --name "AWS-GatherSoftwareInventory" `
  --targets "Key=InstanceIds,Values=INSTANCE_ID" `
  --schedule-expression "rate(30 minutes)" `
  --parameters '{}' `
  --region us-east-2
```

### Query Applications
```powershell
aws ssm list-inventory-entries `
  --instance-id "INSTANCE_ID" `
  --type-name "AWS:Application" `
  --region us-east-2 `
  --query "Entries[*].[Name,Version]" `
  --output table
```

### Query Network
```powershell
aws ssm list-inventory-entries `
  --instance-id "INSTANCE_ID" `
  --type-name "AWS:Network" `
  --region us-east-2 `
  --query "Entries[*]" `
  --output table
```

### Query OS Info
```powershell
aws ssm list-inventory-entries `
  --instance-id "INSTANCE_ID" `
  --type-name "AWS:InstanceInformation" `
  --region us-east-2 `
  --query "Entries[*]" `
  --output table
```

## Inventory Types
| Type | Description |
|---|---|
| AWS:Application | Installed software packages |
| AWS:InstanceInformation | OS and SSM agent details |
| AWS:Network | Network interfaces and IPs |
| AWS:Service | Running system services |
