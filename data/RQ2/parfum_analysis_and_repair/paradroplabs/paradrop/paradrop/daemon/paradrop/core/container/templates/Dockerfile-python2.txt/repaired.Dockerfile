FROM {image}

# Set up an unprivileged user so that we can drop out of root.
# Make /home/paradrop so that tools can drop some files in there.
# Make /opt/paradrop/app for installing the app files.
RUN useradd --system --uid 999 paradrop && \
    mkdir -p /home/paradrop && \
    chown paradrop /home/paradrop && \
    mkdir -p /opt/paradrop/app && \
    chown paradrop /opt/paradrop/app && \
    chmod a+s /opt/paradrop/app

WORKDIR /opt/paradrop/app

# Add cap_net_bind_service to node so that it can bind to ports 1-1024.
# Not all images support this.
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/node || true

# Install some useful tools and libraries.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        iptables && rm -rf /var/lib/apt/lists/*;

{has_packages:if:RUN apt-get install -y {packages}}

# Defang setuid/setgid binaries.
RUN find / -perm +6000 -type f -exec chmod a-s {{}} \; || true

# Copy paradrop.yaml and requirements.txt, the latter only if it exists.  These
# layers will be cached as long as the requirements do not change.
COPY paradrop.yaml requirements.tx[t] /opt/paradrop/app/
RUN if [ -f requirements.txt ]; then \
 pip install --no-cache-dir --requirement requirements.txt; fi

# Now copy the rest of the files.
COPY . /opt/paradrop/app/
RUN chown paradrop:paradrop -R /opt/paradrop/app

{drop_root:if:USER paradrop}

CMD {cmd}
