from ubuntu:18.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PATH="/root/.local/bin:$PATH"
ENV HOME="/root"

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip && \
    pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

COPY . /root/nearup/
RUN cd /root/nearup && pip3 install --no-cache-dir --user .

COPY ./start.sh /root/start.sh
RUN chmod +x /root/start.sh

ENTRYPOINT ["/root/start.sh"]
