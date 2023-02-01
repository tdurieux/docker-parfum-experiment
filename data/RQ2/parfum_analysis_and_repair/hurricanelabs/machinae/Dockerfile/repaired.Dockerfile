FROM python:3

RUN pip3 install --no-cache-dir machinae

#make sure you have a machinae.yml file to build with
COPY machinae.yml /etc

ENTRYPOINT ["/usr/local/bin/machinae"]
