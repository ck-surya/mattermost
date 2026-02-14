# Mattermost Docker Setup

Complete Docker Compose setup for running Mattermost with PostgreSQL database.

## Quick Start

1. **Initial Setup:**
   ```bash
   chmod +x scripts/*.sh
   ./scripts/setup.sh
   ```
   This will create your `.env` file from `.env.example` with development defaults.

2. **For Production (Important!):**
   Edit the `.env` file and update:
   - `DOMAIN` - Set to your domain name
   - `POSTGRES_PASSWORD` - Use a strong password
   - Review all other settings

3. **Start Mattermost (without Nginx):**
   ```bash
   ./scripts/start.sh
   ```

4. **Access Mattermost:**
   - Open your browser and navigate to `http://localhost:80`
   - Create your first admin account

5. **Stop Mattermost:**
   ```bash
   ./scripts/stop.sh
   ```

## Advanced Usage

### Start with Nginx Reverse Proxy

For production deployments with HTTPS:

```bash
./scripts/start.sh --with-nginx
```

**Note:** You'll need to place your SSL certificates in `nginx/certs/`:
- `cert.pem` - SSL certificate
- `key.pem` - SSL private key

For development, you can generate self-signed certificates:
```bash
mkdir -p nginx/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/certs/key.pem \
  -out nginx/certs/cert.pem \
  -subj "/CN=localhost"
```

### Manual Docker Compose Commands

Start services:
```bash
docker compose up -d
```

Start with Nginx:
```bash
docker compose -f docker-compose.yml -f docker-compose.nginx.yml up -d
```

View logs:
```bash
docker compose logs -f
docker compose logs -f mattermost
```

Stop services:
```bash
docker compose down
```

Stop and remove volumes:
```bash
./scripts/stop.sh --volumes
```

## Configuration

Edit the `.env` file to customize your installation:

- `DOMAIN` - Your domain name
- `POSTGRES_USER` - PostgreSQL username
- `POSTGRES_PASSWORD` - PostgreSQL password
- `POSTGRES_DB` - PostgreSQL database name
- `HTTP_PORT` - HTTP port (default: 80)
- `HTTPS_PORT` - HTTPS port (default: 443)
- `MATTERMOST_IMAGE_TAG` - Mattermost version (default: latest)

## Directory Structure

```
mattermost-docker/
├── .env                          # Environment variables
├── docker-compose.yml            # Main compose file
├── docker-compose.override.yml   # Development overrides
├── docker-compose.nginx.yml      # Nginx configuration
├── nginx/
│   ├── conf.d/
│   │   └── mattermost.conf      # Nginx server config
│   └── certs/                   # SSL certificates
├── volumes/                      # Persistent data
│   ├── app/                     # Mattermost data
│   └── db/                      # PostgreSQL data
└── scripts/
    ├── start.sh                 # Start script
    └── stop.sh                  # Stop script
```

## Troubleshooting

### Check service status
```bash
docker compose ps
```

### View logs
```bash
docker compose logs -f mattermost
docker compose logs -f postgres
```

### Restart services
```bash
docker compose restart
```

### Reset everything
```bash
docker compose down -v
sudo rm -rf volumes/
./scripts/start.sh
```

## Backup

To backup your Mattermost data:

```bash
# Backup database
docker compose exec postgres pg_dump -U mmuser mattermost > backup.sql

# Backup data directory
tar -czf mattermost-data-backup.tar.gz volumes/app/mattermost/data
```

## Restore

To restore from backup:

```bash
# Restore database
cat backup.sql | docker compose exec -T postgres psql -U mmuser -d mattermost

# Restore data directory
tar -xzf mattermost-data-backup.tar.gz
```

## Upgrading

To upgrade Mattermost to a new version:

1. Edit `.env` and change `MATTERMOST_IMAGE_TAG` to the desired version
2. Pull the new image:
   ```bash
   docker compose pull
   ```
3. Restart services:
   ```bash
   docker compose up -d
   ```

## Support

For more information, visit:
- [Mattermost Documentation](https://docs.mattermost.com/)
- [Mattermost Docker Setup](https://github.com/mattermost/docker)
