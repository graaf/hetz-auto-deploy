#!/bin/bash

set -e  # Якщо щось падає – зупиняємо виконання

# Оновлення системи
echo "📥 Updating system..."
apt update && apt upgrade -y

# Встановлення базових пакетів
echo "🛠️ Installing essential packages..."
apt install -y ca-certificates curl gnupg ffmpeg redis python3 python3-venv python3-distutils software-properties-common git

# ✅ Виправлення проблеми з pip3
echo "🐍 Installing pip3..."
if ! command -v pip3 &> /dev/null; then
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3
fi

# ✅ Додаємо офіційний Docker-репозиторій
echo "🐳 Setting up Docker repository..."
if ! command -v docker &> /dev/null; then
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable docker
    systemctl start docker
fi

# ✅ Перевірка Docker
docker --version || { echo "❌ Docker installation failed"; exit 1; }

# ✅ Встановлення та запуск Nginx
echo "🌍 Installing and starting Nginx..."
if ! command -v nginx &> /dev/null; then
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
fi
systemctl status nginx --no-pager || { echo "❌ Nginx installation failed"; exit 1; }

# ✅ Відкриття портів
echo "🔓 Configuring firewall..."
ufw allow 80/tcp || true
ufw allow 443/tcp || true
ufw allow 8000/tcp || true
ufw allow 8501/tcp || true
ufw reload || true

# ✅ Встановлення Python-залежностей
echo "🐍 Installing Python dependencies..."
pip3 install --upgrade pip
pip3 install fastapi uvicorn celery redis whisper ffmpeg-python moviepy pydub transformers googletrans torch torchaudio yt-dlp streamlit || { echo "❌ Python dependency installation failed"; exit 1; }

# ✅ Фінальне підтвердження
echo "✅ Installation complete!"
