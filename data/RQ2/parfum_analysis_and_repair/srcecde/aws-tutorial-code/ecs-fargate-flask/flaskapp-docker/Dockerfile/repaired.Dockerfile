FROM ubuntu:18.04
MAINTAINER chiragr83@gmail.com

RUN apt-get update -y
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gunicorn3 -y && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt requirements.txt
COPY flaskapp /opt/

RUN pip3 install --no-cache-dir -r requirements.txt
WORKDIR /opt/

CMD ["gunicorn3", "-b", "0.0.0.0:8000", "app:app", "--workers=5"]
