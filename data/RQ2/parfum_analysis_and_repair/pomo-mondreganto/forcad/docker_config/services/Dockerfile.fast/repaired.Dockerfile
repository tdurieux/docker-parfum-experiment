ARG version=latest

FROM ghcr.io/pomo-mondreganto/forcad_base:${version}

COPY backend /app

COPY ./docker_config/services/functions.sh /functions.sh
COPY ./docker_config/services/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]