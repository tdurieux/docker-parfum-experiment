FROM tedezed/debian-box:latest
ENV DAYS_TO_DROP="32"
RUN apt-get update \
	&& apt-get install --no-install-recommends -y jq python-pip \
	&& mkdir /sa && rm -rf /var/lib/apt/lists/*;
ADD files /files
RUN mv /files/yq /usr/local/bin/yq \
	&& pip install --no-cache-dir yq
ENTRYPOINT ["/bin/bash", "/files/entrypoint.bash"]
