FROM {{ dist }}:{{ version }}

{% if dist in ('centos', 'fedora', 'rockylinux') -%}

# Add NodeSource repo
RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash -

# Install development tools
RUN yum -y install nodejs && rm -rf /var/cache/yum

{% else -%}

# Install prerequesties
RUN apt-get clean && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install curl gnupg && rm -rf /var/lib/apt/lists/*;

# Add NodeSource repo
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

# Install node
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install nodejs && rm -rf /var/lib/apt/lists/*;

{% endif -%}

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
