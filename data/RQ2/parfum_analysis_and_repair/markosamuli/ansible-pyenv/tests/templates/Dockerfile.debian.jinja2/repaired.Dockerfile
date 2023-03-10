FROM {{ from }}

RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
    zsh \
    sudo \
    aptitude \
    locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

{% if python == 'python3' %}
# Install python3 from APT
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-minimal \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
{% else %}
# Install python from APT
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-minimal \
    python-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
{% endif %}

ARG user={{ user }}
ARG repository={{ repository }}

# Create test user
RUN useradd -m ${user} -s /bin/bash \
    && echo "${user}:${user}" | chpasswd \
    && adduser ${user} sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN touch /home/${user}/.zshrc \
    && chown -R ${user}:${user} /home/${user}

# Create directory for code
RUN mkdir -p /home/${user}/${repository} \
    && chown -R ${user}:${user} /home/${user}/${repository}
VOLUME ["/home/${user}/${repository}"]

ARG ansible_version={{ ansible_version }}
ENV ANSIBLE_VERSION="${ansible_version}"
{% if python == 'python3' %}
RUN pip3 install --no-cache-dir ansible${ANSIBLE_VERSION}
{% else %}
RUN pip install --no-cache-dir ansible${ANSIBLE_VERSION}
{% endif %}

{% if install_homebrew %}
# Homebrew installationg dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential curl file git procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD install_homebrew.sh /home/${user}/install_homebrew.sh
RUN chown ${user}:${user} /home/${user}/install_homebrew.sh \
    && chmod u+x /home/${user}/install_homebrew.sh \
    && sudo -i -u ${user} /home/${user}/install_homebrew.sh
{% endif %}

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
