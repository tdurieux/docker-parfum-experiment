FROM quantopian/zipline
ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# update, upgrade, and install packages
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y apt-utils \
    && apt-get install --no-install-recommends -y nano less make \
    && apt-get install --no-install-recommends -y python-dev python3-dev && rm -rf /var/lib/apt/lists/*;

# configure apt-utils (fixes warnings)
RUN dpkg-reconfigure apt-utils

# install requirements, package, and tox
COPY . /app
RUN pip install --no-cache-dir -r /app/requirements/base.txt
RUN pip install --no-cache-dir /app
RUN pip install --no-cache-dir tox

# stage the entrypoint
COPY ./compose/stockbot/entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
