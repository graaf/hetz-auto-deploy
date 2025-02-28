#!/bin/bash

# Оновлення системи
echo "📥 Updating system..."
apt update && apt upgrade -y

# Встановлення необхідних пакетів
echo "🛠️ Installing dependencies..."
apt install -y ffmpeg redis docker docker-compose python3 python3-pip nginx git

# Встановлення Python-залежностей
echo "🐍 Installing Python dependencies..."
pip3 install fastapi uvicorn celery redis whisper ffmpeg-python moviepy pydub transformers googletrans torch torchaudio yt-dlp streamlit

# Налаштування Docker
echo "🐳 Setting up Docker..."
systemctl start docker
systemctl enable docker

# Встановлення та запуск Nginx
echo "🌍 Setting up Nginx..."
systemctl start nginx
systemctl enable nginx
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8000/tcp
ufw allow 8501/tcp
ufw reload

echo "✅ Installation complete!"
