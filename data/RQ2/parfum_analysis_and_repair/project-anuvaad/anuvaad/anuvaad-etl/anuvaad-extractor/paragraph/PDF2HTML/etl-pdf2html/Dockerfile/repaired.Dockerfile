FROM python:3.7-alpine
COPY / /app
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apk update && apk add --no-cache poppler-utils
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh
ENTRYPOINT ["sh","/usr/bin/start.sh"]
