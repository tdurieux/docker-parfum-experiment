FROM debian:jessie
RUN apt-get update && apt-get -y --no-install-recommends install \
	python3-jinja2 \
	python3-netaddr \
	python3-flask \
	python3-requests && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /opt/gondul

CMD /opt/gondul/templating/templating.py
EXPOSE 8080
