FROM python:3.9.1-buster

WORKDIR /root/NekoXRobot

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3","-m","NekoXRobot"]
