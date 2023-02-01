FROM postgres:13.3

ENV TZ=Europe/Amsterdam

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY scripts/ /docker-entrypoint-initdb.d/
