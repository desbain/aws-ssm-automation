# 🖥️ AWS Systems Manager Automation Projects

A collection of AWS Systems Manager (SSM) automation projects
demonstrating DevSecOps practices for managing and automating
AWS infrastructure without SSH access.

## 🎯 Projects

| Project | Description | Status |
|---|---|---|
| Session Manager | SSH-free terminal access to EC2 | 🔨 In Progress |
| Run Command | Run scripts across multiple servers | ⬜ Planned |
| Parameter Store | Secure secrets management | ⬜ Planned |
| Patch Manager | Automated EC2 patching | ⬜ Planned |
| Automation Runbooks | Incident response automation | ⬜ Planned |
| State Manager | Configuration compliance | ⬜ Planned |
| Inventory | Software tracking across fleet | ⬜ Planned |

## 🏗️ Architecture

\`\`\`
┌─────────────────────────────────────────────────┐
│                  AWS Account                    │
│                                                 │
│  ┌─────────────┐      ┌─────────────────────┐  │
│  │    Your     │      │   Systems Manager   │  │
│  │   Browser   │─────▶│                     │  │
│  │  (Console)  │      │  - Session Manager  │  │
│  └─────────────┘      │  - Run Command      │  │
│                        │  - Parameter Store  │  │
│  ┌─────────────┐      │  - Patch Manager    │  │
│  │  VS Code    │      │  - Automation       │  │
│  │  Terminal   │─────▶│  - State Manager    │  │
│  │  (AWS CLI)  │      │  - Inventory        │  │
│  └─────────────┘      └──────────┬──────────┘  │
│                                   │              │
│                                   ▼              │
│                        ┌─────────────────────┐  │
│                        │      EC2 Fleet      │  │
│                        │                     │  │
│                        │  patient-ssm-server │  │
│                        │  (No SSH needed!)   │  │
│                        │  SSM Agent running  │  │
│                        └─────────────────────┘  │
└─────────────────────────────────────────────────┘
\`\`\`

## 🔐 Security Benefits

\`\`\`
TRADITIONAL SSH:                SSM:
────────────────────────────────────────────
Port 22 open            No ports needed
.pem keys to manage     IAM controls access
No audit trail          Full CloudTrail logs
Manual access           Automated access
Hard to scale           Scale to 1000s
Not DoD compliant       DoD/NIST compliant ✅
\`\`\`

## 📋 Prerequisites

- AWS Account with IAM user (gewa)
- AWS CLI configured
- EC2 instance with SSM Agent
- IAM role: AmazonSSMManagedInstanceCore

## 🚀 Quick Start

\`\`\`bash
# Connect to EC2 via Session Manager (no SSH!)
aws ssm start-session \
  --target INSTANCE_ID \
  --region us-east-2
\`\`\`

## 📁 Project Structure

\`\`\`
aws-ssm-automation/
├── session-manager/        ← SSH-free access
├── run-command/            ← Remote script execution
│   └── scripts/            ← Shell scripts to run
├── parameter-store/        ← Secrets management
├── patch-manager/          ← Auto patching
├── automation-runbooks/    ← Incident automation
├── state-manager/          ← Config compliance
├── inventory/              ← Software tracking
├── docs/                   ← Documentation
└── screenshots/            ← Project screenshots
\`\`\`

## 💼 Real World Use Cases

\`\`\`
Healthcare DevSecOps:
────────────────────────────────────────────
✅ HIPAA compliant access (no exposed ports)
✅ Full audit trail of all server access
✅ Automated patch compliance reporting
✅ Secrets management (DB passwords, API keys)
✅ Fleet-wide configuration management
✅ Automated incident response

DoD/Government:
────────────────────────────────────────────
✅ NIST 800-53 compliant
✅ Zero trust architecture
✅ No bastion hosts needed
✅ Centralized access control
✅ Complete audit logging
✅ STIG compliance automation
\`\`\`

## 🔗 Related Projects

- [Patient Management System](https://github.com/desbain/patient-management-system)
  - Docker + Kubernetes + Helm + ArgoCD

## 👨‍💻 Author

**George Awa**
DevSecOps Engineer
- GitHub: https://github.com/desbain
- Website: https://desbain.com


## 📸 Screenshots

### 🖥️ Session Manager
![Managed Instance](screenshots/managed%20instance.png)
![Session History](screenshots/Session%20history.png)

### ⚡ Run Command
![Command History](screenshots/command%20history.png)

### 🔐 Parameter Store
![Parameters List](screenshots/parameters-list.png)

### 🩹 Patch Manager
![Patch Baselines](screenshots/Patch-baselines.png)
![Patch Baselines Detail](screenshots/Patch-baselines1.png)
![Patches](screenshots/Patches.png)
![Patch Compliance](screenshots/patch-manager-compliance.png)
![Patch Compliance Detail](screenshots/patch-manager-compliance1.png)
![Patch Compliance Results](screenshots/patch-manager-compliance2.png)

## 📊 Project Results

### ✅ Project 1 — Session Manager
Connected to EC2 without SSH:

Instance ID:  i-0263a2b3237a5b6e6

Hostname:     ip-10-0-6-194.us-east-2.compute.internal

User:         ssm-user

Port 22:      CLOSED (not needed!)

Key pair:     NONE (not needed!)
### ✅ Project 2 — Run Command
### ✅ Project 2 — Run Command
Health Check Results:

Date:     Mon Jun 15 04:34:15 UTC 2026

Hostname: ip-10-0-6-194.us-east-2.compute.internal

Uptime:   1 hour 50 minutes

Disk:     8GB total, 25% used, 6.1GB free

Memory:   961MB total, 218MB used

Docker:   v25.0.14 installed

Status:   Success

### ✅ Project 3 — Parameter Store
Secrets Stored:

/patient-system/db/password      SecureString (encrypted)

/patient-system/db/username      String

/patient-system/db/name          String

/patient-system/auth/jwt-secret  SecureString (encrypted)

/patient-system/pgadmin/email    String

/patient-system/pgadmin/password SecureString (encrypted)

Total: 6 parameters stored securely

### ✅ Project 4 — Patch Manager
Patch Baseline:  patient-server-patch-baseline

OS:              Amazon Linux 2023

Schedule:        Every Sunday 2AM UTC

Installed:       53 patches

Missing:         0 patches

Failed:          0 patches

Status:          COMPLIANT

### ✅ Project 5 — Inventory
Instance Information:

OS:          Amazon Linux 2023

IP:          10.0.6.194

SSM Agent:   v3.3.4515.0

Status:      Active
Network Interfaces:

enX0    → 10.0.6.194  (main interface)

docker0 → 172.17.0.1  (docker bridge)
Applications:

Total packages tracked: 50

Collection schedule: every 30 minutes

## 🔐 Security Architecture
TRADITIONAL (INSECURE):          SSM (SECURE):

─────────────────────────────────────────────────

Port 22 open              →      No ports open

.pem keys to manage       →      IAM authentication

No audit trail            →      Full CloudTrail logs

Manual patching           →      Automated patching

Hardcoded passwords       →      Parameter Store

Manual inventory          →      Auto inventory

No config compliance      →      State Manager

## 📋 Commands Quick Reference

### Session Manager
```bash
# Connect to instance without SSH
aws ssm start-session --target INSTANCE_ID --region us-east-2

# List all SSM managed instances
aws ssm describe-instance-information --region us-east-2 --output table
```

### Run Command
```bash
# Run health check
aws ssm send-command \
  --instance-ids "INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters file://params.json \
  --region us-east-2

# Get results
aws ssm get-command-invocation \
  --command-id "COMMAND_ID" \
  --instance-id "INSTANCE_ID" \
  --region us-east-2 \
  --query "[Status,StandardOutputContent]" \
  --output text
```

### Parameter Store
```bash
# Store secret
aws ssm put-parameter \
  --name "/app/secret" \
  --value "mypassword" \
  --type "SecureString" \
  --region us-east-2

# Retrieve secret
aws ssm get-parameter \
  --name "/app/secret" \
  --with-decryption \
  --region us-east-2 \
  --query "Parameter.Value" \
  --output text
```

### Patch Manager
```bash
# Check patch compliance
aws ssm describe-instance-patch-states \
  --instance-ids "INSTANCE_ID" \
  --region us-east-2 \
  --output table
```

### Inventory
```bash
# Get installed packages
aws ssm list-inventory-entries \
  --instance-id "INSTANCE_ID" \
  --type-name "AWS:Application" \
  --region us-east-2 \
  --output table

# Count packages
aws ssm list-inventory-entries \
  --instance-id "INSTANCE_ID" \
  --type-name "AWS:Application" \
  --region us-east-2 \
  --query "length(Entries)" \
  --output text
```
