FROM python:2.7
COPY ./src /app
WORKDIR /app
ARG LPORT
ENV SERVERLPORT=${LPORT}
RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT python -m SimpleHTTPServer ${SERVERLPORT} 2>&1 | tee httplog.txt
