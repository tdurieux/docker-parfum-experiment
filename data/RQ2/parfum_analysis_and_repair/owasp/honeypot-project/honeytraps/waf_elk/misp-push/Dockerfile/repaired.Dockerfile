FROM ubuntu:latest
WORKDIR /app/
USER root
ENV LC_ALL="C.UTF-8"
RUN apt-get update && apt-get install --no-install-recommends -y nano python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pipenv
RUN pipenv install
COPY ./ /app
CMD ["/bin/bash", "/app/start.sh"]
