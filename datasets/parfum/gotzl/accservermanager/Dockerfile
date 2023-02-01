FROM debian:10.5-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wine-development python3-pip && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /accservermanager /data

WORKDIR /accservermanager

RUN useradd -ms /bin/bash someuser && \
    chown -R someuser:someuser /accservermanager /data

USER someuser
VOLUME /data

COPY ./requirements.txt .
RUN pip3 install --user --no-cache-dir -r requirements.txt

ENV WINEARCH=win64 \
    WINEDEBUG=-all
RUN wineboot --init

COPY . /accservermanager

EXPOSE 9231/udp 9232/tcp 8000/tcp
CMD ["python3", "manage.py", "runserver", "--insecure", "0.0.0.0:8000"]
