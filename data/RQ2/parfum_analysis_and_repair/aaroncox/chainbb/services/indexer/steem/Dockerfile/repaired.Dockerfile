FROM python:3.6.2-slim

RUN apt-get update && apt-get install --no-install-recommends -y make gcc libssl-dev && rm -rf /var/lib/apt/lists/*;

ADD ./requirements.txt /
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /src

CMD ["python", "/src/main.py"]
