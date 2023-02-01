FROM python:3.6.5 as backend

WORKDIR /app

COPY . /app/
COPY requirements.txt /
COPY entrypoint.sh /

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /requirements.txt

ENTRYPOINT ["/entrypoint.sh"]
