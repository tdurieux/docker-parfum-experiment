FROM newsched_rest_base

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -qy iputils-ping && rm -rf /var/lib/apt/lists/*;
COPY setup_env.sh ${PREFIX}
COPY docker-entrypoint.sh ${PREFIX}

RUN mkdir /root/.gnuradio
COPY config.yml /root/.gnuradio

CMD cd ${PREFIX} && ./docker-entrypoint.sh