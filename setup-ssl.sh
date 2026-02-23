#!/bin/bash

# SSL Setup Script for Student Management System
# This script uses acme.sh to obtain and configure SSL certificates

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Student Management System - SSL Setup ===${NC}\n"

# Check if domain is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Domain name is required${NC}"
    echo "Usage: ./setup-ssl.sh your-domain.com your-email@example.com"
    echo "Example: ./setup-ssl.sh student.example.com admin@example.com"
    exit 1
fi

DOMAIN=$1
EMAIL=${2:-""}
SSL_DIR="./nginx/ssl"

echo -e "${YELLOW}Domain:${NC} $DOMAIN"
echo -e "${YELLOW}Email:${NC} ${EMAIL:-'Not provided'}"
echo ""

# Pre-flight checks
echo -e "${YELLOW}==> Running pre-flight checks...${NC}"

# Check if docker-compose is running
if ! docker ps | grep -q "student-management-nginx"; then
    echo -e "${RED}Error: Nginx container is not running${NC}"
    echo "Please start the services first: docker-compose up -d"
    exit 1
fi

# Check if domain resolves to this server
echo -e "${YELLOW}==> Checking DNS configuration...${NC}"
SERVER_IP=$(curl -s ifconfig.me || echo "Unable to detect")
DOMAIN_IP=$(dig +short $DOMAIN | tail -n1 || echo "Unable to resolve")

echo "Server IP: $SERVER_IP"
echo "Domain IP: $DOMAIN_IP"

if [ "$SERVER_IP" != "$DOMAIN_IP" ]; then
    echo -e "${YELLOW}Warning: Domain IP does not match server IP${NC}"
    echo "Make sure your domain's A record points to $SERVER_IP"
    read -p "Continue anyway? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        exit 1
    fi
fi

# Issue the certificate
echo -e "${GREEN}==> Issuing SSL certificate for $DOMAIN...${NC}"

ACME_CMD="--issue -d $DOMAIN -d www.$DOMAIN -w /var/www/acme --server letsencrypt"

if [ -n "$EMAIL" ]; then
    ACME_CMD="$ACME_CMD --accountemail $EMAIL"
fi

# Run acme.sh in the container
docker-compose exec acme acme.sh $ACME_CMD || {
    echo -e "${RED}Failed to issue certificate${NC}"
    echo "This might be because:"
    echo "1. The domain is not pointing to this server"
    echo "2. Ports 80/443 are not accessible"
    echo "3. You've hit Let's Encrypt rate limits"
    exit 1
}

# Install the certificate
echo -e "${GREEN}==> Installing certificate...${NC}"

docker-compose exec acme acme.sh --install-cert -d $DOMAIN \
    --key-file /acme.sh/key.pem \
    --fullchain-file /acme.sh/fullchain.pem \
    --reloadcmd "echo 'Certificate installed successfully'"

# Update Nginx configuration
echo -e "${GREEN}==> Updating Nginx configuration...${NC}"

# Backup original config
cp nginx/conf.d/app.conf nginx/conf.d/app.conf.bak

# Uncomment HTTPS server block
sed -i.tmp 's/^# server {/server {/g' nginx/conf.d/app.conf
sed -i.tmp 's/^#     /    /g' nginx/conf.d/app.conf
sed -i.tmp 's/^# }/}/g' nginx/conf.d/app.conf

# Comment out HTTP proxy location and enable HTTPS redirect
sed -i.tmp '/# Proxy to app (for testing without SSL)/,/^    }$/s/^/# /' nginx/conf.d/app.conf
sed -i.tmp 's/^    # Redirect to HTTPS/    Redirect to HTTPS/' nginx/conf.d/app.conf
sed -i.tmp 's/#     return 301/    return 301/' nginx/conf.d/app.conf
sed -i.tmp 's/#     }/    }/' nginx/conf.d/app.conf

# Clean up temp files
rm -f nginx/conf.d/app.conf.tmp

# Reload Nginx
echo -e "${GREEN}==> Reloading Nginx...${NC}"
docker-compose exec nginx nginx -t && docker-compose exec nginx nginx -s reload

echo -e "${GREEN}==> SSL Certificate Setup Complete!${NC}\n"
echo -e "${GREEN}Your site is now accessible at:${NC}"
echo -e "  ${GREEN}https://$DOMAIN${NC}"
echo -e "  ${GREEN}https://www.$DOMAIN${NC}\n"
echo -e "${YELLOW}Note: Certificates will auto-renew via the acme container${NC}"
