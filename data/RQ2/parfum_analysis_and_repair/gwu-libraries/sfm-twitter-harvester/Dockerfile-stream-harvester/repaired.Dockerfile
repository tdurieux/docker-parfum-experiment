# Python 3.8.12:buster
FROM gwul/sfm-base@sha256:0b80a3d3562cdb4d631fbb55b9bd24889312838cbd27cd33e14cc0c18405f007
MAINTAINER Social Feed Manager <sfm@gwu.edu>

# Install supervisor
RUN apt-get update && apt-get install --no-install-recommends -y \
    supervisor=3.3* && rm -rf /var/lib/apt/lists/*;
#     supervisor=4.2*
VOLUME /etc/supervisor/conf.d

ADD . /opt/sfm-twitter-harvester/
WORKDIR /opt/sfm-twitter-harvester
RUN pip install --no-cache-dir -r requirements/common.txt -r

ADD docker/stream-harvester/invoke.sh /opt/sfm-setup/
RUN chmod +x /opt/sfm-setup/invoke.sh

#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/opt/sfm-setup/invoke.sh"]
