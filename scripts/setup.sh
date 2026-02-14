#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up Mattermost Docker environment...${NC}"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        echo -e "${BLUE}Creating .env file from .env.example...${NC}"
        cp .env.example .env
        echo -e "${GREEN}✓ .env file created${NC}"
        echo -e "${YELLOW}⚠ IMPORTANT: For production deployments, edit .env and change:${NC}"
        echo -e "  - DOMAIN (set to your domain name)"
        echo -e "  - POSTGRES_PASSWORD (use a strong password)"
        echo -e "  - Review all other settings"
        echo ""
    else
        echo -e "${RED}Error: .env.example not found!${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ .env file already exists${NC}"
fi

# Create volume directories if they don't exist
echo -e "${BLUE}Creating volume directories...${NC}"
mkdir -p volumes/app/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes}
mkdir -p volumes/db/var/lib/postgresql/data

# Set correct permissions for Mattermost volumes
# Mattermost runs as UID 2000 by default
echo -e "${BLUE}Setting permissions for Mattermost volumes...${NC}"
echo -e "${YELLOW}This requires sudo access to change ownership to UID 2000${NC}"
sudo chown -R 2000:2000 volumes/app

# Set correct permissions for PostgreSQL volumes
# PostgreSQL runs as UID 999 in the official image
echo -e "${BLUE}Setting permissions for PostgreSQL volumes...${NC}"
sudo chown -R 999:999 volumes/db

echo -e "${GREEN}✓ Setup complete!${NC}"
echo ""

# Check if this is a production environment
if grep -q "POSTGRES_PASSWORD=mmuser_password" .env 2>/dev/null; then
    echo -e "${YELLOW}⚠ DEVELOPMENT MODE DETECTED${NC}"
    echo -e "Current configuration is suitable for development only."
    echo -e "Before deploying to production:"
    echo -e "  1. Edit .env file"
    echo -e "  2. Change DOMAIN to your domain name"
    echo -e "  3. Set a strong POSTGRES_PASSWORD"
    echo -e "  4. Review all security settings"
    echo ""
fi

echo "You can now start Mattermost with:"
echo "  ./scripts/start.sh"
