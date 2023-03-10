FROM continuumio/miniconda3
MAINTAINER https://github.com/bird-house/flyingpigeon
LABEL Description="Flyingpigeon WPS" Vendor="Birdhouse" Version="1.5.1"

# Update Debian system
RUN apt-get update && apt-get install --no-install-recommends -y \
 build-essential \
&& rm -rf /var/lib/apt/lists/*

# Update conda
RUN conda update -n base conda

# Copy WPS project
COPY . /opt/wps

WORKDIR /opt/wps

# Create conda environment with PyWPS
RUN ["conda", "env", "create", "-n", "wps", "-f", "environment.yml"]

# Install WPS
RUN ["/bin/bash", "-c", "source activate wps && pip install -e ."]

# Start WPS service on port 8093 on 0.0.0.0
EXPOSE 8093
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["source activate wps && exec flyingpigeon start -b 0.0.0.0 -c /opt/wps/etc/demo.cfg"]

# docker build -t bird-house/flyingpigeon .
# docker run -p 8093:8093 bird-house/flyingpigeon
# http://localhost:8093/wps?request=GetCapabilities&service=WPS
# http://localhost:8093/wps?request=DescribeProcess&service=WPS&identifier=all&version=1.0.0
