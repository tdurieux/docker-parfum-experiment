FROM python:3.6
WORKDIR /app
RUN pip3 install --no-cache-dir adslproxy
CMD ["adslproxy", "serve"]