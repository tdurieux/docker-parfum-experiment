FROM devbase

# Install Unbound
RUN apt-get install --no-install-recommends -y unbound && rm -rf /var/lib/apt/lists/*;
RUN mv /etc/unbound /etc/unbound.bak
COPY unbound /etc/unbound/

# Install helper scripts
COPY *.sh /opt/
RUN chmod +x /opt/*.sh

# Replace Jinja2 template fragments and to launch Unbound in the foreground
ENTRYPOINT ["/opt/start-unbound.sh"]