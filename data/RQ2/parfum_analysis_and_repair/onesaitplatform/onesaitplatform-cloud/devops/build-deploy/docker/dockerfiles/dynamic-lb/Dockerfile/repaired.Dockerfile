FROM python:3

# metadata
LABEL module.maintainer="onesaitplatform@indra.es" \
	  module.name="dynamic-lb"	

ENV PYTHONUNBUFFERED 1

RUN apt update && \
    apt install --no-install-recommends nginx -y && \
	apt install --no-install-recommends bash -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app

WORKDIR /app

RUN chmod 755 /app

ADD scripts/requiements.pip /app/

RUN pip3 install --no-cache-dir -r requiements.pip

ADD scripts/startServer.sh /app/

RUN chmod 755 /app/startServer.sh

ADD src/reconf/reconf /app/reconf
ADD src/reconf/api /app/api
ADD src/reconf/manage.py /app/

EXPOSE 90 8000

ENTRYPOINT ["/bin/bash", "/app/startServer.sh"]