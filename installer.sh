#!/bin/bash

# Оновлення системи
echo "📥 Updating system..."
apt update && apt upgrade -y

# Встановлення необхідних пакетів
echo "🛠️ Installing dependencies..."
apt install -y ca-certificates curl gnupg ffmpeg redis python3 python3-pip nginx git

# Додаємо офіційний Docker-репозиторій
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Встановлення Docker
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker

# Перевірка Docker
docker --version

# Налаштування Nginx
echo "🌍 Setting up Nginx..."
systemctl enable nginx
systemctl start nginx

# Дозволяємо необхідні порти
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8000/tcp
ufw allow 8501/tcp
ufw reload

echo "✅ Installation complete!"
