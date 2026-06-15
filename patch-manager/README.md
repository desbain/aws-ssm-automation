# Patch Manager

Automated EC2 patching using AWS SSM Patch Manager.

## What We Built

- Custom patch baseline for Amazon Linux 2023
- Maintenance window every Sunday at 2AM UTC
- Auto patching of Critical and Important patches
- Compliance reporting

## Results
- 53 patches installed
- 0 missing patches
- 0 failed patches
- Fully compliant!

## Commands

### Create Patch Baseline
```powershell
aws ssm create-patch-baseline \
  --name "patient-server-patch-baseline" \
  --operating-system "AMAZON_LINUX_2023" \
  --approval-rules file://approval-rules.json \
  --region us-east-2
```

### Run Patch Scan
```powershell
aws ssm send-command \
  --instance-ids "INSTANCE_ID" \
  --document-name "AWS-RunPatchBaseline" \
  --parameters file://scan-params.json \
  --region us-east-2
```

### Check Compliance
```powershell
aws ssm describe-instance-patch-states \
  --instance-ids "INSTANCE_ID" \
  --region us-east-2
```

## Maintenance Window Schedule
- Schedule: Every Sunday at 2:00 AM UTC
- Duration: 2 hours
- Operation: Install
