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
![Managed Instances](screenshots/session-manager-managed-instances.png)
![Active Session](screenshots/session-manager-active-session.png)

### ⚡ Run Command
![Command History](screenshots/run-command-history.png)
![Command Output](screenshots/run-command-output.png)

### 🔐 Parameter Store
![Parameters List](screenshots/parameter-store-list.png)
![Parameter Details](screenshots/parameter-store-details.png)

### 🩹 Patch Manager
![Patch Compliance](screenshots/patch-manager-compliance.png)
![Maintenance Window](screenshots/patch-manager-maintenance-window.png)
![Patch Baseline](screenshots/patch-manager-baseline.png)
![Patch Results](screenshots/patch-manager-results.png)
