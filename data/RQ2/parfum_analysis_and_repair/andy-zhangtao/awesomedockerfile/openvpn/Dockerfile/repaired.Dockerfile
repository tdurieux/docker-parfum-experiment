FROM 	debian
RUN apt-get update && \
		apt-get install --no-install-recommends -y vim openvpn ssh && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["openvpn","--config"]