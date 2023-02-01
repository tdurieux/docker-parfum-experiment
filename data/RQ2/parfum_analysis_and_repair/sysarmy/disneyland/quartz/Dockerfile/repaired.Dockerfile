FROM python:3.7

WORKDIR /app
COPY ./quartz.py .
COPY ./run-quartz.sh .

RUN chmod +x /app/run-quartz.sh

RUN apt-get update && \
    apt-get -y --no-install-recommends install cron && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir icmplib requests && \
    pip cache purge

RUN echo "*/5 * * * * root /app/run-quartz.sh" > /etc/cron.d/qartz

RUN mkdir /root/.config

ENV EXECUTION_ENV=DOCKER

CMD ["/app/run-quartz.sh"]