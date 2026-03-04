FROM python:3.13-slim

# system deps: ffmpeg + supervisor
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# install python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy app
COPY . .

# create folders (safe)
RUN mkdir -p user_uploads static/reels

ENV PYTHONUNBUFFERED=1
ENV FLASK_ENV=production
# Railway injects PORT; default to 8000 for local use
ENV PORT=8000

EXPOSE 8000

COPY supervisord.conf /etc/supervisor/conf.d/app.conf

CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
