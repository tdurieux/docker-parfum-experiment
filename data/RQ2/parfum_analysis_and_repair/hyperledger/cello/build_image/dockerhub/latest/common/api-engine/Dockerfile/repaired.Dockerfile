FROM python:3.6

# Install software
RUN apt-get update \
	&& apt-get install --no-install-recommends -y gettext-base graphviz libgraphviz-dev \
	&& apt-get autoclean \
	&& apt-get clean \
	&& apt-get autoremove && rm -rf /var/cache/apt/ && rm -rf /var/lib/apt/lists/*;

# Set the working dir
WORKDIR /var/www/server

# Copy source code to the working dir
COPY src/api-engine ./

# Install python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Add uwsgi configuration file
COPY build_image/docker/common/api-engine/server.ini /etc/uwsgi/apps-enabled/

ENV RUN_MODE server

COPY build_image/docker/common/api-engine/entrypoint.sh /
CMD bash /entrypoint.sh
