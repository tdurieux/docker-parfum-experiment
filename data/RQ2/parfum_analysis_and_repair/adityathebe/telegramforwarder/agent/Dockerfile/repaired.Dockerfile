FROM python:3.8-rc-buster

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean && \
  apt-get update

RUN apt-get install --no-install-recommends python-dev default-libmysqlclient-dev -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /telegram-python-agent

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "server.py"]