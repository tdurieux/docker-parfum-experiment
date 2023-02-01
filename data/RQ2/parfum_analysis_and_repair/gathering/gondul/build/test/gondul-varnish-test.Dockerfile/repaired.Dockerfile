FROM debian:jessie
RUN apt-get update && apt-get -y --no-install-recommends install varnish && rm -rf /var/lib/apt/lists/*;

CMD /opt/gondul/build/test/varnish-init.sh
EXPOSE 80
