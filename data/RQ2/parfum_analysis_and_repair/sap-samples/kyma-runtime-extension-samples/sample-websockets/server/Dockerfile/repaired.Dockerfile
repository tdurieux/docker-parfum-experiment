FROM ubuntu

RUN apt-get update -y && apt-get install --no-install-recommends -y python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /requirements.txt

WORKDIR /

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /

EXPOSE 8888

ENTRYPOINT [ "python3" ]

CMD ["app/app.py"]
