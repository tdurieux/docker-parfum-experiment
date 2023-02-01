FROM python:2

WORKDIR /usr/src/app

COPY ./requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir mysqlclient

COPY . .

RUN apt update && apt install --no-install-recommends -y sqlite3 && rm -rf /var/lib/apt/lists/*;
