FROM ubuntu:16.04
MAINTAINER Boris Kolganov <b.kolganov@corp.mail.ru>

WORKDIR /opt/mechanic

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . ./

EXPOSE 8000
CMD ["python3", "-u", "./serverrunner.py"]