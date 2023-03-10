FROM kalilinux/kali-rolling

ARG DEBIAN_FRONTEND=noninteractive

# Forcing this repo for now since Travis' kali repo has been crapping out.
RUN echo deb http://http.kali.org/kali kali-rolling main contrib non-free > /etc/apt/sources.list && \
    apt update && apt dist-upgrade -y && \
    apt install --no-install-recommends -y python3 python3-pip && \
    useradd -m -s /bin/bash stegoveritas && \
    mkdir -p /opt && rm -rf /var/lib/apt/lists/*;

COPY --chown=stegoveritas:stegoveritas . /opt/stegoveritas/

RUN cd /opt/stegoveritas && pip3 install --no-cache-dir -e .[dev] && \
    stegoveritas_install_deps

WORKDIR /home/stegoveritas
USER stegoveritas
