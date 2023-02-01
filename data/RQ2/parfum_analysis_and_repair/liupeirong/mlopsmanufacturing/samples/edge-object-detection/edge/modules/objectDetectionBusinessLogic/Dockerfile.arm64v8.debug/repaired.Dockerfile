FROM arm64v8/python:3.7-slim-buster

RUN apt-get -y update && apt-get -y --no-install-recommends install gcc && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN pip install --no-cache-dir ptvsd==4.3.2
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python3", "-u", "./main.py" ]