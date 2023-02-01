FROM ubuntu

WORKDIR /home/clamav

RUN echo "Prepping ClamAV"

RUN apt update -y
RUN apt install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends procps -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm init -y

RUN npm i aws-sdk tmp --save && npm cache clean --force;
RUN DEBIAN_FRONTEND=noninteractive sh -c 'apt install -y awscli'

RUN apt install --no-install-recommends -y clamav clamav-daemon && rm -rf /var/lib/apt/lists/*;

RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

RUN freshclam

COPY ./clamd.conf /etc/clamav/clamd.conf
COPY ./worker.js .
ADD ./run.sh ./run.sh

CMD ["bash", "./run.sh"]
