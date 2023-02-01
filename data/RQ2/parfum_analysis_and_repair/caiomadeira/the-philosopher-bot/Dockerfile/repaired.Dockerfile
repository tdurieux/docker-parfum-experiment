FROM python:3.9

WORKDIR /PHILOBOT

COPY . .

RUN pip install --no-cache-dir -r requirements.txt
