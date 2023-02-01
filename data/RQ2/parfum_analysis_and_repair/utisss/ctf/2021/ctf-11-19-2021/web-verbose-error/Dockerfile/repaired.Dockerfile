FROM ubuntu:20.04

WORKDIR /usr/src/app
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip
COPY /requirements.txt /usr/src/app/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

EXPOSE 5000

ENTRYPOINT ["python3"]

CMD ["/usr/src/app/app.py"]
