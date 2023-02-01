FROM python:3.4-slim-stretch

# Install OS-level dependencies for Grout
RUN apt-get update && apt-get -y autoremove && apt-get install --no-install-recommends -y \
	libgeos-dev \
	binutils \
	libproj-dev \
	gdal-bin && rm -rf /var/lib/apt/lists/*;

COPY . /opt/grout
WORKDIR /opt/grout

RUN pip install --no-cache-dir -e .
RUN pip install --no-cache-dir tox

CMD ["tox"]
