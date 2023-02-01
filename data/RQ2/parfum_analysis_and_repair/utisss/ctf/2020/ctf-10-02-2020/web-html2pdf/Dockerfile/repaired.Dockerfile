FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip wkhtmltopdf xvfb && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
RUN pip3 install --no-cache-dir --upgrade pip
COPY /requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app
COPY flag.txt /flag.txt

EXPOSE 5000

ENTRYPOINT ["python3"]

CMD ["/usr/src/app/app.py"]
