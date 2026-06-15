# Run Command

Run scripts across multiple EC2 instances
simultaneously without SSH.

## How it works

\`\`\`
Your terminal → SSM → Multiple EC2s simultaneously
                      No SSH needed!
                      Results returned to you
\`\`\`

## Run health check on all servers
\`\`\`bash
aws ssm send-command \
  --targets "Key=tag:Name,Values=patient-ssm-server" \
  --document-name "AWS-RunShellScript" \
  --parameters commands=["$(cat scripts/health-check.sh)"] \
  --region us-east-2
\`\`\`

## Check command output
\`\`\`bash
aws ssm get-command-invocation \
  --command-id "COMMAND_ID" \
  --instance-id "INSTANCE_ID" \
  --region us-east-2 \
  --query '[Status,StandardOutputContent]' \
  --output text
\`\`\`

## Real world use cases
- Patch all servers simultaneously
- Deploy config changes fleet-wide
- Run security audits across all EC2s
- Collect logs from multiple servers
- Install software on 100s of servers
