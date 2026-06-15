#!/bin/bash
# Health Check Script via SSM Run Command
# Runs on target EC2 instances remotely

echo "=== SYSTEM HEALTH CHECK ==="
echo "Date:     $(date)"
echo "Hostname: $(hostname)"
echo "Uptime:   $(uptime)"

echo ""
echo "=== DISK USAGE ==="
df -h

echo ""
echo "=== MEMORY ==="
free -m

echo ""
echo "=== DOCKER STATUS ==="
docker ps

echo ""
echo "=== CPU & TOP PROCESSES ==="
ps aux --sort=-%cpu | head -5

echo ""
echo "=== NETWORK ==="
ss -tlnp

echo ""
echo "=== SSM AGENT STATUS ==="
systemctl status amazon-ssm-agent --no-pager

echo "=== HEALTH CHECK COMPLETE ==="
