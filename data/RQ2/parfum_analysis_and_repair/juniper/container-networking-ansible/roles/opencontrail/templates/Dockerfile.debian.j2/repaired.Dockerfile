FROM {{ ansible_distribution | lower }}:{{ ansible_distribution_version }}
{%if opencontrail_build_http_proxy %}
RUN sh -c "echo 'Acquire::http::Proxy \"{{ opencontrail_build_http_proxy }}\";' >> /etc/apt/apt.conf.d/02proxy"
{% endif %}
RUN apt-get update
RUN {{ ansible_pkg_mgr }} install -y git make
{%if opencontrail_build_http_proxy %}
RUN git config --global http.proxy {{ opencontrail_build_http_proxy }}
RUN git config --global https.proxy {{ opencontrail_build_http_proxy }}
{% endif %}
RUN {{ ansible_pkg_mgr }} install -y automake flex bison gcc g++ scons linux-headers-{{ ansible_kernel }} libboost-dev libxml2-dev
RUN mkdir -p src/vrouter
WORKDIR src/vrouter
RUN git clone -b R2.20 https://github.com/Juniper/contrail-vrouter vrouter
RUN mkdir tools
RUN (cd tools && git clone https://github.com/Juniper/contrail-build build)
RUN (cd tools && git clone -b R2.20 https://github.com/Juniper/contrail-sandesh sandesh)
RUN cp tools/build/SConstruct .