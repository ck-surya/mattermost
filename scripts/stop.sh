#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Stopping Mattermost...${NC}"

# Check if docker-compose.nginx.yml exists and is being used
if [ -f docker-compose.nginx.yml ] && docker compose ps | grep -q "mattermost-nginx"; then
    echo -e "${BLUE}Stopping with Nginx configuration...${NC}"
    docker compose -f docker-compose.yml -f docker-compose.nginx.yml down
else
    docker compose down
fi

echo -e "${GREEN}✓ Mattermost stopped successfully!${NC}"

# Option to remove volumes
if [ "$1" == "--volumes" ] || [ "$1" == "-v" ]; then
    echo -e "${RED}Removing volumes...${NC}"
    docker compose down -v
    echo -e "${GREEN}✓ Volumes removed${NC}"
fi
