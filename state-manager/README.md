# State Manager

Keeps EC2 instances in desired configuration
automatically using AWS SSM State Manager.

## What is Configuration Drift?
Server starts correctly configured

↓

Someone changes a setting

Service stops unexpectedly

Package gets removed

↓

Server DRIFTS from desired state

↓

State Manager DETECTS drift

↓

State Manager FIXES it automatically

## Associations We Created

| Association | Document | Schedule | Status |
|---|---|---|---|
| AWS-GatherSoftwareInventory | AWS-GatherSoftwareInventory | rate(30 minutes) | Success |
| EnsureDockerRunning | AWS-RunShellScript | rate(30 minutes) | Success |
| SecurityHardening | AWS-RunShellScript | rate(1 hour) | Success |
| AWS-UpdateSSMAgent | AWS-UpdateSSMAgent | rate(7 days) | Success |

## Association IDs

| Association | ID |
|---|---|
| SSM Agent Update | d5a7ecad-d4ea-4919-9ad7-4d3613e21a4a |
| Docker Running | 9040d17f-a54b-4f2c-963a-82b38f34e78a |
| Security Hardening | ab8af33e-5dd5-4dc5-aa47-6cc418d7cb9b |

## Compliance Results

| Type | Compliant | Non-Compliant |
|---|---|---|
| Association | 1 | 0 |
| Patch | 0 | 1 |

## Commands

### Create State Association
```powershell
aws ssm create-association `
  --name "AWS-RunShellScript" `
  --targets "Key=InstanceIds,Values=INSTANCE_ID" `
  --schedule-expression "rate(30 minutes)" `
  --parameters file://params.json `
  --association-name "MyAssociation" `
  --region us-east-2
```

### List All Associations
```powershell
aws ssm list-associations `
  --region us-east-2 `
  --query "Associations[*].[AssociationName,Name,Overview.Status,ScheduleExpression]" `
  --output table
```

### Check Compliance
```powershell
aws ssm list-compliance-summaries `
  --region us-east-2 `
  --output table
```

## What Each Association Does

### EnsureDockerRunning
```bash
systemctl enable docker  # Set Docker to start on boot
systemctl start docker   # Start Docker if not running
# Runs every 30 minutes
# If Docker stops → auto restarts!
```

### SecurityHardening
```bash
chmod 700 /root                    # Secure root directory
echo HISTSIZE=1000 >> /etc/profile # Keep command history
# Runs every hour
# Enforces security settings continuously
```

### AWS-UpdateSSMAgent
```bash
# Built-in AWS document
# Automatically updates SSM agent
# to latest version every 7 days
# Ensures SSM connectivity never breaks
```

## Real World Use Cases
HEALTHCARE DEVSECOPS:

─────────────────────────────────────────

"Patient data app must always be running"

→ EnsureDockerRunning association
"Servers must always be hardened"

→ SecurityHardening association
"Audit logs must always be enabled"

→ Custom association to check auditd
"Config files must never change"

→ Association to restore if changed
DOD ENVIRONMENT:

─────────────────────────────────────────

"STIG settings must always be applied"

→ STIG hardening association
"Unauthorized software must be removed"

→ Software compliance association
"Security patches within 30 days"

→ Patch Manager + State Manager
