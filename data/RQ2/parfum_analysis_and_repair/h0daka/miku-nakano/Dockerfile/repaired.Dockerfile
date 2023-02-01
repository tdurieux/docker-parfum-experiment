FROM python:3.10.1-buster

WORKDIR /root/MikuXProBot

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3","-m","MikuXProBot"]
