FROM python:3.7-slim
COPY / /app
WORKDIR /app
ARG D_F
ENV DEBUG_FLUSH=$D_F
RUN pip3 install --no-cache-dir -r requirements.txt
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh
CMD ["/usr/bin/start.sh"]
