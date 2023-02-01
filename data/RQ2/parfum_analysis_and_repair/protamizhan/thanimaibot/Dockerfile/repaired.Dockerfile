FROM python:3.9.1-buster

WORKDIR /root/MashaRoBot

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3","-m","MashaRoBot"]
