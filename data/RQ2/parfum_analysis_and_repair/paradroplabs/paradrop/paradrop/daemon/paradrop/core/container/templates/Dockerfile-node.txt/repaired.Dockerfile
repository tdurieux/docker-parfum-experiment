FROM {image}

ENV npm_config_loglevel=warn

# Set up an unprivileged user so that we can drop out of root.
# Make /home/paradrop so that npm can drop some files in there.
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

# Install popular tools here.
RUN npm install --global gulp-cli && npm cache clean --force;

{has_packages:if:RUN apt-get update && apt-get install -y {packages}}

# Defang setuid/setgid binaries.
RUN find / -perm +6000 -type f -exec chmod a-s {{}} \; || true

# Copy paradrop.yaml and package.json, the latter only if it exists. Then call
# init-app.sh to install dependencies. These layers will be cached as long as
# the requirements do not change.
COPY paradrop.yaml package.jso[n] /opt/paradrop/app/
RUN npm rebuild && \
    if [ -f package.json ]; then \
    npm install; npm cache clean --force; fi

COPY . /opt/paradrop/app/
RUN chown paradrop:paradrop -R /opt/paradrop/app

{drop_root:if:USER paradrop}

CMD {cmd}
