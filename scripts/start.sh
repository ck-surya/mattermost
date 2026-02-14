#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Mattermost...${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    echo "Please create a .env file based on the provided template."
    exit 1
fi

# Check if docker-compose.nginx.yml should be used
if [ "$1" == "--with-nginx" ] || [ "$1" == "-n" ]; then
    echo -e "${BLUE}Starting with Nginx reverse proxy...${NC}"
    docker compose -f docker-compose.yml -f docker-compose.nginx.yml up -d
else
    echo -e "${BLUE}Starting without Nginx...${NC}"
    docker compose up -d
fi

# Wait for services to be ready
echo -e "${BLUE}Waiting for services to be ready...${NC}"
sleep 5

# Check if containers are running
if docker compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Mattermost started successfully!${NC}"
    echo ""
    echo "Access Mattermost at:"
    if [ "$1" == "--with-nginx" ] || [ "$1" == "-n" ]; then
        echo -e "  ${GREEN}https://localhost${NC}"
    else
        echo -e "  ${GREEN}http://localhost:80${NC}"
    fi
    echo ""
    echo "To view logs, run: docker compose logs -f"
    echo "To stop Mattermost, run: ./scripts/stop.sh"
else
    echo -e "${RED}✗ Failed to start Mattermost${NC}"
    echo "Check logs with: docker compose logs"
    exit 1
fi
