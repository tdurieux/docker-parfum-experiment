FROM python:3

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir chatterbot
RUN pip install --no-cache-dir websock

WORKDIR /websock

COPY . .

EXPOSE 80

CMD ["python", "./ExampleChatServer.py"]

# docker build -t chatserver .
# docker run -p 80:80 -d -v /root/WebSock/examples/chatAppServer:/websock chatserver