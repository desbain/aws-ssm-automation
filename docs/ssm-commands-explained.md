# SSM Commands Explained
Full documentation of every command used in this project with explanations.

---

## 1. Session Manager

### Check Instance is Online in SSM
```bash
aws ssm describe-instance-information \
  --region us-east-2 \
  --query 'InstanceInformationList[*].[InstanceId,PingStatus,PlatformName,IPAddress]' \
  --output table

# aws                    → AWS CLI tool
# ssm                    → Target Systems Manager service
# describe-instance-information → List all instances registered with SSM
#                          An instance appears here only if:
#                          1. SSM Agent is installed and running
#                          2. Instance has correct IAM role
#                          3. Instance can reach SSM endpoints
#
# --region us-east-2     → AWS region where instance lives
#
# --query '...'          → Filter JSON response to show only:
#   InstanceId           → EC2 instance ID (i-xxxxxxxxx)
#   PingStatus           → Online = SSM agent responding
#                          Offline = agent not responding
#   PlatformName         → OS name (Amazon Linux, Ubuntu etc)
#   IPAddress            → Private IP of the instance
#
# --output table         → Format response as readable table
#                          Other options: json, text, yaml
```

### Connect to Instance via Session Manager
```bash
aws ssm start-session \
  --target i-0263a2b3237a5b6e6 \
  --region us-east-2

# aws ssm start-session  → Opens interactive terminal session
#                          to EC2 instance through SSM
#                          NO SSH needed
#                          NO port 22 needed
#                          NO .pem key needed
#                          Uses IAM for authentication
#                          Full session logged to CloudTrail
#
# --target i-0263a2b3237a5b6e6
#                        → Instance ID to connect to
#                          Must be registered in SSM
#                          Must have SSM agent running
#
# --region us-east-2     → AWS region of the instance
#
# WHAT HAPPENS:
# 1. AWS CLI sends request to SSM API
# 2. SSM authenticates your IAM identity
# 3. SSM tells SSM agent on EC2 to open session
# 4. Secure WebSocket tunnel established
# 5. You get interactive shell
# 6. All keystrokes logged to CloudTrail
# 7. Session recorded to S3 (if configured)
```

---

## 2. Run Command

### Send Command to EC2
```bash
aws ssm send-command \
  --instance-ids "i-0263a2b3237a5b6e6" \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["whoami","docker --version","df -h","free -m"]' \
  --region us-east-2 \
  --query 'Command.CommandId' \
  --output text

# aws ssm send-command   → Send a command to run on EC2
#                          WITHOUT opening a terminal session
#                          Fire and forget style
#                          Results stored in SSM
#
# --instance-ids "i-0263a2b3237a5b6e6"
#                        → Which EC2 instance to run on
#                          Can specify multiple:
#                          --instance-ids "i-111" "i-222"
#                          Or use tags to target many servers:
#                          --targets "Key=tag:Env,Values=prod"
#
# --document-name "AWS-RunShellScript"
#                        → Which SSM Document to run
#                          SSM Documents = pre-built scripts/playbooks
#                          AWS-RunShellScript = run any shell commands
#                          Other built-in documents:
#                          AWS-RunPatchBaseline = patch the server
#                          AWS-GatherSoftwareInventory = collect inventory
#                          AWS-UpdateSSMAgent = update SSM agent
#
# --parameters 'commands=[...]'
#                        → The actual commands to run
#                          Must be in JSON array format
#                          Each item = one command
#                          Commands run in order
#                          As root user
#
# --query 'Command.CommandId'
#                        → Extract only the CommandId
#                          from the JSON response
#                          CommandId = unique ID to track
#                          this specific command execution
#
# --output text          → Return as plain text not JSON
```

### Get Command Results
```bash
aws ssm get-command-invocation \
  --command-id "COMMAND_ID" \
  --instance-id "i-0263a2b3237a5b6e6" \
  --region us-east-2 \
  --query '[Status,StandardOutputContent]' \
  --output text

# aws ssm get-command-invocation
#                        → Retrieve results of a command
#                          that was previously sent
#
# --command-id "COMMAND_ID"
#                        → Which command to get results for
#                          Use the ID returned by send-command
#
# --instance-id "..."    → Which instance's results to get
#                          Required because same command
#                          can run on multiple instances
#
# --query '[Status,StandardOutputContent]'
#                        → Extract two fields:
#                          Status = InProgress/Success/Failed
#                          StandardOutputContent = actual output
#                          of the commands that ran
#
# STATUS VALUES:
# Pending    = command received, not started yet
# InProgress = command currently running
# Success    = all commands completed successfully
# Failed     = one or more commands failed
# TimedOut   = command took too long
# Cancelled  = command was cancelled
```

### Health Check Command
```bash
aws ssm send-command \
  --instance-ids "i-0263a2b3237a5b6e6" \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=[
    "echo === SYSTEM HEALTH CHECK ===",
    "echo Date: $(date)",
    "echo Hostname: $(hostname)",
    "echo Uptime: $(uptime)",
    "echo === DISK USAGE ===",
    "df -h",
    "echo === MEMORY ===",
    "free -m",
    "echo === DOCKER STATUS ===",
    "docker ps"
  ]' \
  --region us-east-2 \
  --query 'Command.CommandId' \
  --output text

# This command runs a full health check:
#
# echo === SYSTEM HEALTH CHECK ===
#                        → Print section header
#
# echo Date: $(date)     → Print current date/time
#                          $() = command substitution
#                          runs date command and inserts output
#
# echo Hostname: $(hostname)
#                        → Print server hostname
#                          Useful when running on many servers
#                          to know which output belongs to which
#
# echo Uptime: $(uptime) → How long server has been running
#                          Also shows load average
#
# df -h                  → Disk space usage
#                          -h = human readable (GB/MB not bytes)
#                          Shows all mounted filesystems
#
# free -m                → Memory usage in megabytes
#                          -m = megabytes
#                          Shows: total, used, free, cached
#
# docker ps              → List running Docker containers
#                          Empty = no containers running
```

---

## 3. Parameter Store

### Store a Secret Parameter
```powershell
aws ssm put-parameter `
  --name "/patient-system/db/password" `
  --value "secret123" `
  --type "SecureString" `
  --region us-east-2 `
  --overwrite

# aws ssm put-parameter  → Store a value in Parameter Store
#                          Parameters = key-value pairs
#                          stored securely in AWS
#
# --name "/patient-system/db/password"
#                        → Parameter name/path
#                          Use / to create hierarchy
#                          Like folders:
#                          /app-name/environment/secret-name
#                          /patient-system/db/password
#                          /patient-system/auth/jwt-secret
#                          Hierarchy lets you get ALL secrets
#                          for an app with one command
#
# --value "secret123"    → The actual secret value
#                          For SecureString this gets
#                          encrypted by KMS before storing
#                          Never stored in plain text!
#
# --type "SecureString"  → How to store the value
#                          String       = plain text
#                                         use for non-sensitive
#                                         config values
#                          SecureString = encrypted by KMS
#                                         use for passwords,
#                                         API keys, secrets
#                          StringList   = comma separated list
#                                         use for multiple values
#
# --region us-east-2     → AWS region to store in
#
# --overwrite            → Update if parameter already exists
#                          Without this flag update fails
#                          if parameter already exists
```

### Retrieve a Secret
```powershell
aws ssm get-parameter `
  --name "/patient-system/db/password" `
  --with-decryption `
  --region us-east-2 `
  --query "Parameter.Value" `
  --output text

# aws ssm get-parameter  → Retrieve a single parameter
#
# --name "/patient-system/db/password"
#                        → Which parameter to retrieve
#                          Must use exact full path
#
# --with-decryption      → CRITICAL for SecureString!
#                          Without this flag SecureString
#                          returns encrypted ciphertext
#                          With this flag SSM decrypts
#                          using KMS and returns plain value
#                          Only works if your IAM role has
#                          KMS decrypt permission
#
# --query "Parameter.Value"
#                        → Extract just the value
#                          Response has many fields:
#                          Name, Type, Value, Version etc
#                          We only want Value
#
# --output text          → Return as plain text
#                          Perfect for using in scripts:
#                          DB_PASS=$(aws ssm get-parameter...)
```

### Get All Parameters for an App
```powershell
aws ssm get-parameters-by-path `
  --path "/patient-system" `
  --recursive `
  --with-decryption `
  --region us-east-2 `
  --query "Parameters[*].[Name,Type,Value]" `
  --output table

# aws ssm get-parameters-by-path
#                        → Get ALL parameters under a path
#                          Like listing all files in a folder
#
# --path "/patient-system"
#                        → The parent path to search under
#                          Returns everything starting with
#                          /patient-system/...
#
# --recursive            → Search all sub-paths too
#                          Without this only gets direct children
#                          /patient-system/db/password ← found
#                          /patient-system/auth/jwt   ← found
#                          Both found because recursive
#
# --with-decryption      → Decrypt SecureString values
#                          Otherwise passwords show as
#                          encrypted ciphertext
#
# --query "Parameters[*].[Name,Type,Value]"
#                        → For ALL parameters [*] get:
#                          Name  = parameter path
#                          Type  = String/SecureString
#                          Value = the actual value
```

---

## 4. Patch Manager

### Create Patch Baseline
```powershell
aws ssm create-patch-baseline `
  --name "patient-server-patch-baseline" `
  --operating-system "AMAZON_LINUX_2023" `
  --approval-rules file://approval-rules.json `
  --description "Patch baseline for patient SSM server" `
  --region us-east-2 `
  --query "BaselineId" `
  --output text

# aws ssm create-patch-baseline
#                        → Create rules for which patches
#                          to install on your servers
#                          Like a policy that says:
#                          "Install Critical security patches
#                           7 days after AWS approves them"
#
# --name "patient-server-patch-baseline"
#                        → Name for this baseline
#                          You can have different baselines
#                          for different server types
#
# --operating-system "AMAZON_LINUX_2023"
#                        → Which OS this baseline applies to
#                          Other options:
#                          WINDOWS, UBUNTU, REDHAT_ENTERPRISE_LINUX
#                          CENTOS, DEBIAN, MACOS
#
# --approval-rules file://approval-rules.json
#                        → JSON file defining patch rules:
#                          {
#                            "PatchRules": [{
#                              "PatchFilterGroup": {
#                                "PatchFilters": [
#                                  {
#                                    "Key": "SEVERITY",
#                                    "Values": ["Critical","Important"]
#                                    # Only patch Critical + Important
#                                    # Skip Low and Medium severity
#                                  },
#                                  {
#                                    "Key": "CLASSIFICATION",
#                                    "Values": ["Security","Bugfix"]
#                                    # Only Security and Bugfix patches
#                                    # Skip feature updates
#                                  }
#                                ]
#                              },
#                              "ApproveAfterDays": 7
#                              # Wait 7 days after AWS tests patch
#                              # before installing on your servers
#                              # Gives time to catch bad patches
#                            }]
#                          }
#
# --query "BaselineId"   → Return just the baseline ID
#                          Format: pb-xxxxxxxxxxxxxxxxx
```

### Create Maintenance Window
```powershell
aws ssm create-maintenance-window `
  --name "patient-server-maintenance" `
  --schedule "cron(0 2 ? * SUN *)" `
  --duration 2 `
  --cutoff 1 `
  --allow-unassociated-targets `
  --region us-east-2 `
  --query "WindowId" `
  --output text

# aws ssm create-maintenance-window
#                        → Schedule when patching happens
#                          Like booking a time slot for
#                          maintenance on your servers
#
# --name "patient-server-maintenance"
#                        → Name for this maintenance window
#
# --schedule "cron(0 2 ? * SUN *)"
#                        → When maintenance window opens
#                          Using cron expression:
#                          0    = minute 0
#                          2    = hour 2 (2AM)
#                          ?    = any day of month
#                          *    = every month
#                          SUN  = Sunday only
#                          *    = any year
#                          = Every Sunday at 2:00 AM UTC
#
# --duration 2           → How long window stays open
#                          2 = 2 hours
#                          Patching must complete within
#                          this time window
#
# --cutoff 1             → Stop starting NEW tasks
#                          1 hour before window closes
#                          Prevents tasks from starting
#                          that won't finish in time
#
# --allow-unassociated-targets
#                        → Allow targeting instances
#                          that aren't in a patch group
#                          Without this flag instances
#                          must be in a patch group first
```

### Register Instance as Patch Target
```powershell
aws ssm register-target-with-maintenance-window `
  --window-id "$WINDOW_ID" `
  --resource-type "INSTANCE" `
  --targets "Key=InstanceIds,Values=i-0263a2b3237a5b6e6" `
  --region us-east-2 `
  --query "WindowTargetId" `
  --output text

# aws ssm register-target-with-maintenance-window
#                        → Tell the maintenance window
#                          WHICH servers to patch
#                          Like adding servers to
#                          a maintenance schedule
#
# --window-id "$WINDOW_ID"
#                        → Which maintenance window
#                          Uses the ID we created above
#
# --resource-type "INSTANCE"
#                        → Type of resource to target
#                          INSTANCE = EC2 instances
#
# --targets "Key=InstanceIds,Values=i-0263..."
#                        → Which specific instances
#                          Key=InstanceIds = target by ID
#                          Can also use tags:
#                          Key=tag:Env,Values=production
#                          = patch ALL production servers!
```

### Run Patch Scan
```powershell
aws ssm send-command `
  --instance-ids "i-0263a2b3237a5b6e6" `
  --document-name "AWS-RunPatchBaseline" `
  --parameters file://scan-params.json `
  --region us-east-2 `
  --query "Command.CommandId" `
  --output text

# scan-params.json contains:
# {"Operation":["Scan"]}
#
# aws ssm send-command   → Run a command on the instance
#
# --document-name "AWS-RunPatchBaseline"
#                        → Built-in AWS document for patching
#                          Knows how to check and install
#                          patches on any supported OS
#
# --parameters file://scan-params.json
#                        → Pass parameters from a file
#                          file:// = read from local file
#                          scan-params.json contains:
#                          {"Operation":["Scan"]}
#                          Operation options:
#                          Scan    = check for missing patches
#                                    DO NOT install anything
#                                    Just report what's missing
#                          Install = actually install patches
#                                    This patches the server!
```

### Check Patch Compliance
```powershell
aws ssm describe-instance-patch-states `
  --instance-ids "i-0263a2b3237a5b6e6" `
  --region us-east-2 `
  --query "InstancePatchStates[*].[InstanceId,PatchGroup,InstalledCount,MissingCount,FailedCount,ComplianceStatus]" `
  --output table

# aws ssm describe-instance-patch-states
#                        → Get patch compliance report
#                          for specific instances
#                          Shows exactly how many patches
#                          are installed, missing, failed
#
# --query "InstancePatchStates[*].[...]"
#                        → Extract specific fields:
#
#   InstanceId           → Which EC2 instance
#
#   PatchGroup           → Group name if instance is in
#                          a patch group (empty if not)
#
#   InstalledCount       → Number of patches installed
#                          Our result: 53 patches ✅
#
#   MissingCount         → Patches that SHOULD be installed
#                          but aren't yet
#                          Our result: 0 ✅ (fully patched!)
#
#   FailedCount          → Patches that tried to install
#                          but failed
#                          Our result: 0 ✅
#
#   ComplianceStatus     → Overall compliance:
#                          COMPLIANT = all required patches installed
#                          NON_COMPLIANT = missing patches
#                          Our result: None (fully compliant)
```

---

## Summary — Why Each Command Matters
COMMAND                          PURPOSE

─────────────────────────────────────────────────────────

describe-instance-information  → Is my server in SSM?

start-session                  → Connect without SSH

send-command                   → Run scripts remotely

get-command-invocation         → Get command results

put-parameter                  → Store secrets securely

get-parameter                  → Retrieve secrets

get-parameters-by-path         → Get all app secrets

create-patch-baseline          → Define patch rules

create-maintenance-window      → Schedule patch time

register-target                → Add server to schedule

send-command (RunPatchBaseline)→ Scan for missing patches

describe-instance-patch-states → Check patch compliance

## Real World Usage Pattern

```bash
# 1. Deploy new server
# 2. Check it registered in SSM
aws ssm describe-instance-information

# 3. Run initial health check
aws ssm send-command --document-name "AWS-RunShellScript"

# 4. Pull secrets from Parameter Store (not hardcoded!)
DB_PASS=$(aws ssm get-parameter --name "/app/db/pass" --with-decryption)

# 5. Verify patch compliance
aws ssm describe-instance-patch-states

# 6. Connect for debugging if needed (no SSH!)
aws ssm start-session --target INSTANCE_ID
```
