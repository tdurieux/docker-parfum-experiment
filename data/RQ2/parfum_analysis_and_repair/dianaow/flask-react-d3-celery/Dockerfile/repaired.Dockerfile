FROM ubuntu

RUN apt-get update && apt-get -y upgrade

RUN apt-get install --no-install-recommends -y python-pip && pip install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN mkdir /home/ubuntu

WORKDIR /home/ubuntu/celery-scheduler

ADD requirements.txt /home/ubuntu/celery-scheduler/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /home/ubuntu/celery-scheduler

EXPOSE 5000