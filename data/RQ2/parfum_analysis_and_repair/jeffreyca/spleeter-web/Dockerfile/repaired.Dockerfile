FROM python:3.7-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /webapp/media /webapp/staticfiles
WORKDIR /webapp

COPY requirements.txt /webapp/

# Install all dependencies
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg libasound2-dev libsndfile-dev && pip install --no-cache-dir --upgrade pip -r requirements.txt && rm -rf /var/lib/apt/lists/*;

COPY . .

# Copy over entrypoint script
COPY api-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/api-entrypoint.sh && ln -s /usr/local/bin/api-entrypoint.sh /
ENTRYPOINT ["api-entrypoint.sh"]
