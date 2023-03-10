FROM amd64/python:3.7-slim-buster

WORKDIR /app

RUN pip install --no-cache-dir ptvsd==4.3.2
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python3", "-u", "./main.py" ]