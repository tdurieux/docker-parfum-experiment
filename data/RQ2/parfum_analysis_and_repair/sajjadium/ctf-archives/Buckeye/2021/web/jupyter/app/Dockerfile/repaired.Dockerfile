FROM python:3-slim
RUN pip install --no-cache-dir notebook fastapi uvicorn python-multipart requests
RUN apt-get update && apt-get -y --no-install-recommends install nginx xxd && rm -rf /var/lib/apt/lists/*;
RUN useradd -m ctf
WORKDIR /home/ctf
COPY . ./
RUN rm -rf /var/www/html && \
mv static/ /var/www/html && \
mv nginx.conf /etc/nginx/nginx.conf
CMD timeout 300 /home/ctf/run.sh
