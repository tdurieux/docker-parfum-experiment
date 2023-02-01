FROM python:3.7-slim

RUN apt-get clean all
RUN apt-get update && apt-get install -y --no-install-recommends git python3-dev libffi-dev libssl-dev gcc make && rm -rf /var/lib/apt/lists/*;
RUN apt-get autoremove

RUN pip3 install --no-cache-dir --upgrade pip
RUN apt-get purge -y --auto-remove
RUN rm -rf /var/lib/apt/lists/*

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfor/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /usr/local
RUN git clone https://github.com/visionspacetec/sle-common.git
WORKDIR /usr/local/sle-common
RUN pip3 install --no-cache-dir -e .

WORKDIR /usr/local/sle-provider
COPY . .
RUN pip3 install --no-cache-dir -e .

COPY /docker/frame_generation/docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh

EXPOSE 2048
EXPOSE 16887
EXPOSE 16888
EXPOSE 55529

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
