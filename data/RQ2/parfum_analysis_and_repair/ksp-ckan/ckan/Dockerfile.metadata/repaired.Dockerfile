FROM mono:latest

RUN /bin/sed -i 's/^mozilla\/DST_Root_CA_X3.crt$/!mozilla\/DST_Root_CA_X3.crt/' /etc/ca-certificates.conf && \
    /usr/sbin/update-ca-certificates
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip python3-setuptools git build-essential python3-dev libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir 'git+https://github.com/KSP-CKAN/NetKAN-Infra#subdirectory=netkan'
RUN pip3 install --no-cache-dir 'git+https://github.com/KSP-CKAN/xKAN-meta_testing'

ADD netkan.exe /usr/local/bin/.
ADD ckan.exe /usr/local/bin/.

ENTRYPOINT ["ckanmetatester"]
