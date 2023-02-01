FROM ccnmtl/django.base
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
		git-core \
		libffi-dev \
		libssl-dev \
		python-dev \
		python3-requests \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
ADD ssh_config /etc/ssh/ssh_config
COPY package.json /node/
RUN cd /node && npm install && touch /node/node_modules/sentinal && npm cache clean --force;
ADD wheelhouse /wheelhouse
ADD requirements /requirements
RUN /ve/bin/pip install --no-index -f /wheelhouse -r /wheelhouse/requirements.txt && touch /ve/sentinal
WORKDIR /app
COPY . /app/
RUN mkdir -p /var/www/rolf/rolf \
&& mkdir -p /var/tmp/rolf/checkouts \
&& mkdir -p /var/tmp/rolf/scripts \
&& touch /node/node_modules/sentinal \
&& VE=/ve/ MANAGE="/ve/bin/python manage.py" NODE_MODULES=/node/node_modules make
EXPOSE 8000
ADD docker-run.sh /run.sh
ENV APP rolf
ENTRYPOINT ["/run.sh"]
CMD ["run"]
