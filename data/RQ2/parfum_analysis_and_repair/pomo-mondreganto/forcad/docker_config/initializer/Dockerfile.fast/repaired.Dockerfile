ARG version=latest

FROM ghcr.io/pomo-mondreganto/forcad_base:${version}

COPY backend /app

COPY ./docker_config/initializer/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]