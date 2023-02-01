#sudo docker run -p 5000:5000 <id>
FROM python:3.8-slim-buster
WORKDIR /app
RUN apt-get update
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz && rm go1.18.1.linux-amd64.tar.gz
#RUN go version
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
WORKDIR /app/implant/payloads
RUN /usr/local/go/bin/go build
WORKDIR /app/c2
RUN rm -rf migrations/
RUN python3 -m flask db init
RUN python3 -m flask db migrate -m "initial migration."
RUN python3 -m flask db upgrade
CMD [ "python3", ]
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0" ]
