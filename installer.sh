#!/bin/bash

# Оновлення системи
echo "📥 Updating system..."
apt update && apt upgrade -y

# Встановлення необхідних пакетів
echo "🛠️ Installing base dependencies..."
apt install -y ca-certificates curl gnupg ffmpeg redis python3 python3-venv nginx git

# ✅ Виправлення проблеми з pip3
echo "🐍 Installing pip3..."
apt install -y python3-pip || curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# ✅ Додаємо офіційний Docker-репозиторій
echo "🐳 Setting up Docker repository..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# ✅ Встановлення Docker
echo "🐳 Installing Docker..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker
docker --version

# ✅ Встановлення та запуск Nginx
echo "🌍 Setting up Nginx..."
apt install -y nginx
systemctl enable nginx
systemctl start nginx
systemctl status nginx --no-pager

# ✅ Відкриття портів
echo "🔓 Configuring firewall..."
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8000/tcp
ufw allow 8501/tcp
ufw reload

# ✅ Встановлення Python-залежностей
echo "🐍 Installing Python dependencies..."
pip3 install fastapi uvicorn celery redis whisper ffmpeg-python moviepy pydub transformers googletrans torch torchaudio yt-dlp streamlit

echo "✅ Installation complete!"
