# forwardProxy

Solving stuff, that's what i do

## Install docker

```bash
# install sht
sudo apt update
sudo apt upgrade -y
sudo apt install ca-certificates curl gnupg lsb-release -y

# 2. Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 3. Add the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# 4. Update apt again and install Docker + Compose plugin
sudo apt update
sudo apt upgrade
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# 5 Start and enable Docker
sudo systemctl enable --now docker
sudo systemctl status docker

# Add user to the docker group (so you don't need sudo every time): 
sudo usermod -aG docker $USER

# =====
# Set timezone
# 1. Check current timezone and NTP status
timedatectl

# 2. Confirm the exact timezone name exists
timedatectl list-timezones | grep -i managua
# (should return America/Managua)

# 3. Set it
sudo timedatectl set-timezone America/Managua

# 4. Verify
timedatectl
```

## Build it dud

```bash
# Stop old container
docker compose down

# Rebuild with new Dockerfile (forces fresh image)
docker compose build --no-cache

# Start
docker compose up -d

# Watch logs
docker logs -f squid-proxy

# after that you only need to do this. dah
docker compose up -d --build 
```

## Test it u wacko

```bash
curl -x http://192.168.0.181:3128 https://www.google.com
```

## Set up services like you know stuff

```bash
sudo vim /etc/systemd/system/squid-proxy.service

[Unit]
Description=Squid Proxy (Docker Compose)
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/squid-proxy
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target

sudo systemctl daemon-reload
sudo systemctl enable --now squid-proxy.service

```

## extra

```bash
# If closed
sudo ufw allow 3128 
# Firewall on Ubuntu
sudo ufw allow from 192.168.0.0/16 to any port 3128
# Monitor 
tail -f /opt/squid-proxy/squid_logs/access.log  #or check container logs.
# Update everything
cd /opt/squid-proxy && docker compose pull && docker compose up -d
#Backup: Just back up the entire 
/opt/squid-proxy folder # it’s fully portable
```

## THE END

now get out of here.