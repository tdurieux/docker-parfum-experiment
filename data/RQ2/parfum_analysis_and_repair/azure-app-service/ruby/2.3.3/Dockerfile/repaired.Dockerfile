FROM appsvc/rubybase:2.3.3
LABEL maintainer="Azure App Services Container Images <appsvc-images@microsoft.com>"

COPY init_container.sh /bin/
COPY startup.sh /opt/
COPY sshd_config /etc/ssh/
COPY hostingstart.html /opt/startup/hostingstart.html
COPY staticsite.rb /opt/staticsite.rb

RUN apt-get update -qq \
    && apt-get install -y nodejs openssh-server vim curl wget tcptraceroute --no-install-recommends \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home" >> /etc/bash.bashrc && rm -rf /var/lib/apt/lists/*;

RUN eval "$(rbenv init -)" \
  && rbenv global 2.3.3

RUN chmod 755 /bin/init_container.sh \
  && mkdir -p /home/LogFiles/ \
  && chmod 755 /opt/startup.sh

EXPOSE 2222 8080

ENV PORT 8080
ENV SSH_PORT 2222
ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot

# install libssl1.0.2
RUN wget https://ftp.us.debian.org/debian/pool/main/o/openssl1.0/libssl1.0.2_1.0.2q-1~deb9u1_amd64.deb \
  && apt-get install -y --no-install-recommends dialog \
  && dpkg -i libssl1.0.2_1.0.2q-1~deb9u1_amd64.deb && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/site/wwwroot

ENTRYPOINT [ "/bin/init_container.sh" ]
