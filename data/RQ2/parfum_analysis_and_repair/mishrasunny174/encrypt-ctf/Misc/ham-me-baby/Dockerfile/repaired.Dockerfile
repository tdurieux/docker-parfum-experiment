FROM python:2

WORKDIR /usr/src/app

COPY server.py requirements.txt /usr/src/app/
RUN apt-get update --assume-yes && apt-get install -y --no-install-recommends --assume-yes socat && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade --assume-yes

RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 4444
CMD socat -T10 TCP-LISTEN:4444,reuseaddr,fork EXEC:"python -u /usr/src/app/server.py"