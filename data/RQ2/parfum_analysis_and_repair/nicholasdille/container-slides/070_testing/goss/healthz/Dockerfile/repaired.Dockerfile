FROM aelsabbahy/goss:v0.3.9 as goss

FROM nginx

# Copy binaries
COPY --from=goss /goss /goss

# Add test definition
COPY goss.yaml /

# Configure init
RUN apt-get update && apt-get -y --no-install-recommends install supervisor && rm -rf /var/lib/apt/lists/*;
COPY supervisord.conf /etc/supervisor/
COPY *.conf /etc/supervisor/conf.d/
ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
