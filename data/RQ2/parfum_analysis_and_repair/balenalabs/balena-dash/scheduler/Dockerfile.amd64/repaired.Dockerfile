FROM balenalib/%%BALENA_MACHINE_NAME%%

RUN install_packages vbetool cron

COPY scripts/amd64 /usr/src/
RUN chmod +x /usr/src/*.sh

CMD ["/usr/src/start.sh"]