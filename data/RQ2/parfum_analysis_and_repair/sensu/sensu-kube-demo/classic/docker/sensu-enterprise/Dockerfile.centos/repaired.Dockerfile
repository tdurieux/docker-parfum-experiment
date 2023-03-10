FROM sensu/sensu-classic-enterprise:3.2.2-1

ARG sensu_release=1.5.0-1

# Install Sensu
RUN echo $'[sensu]\n\
name=sensu\n\
baseurl=https://sensu.global.ssl.fastly.net/yum/$releasever/$basearch/\n\
gpgkey=https://repositories.sensuapp.org/yum/pubkey.gpg\n\
gpgcheck=1\n\
enabled=1' | tee /etc/yum.repos.d/sensu.repo

RUN yum install -y sensu-${sensu_release}.el7.x86_64 && rm -rf /var/cache/yum

# Cleanup
RUN rm -rf /opt/sensu/embedded/lib/ruby/gems/2.4.0/{cache,doc}/* && \
    find /opt/sensu/embedded/lib/ruby/gems/ -name "*.o" -delete

ADD deregistration.rb /etc/sensu/plugins/
ADD deregistration_kubernetes.rb /etc/sensu/plugins/
RUN chmod +x /etc/sensu/plugins/*
