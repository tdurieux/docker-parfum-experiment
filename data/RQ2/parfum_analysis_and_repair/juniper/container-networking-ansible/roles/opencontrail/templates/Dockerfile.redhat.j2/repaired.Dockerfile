FROM {{ ansible_distribution | lower }}:{{ ansible_distribution_major_version }}
{%if opencontrail_build_http_proxy %}
RUN sh -c "echo proxy={{ opencontrail_build_http_proxy }}" >> /etc/yum.conf
{% endif %}
RUN {{ ansible_pkg_mgr }} install -y git make
{%if opencontrail_build_http_proxy %}
RUN git config --global http.proxy {{ opencontrail_build_http_proxy }}
RUN git config --global https.proxy {{ opencontrail_build_http_proxy }}
{% endif %}
RUN {{ ansible_pkg_mgr }} install -y automake flex bison gcc gcc-c++ boost boost-devel libxml2-devel python-lxml
RUN yum install -y yum-utils && rm -rf /var/cache/yum
# When the running system is an older version compared to the container install the vault repository
RUN release=$(awk '{print $4;}' /etc/redhat-release); if [ $release != "{{ ansible_distribution_version }} " ]; then yum-config-manager --enable C{{ ansible_distribution_version }}-base; fi
# On centos the kernel package name does not match the kernel name
RUN yum install -y kernel-devel-{{ opencontrail_host_kernel_devel }} && rm -rf /var/cache/yum
{% if ansible_distribution != "Fedora" %}
RUN yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rm -rf /var/cache/yum
{% endif %}
RUN {{ ansible_pkg_mgr }} install -y scons
RUN mkdir -p src/vrouter
WORKDIR src/vrouter
RUN git clone -b R2.20 https://github.com/Juniper/contrail-vrouter vrouter
RUN mkdir tools
RUN (cd tools && git clone https://github.com/Juniper/contrail-build build)
RUN (cd tools && git clone -b R2.20 https://github.com/Juniper/contrail-sandesh sandesh)
RUN cp tools/build/SConstruct .
{% if opencontrail_host_kmod_patches is defined %}
RUN yum install -y patch && rm -rf /var/cache/yum
{% for patch in opencontrail_host_kmod_patches %}
ADD "{{ patch }}" /src/vrouter/vrouter/
RUN (cd vrouter && patch -p1 -i "{{ patch }}")
{% endfor %}
{% endif %}