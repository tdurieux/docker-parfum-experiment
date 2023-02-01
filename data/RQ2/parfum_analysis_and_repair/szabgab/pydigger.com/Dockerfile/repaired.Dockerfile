FROM python:3.9

RUN apt-get update && \
    apt-get install --no-install-recommends -y less && \
    apt-get install --no-install-recommends -y vim && \
    apt-get install --no-install-recommends -y cron && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt
COPY .bashrc /root/
COPY requirements.txt /opt/
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r /opt/requirements.txt

COPY . .

RUN crontab /opt/crontab.txt
ENV FLASK_APP=PyDigger.website
CMD ["flask", "run", "--host", "0.0.0.0", "--port", "5000"]
