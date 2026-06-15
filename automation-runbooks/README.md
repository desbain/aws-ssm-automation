# Automation Runbooks

Custom SSM Documents that automate complex
multi-step operational tasks on EC2 instances.

## Runbooks Created

| Runbook | Document Name | Purpose |
|---|---|---|
| Health Check | PatientSystem-HealthCheck | Full system diagnostic |
| Docker Cleanup | PatientSystem-DockerCleanup | Free up disk space |
| Security Audit | PatientSystem-SecurityAudit | Security compliance check |

## Health Check Results
Date:     Mon Jun 15 13:04:55 UTC 2026

Hostname: ip-10-0-6-194.us-east-2.compute.internal

Disk:     8GB total 25% used 6.0GB free

Memory:   961MB total 189MB used 278MB free

Uptime:   10 hours 21 minutes

Docker:   Running

Ports:    22 (SSH) containerd

Status:   Success

## Docker Cleanup Results
Started:    Mon Jun 15 13:06:14 UTC 2026

Containers: 0B reclaimed

Images:     0B reclaimed

Volumes:    0B reclaimed

Networks:   cleaned

Disk:       25% before = 25% after

Status:     Success - already clean!

## Security Audit Results
Open Ports:

Port 22    → sshd (SSH)

Port 37827 → containerd (internal)
Running Services: 20 total including:

amazon-ssm-agent  ← SSM working

auditd            ← Security audit logging

docker            ← Docker running

sshd              ← SSH daemon
User Accounts:

root     → system admin

ec2-user → AWS default user

ssm-user → SSM session user
File Permissions:

/root/ → drwx------ (700) SECURED
Security Findings:

SELinux:        Permissive (recommend Enforcing)

Security tools: None found (recommend auditd/aide)

## How to Run Runbooks

### Health Check
```powershell
aws ssm send-command `
  --instance-ids "INSTANCE_ID" `
  --document-name "PatientSystem-HealthCheck" `
  --region us-east-2 `
  --query "Command.CommandId" `
  --output text
```

### Docker Cleanup
```powershell
aws ssm send-command `
  --instance-ids "INSTANCE_ID" `
  --document-name "PatientSystem-DockerCleanup" `
  --region us-east-2 `
  --query "Command.CommandId" `
  --output text
```

### Security Audit
```powershell
aws ssm send-command `
  --instance-ids "INSTANCE_ID" `
  --document-name "PatientSystem-SecurityAudit" `
  --region us-east-2 `
  --query "Command.CommandId" `
  --output text
```

### Get Results
```powershell
aws ssm get-command-invocation `
  --command-id "COMMAND_ID" `
  --instance-id "INSTANCE_ID" `
  --region us-east-2 `
  --query "StandardOutputContent" `
  --output text | Out-File -FilePath output.txt -Encoding utf8

Get-Content output.txt
```

## List All Custom Runbooks
```powershell
aws ssm list-documents `
  --filters "Key=Owner,Values=Self" `
  --region us-east-2 `
  --query "DocumentIdentifiers[*].[Name,DocumentType]" `
  --output table
```

## Real World Use Cases
SCHEDULED HEALTH CHECKS:

Run health check every morning at 6AM

Alert if disk > 80% or memory > 90%

Auto-generate daily health report
DOCKER MAINTENANCE:

Run cleanup every Sunday night

Before patching window starts

Ensures maximum disk space available
SECURITY COMPLIANCE:

Run security audit weekly

Compare against baseline

Alert on new findings

Generate compliance report for auditors
DOD/HEALTHCARE:

Run before and after any changes

Prove system state at any point in time

Full audit trail in CloudTrail

HIPAA and NIST 800-53 compliant

## Security Recommendations From Audit
FINDING 1: SELinux in Permissive mode

RISK:      Medium

FIX:       Set to Enforcing mode

COMMAND:   setenforce 1
FINDING 2: No security tools installed

RISK:      Medium

FIX:       Install auditd and aide

COMMAND:   yum install -y aide auditd
FINDING 3: Port 22 (SSH) open

RISK:      Low (using SSM instead)

FIX:       Close port 22 security group

Use Session Manager only
