FROM python:3

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install --no-install-recommends -y libvips-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pyvips

WORKDIR /data
