{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM docker-ptf-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

# Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Set the apt source, update package cache and install necessary packages
RUN apt-get update              \
    && apt-get upgrade -y       \
    && apt-get dist-upgrade -y \
    && apt-get install --no-install-recommends -y \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir crc16 \
        netifaces \
        getmac \
        packet_helper \
        psutil \
        scapy==2.4.4 \
        scapy_helper \
        pysubnettree \
        xmlrunner

COPY \
{% for deb in docker_ptf_sai_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN dpkg -i \
{% for deb in docker_ptf_sai_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

# Remove old ptf package
RUN dpkg -r python-ptf

# Install new ptf package
RUN git clone https://github.com/p4lang/ptf.git \
        && cd ptf                               \
        && python3.7 setup.py install --single-version-externally-managed --record /tmp/ptf_install.txt
