FROM openjdk:8-slim
RUN apt-get install -y --no-install-recommends openssl && rm -rf /var/lib/apt/lists/*;
COPY generate-certs.sh /usr/local/bin
RUN chmod +x /usr/local/bin/generate-certs.sh
CMD ["/bin/sh", "-c", "generate-certs.sh"]
