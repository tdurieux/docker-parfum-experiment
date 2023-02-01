FROM {{ dist }}:{{ version }}

{% if dist in ('centos', 'fedora', 'rockylinux') -%}

RUN yum -y install gcc-c++ make git libicu-devel rpmdevtools && rm -rf /var/cache/yum

# Add NodeSource repo
RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash -

{%- if version in ('centos8', 'rockylinux8') %}

# Install development tools
RUN yum -y module install nodejs:10

# Install python3 for gyp
RUN yum -y install python3 && rm -rf /var/cache/yum

# Upgrade gyp to a python3 compatible version
RUN npm install -g node-gyp@latest && npm cache clean --force;

{%- endif %}

# Install development tools
RUN yum -y install nodejs && rm -rf /var/cache/yum

{% else -%}

# Install prerequisites
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    build-essential curl gnupg devscripts debhelper dh-make git libicu-dev && rm -rf /var/lib/apt/lists/*;

{%- if version in ('bionic', 'focal') %}
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install dh-systemd && rm -rf /var/lib/apt/lists/*;
{% endif %}

# Add NodeSource repo
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

# Install node
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

{% endif -%}

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
