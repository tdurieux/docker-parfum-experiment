FROM _DOCKER_BASE_
COPY build_image/docker/baseimage /tmp/baseimage
RUN cd /tmp/baseimage && \
    bash install.sh && \
rm -rf /tmp/baseimage
COPY src/operator-dashboard /app
RUN	cd /app/ && \
	pip install -r requirements.txt && \
	rm -rf /tmp/cello
WORKDIR /app
