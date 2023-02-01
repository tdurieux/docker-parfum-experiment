# Copyright (C) 2013-2014 W. Trevor King <wking@tremily.us>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

FROM ${NAMESPACE}/gentoo-syslog:${TAG}
MAINTAINER ${MAINTAINER}
#VOLUME ["${PORTAGE}:/usr/portage:ro", "${PORTAGE}/distfiles:/usr/portage/distfiles:rw"]
RUN mkdir -p /etc/portage/package.use
RUN echo 'net-irc/ngircd ~amd64' >> /etc/portage/package.accept_keywords
RUN echo 'net-irc/ngircd -pam' >> /etc/portage/package.use/ngircd
RUN emerge -v net-irc/ngircd
RUN eselect news read new
RUN rc-update add ngircd default

RUN sed -i 's/;Listen = 127.0.0.1,192.168.0.1/Listen = ::,0.0.0.0/' /etc/ngircd/ngircd.conf
RUN sed -i 's/;PAM = yes/PAM = no/' /etc/ngircd/ngircd.conf
RUN sed -i 's/;SyslogFacility = local1/SyslogFacility = daemon/' /etc/ngircd/ngircd.conf
RUN sed -i 's|^\([[:space:]]*\)\(need net\)$|\1\2\n\1use logger|' /etc/init.d/ngircd
COPY setup-ngircd-config-from-environment.sh /usr/bin/setup-ngircd-config-from-environment
RUN sed -i 's/Name = irc.example.net/Name = ${HOSTNAME}/' /etc/ngircd/ngircd.conf
RUN sed -i 's/;AdminInfo1 = Description/AdminInfo1 = ${DESCRIPTION}/' /etc/ngircd/ngircd.conf
RUN sed -i 's/;AdminInfo2 = Location/AdminInfo2 = ${LOCATION}/' /etc/ngircd/ngircd.conf
RUN sed -i 's/;AdminEMail = admin@irc.server/AdminEMail = ${EMAIL}/' /etc/ngircd/ngircd.conf
RUN sed -i 's/Info = Server Info Text/Info = ${INFO}/' /etc/ngircd/ngircd.conf

CMD setup-ngircd-config-from-environment && rc default && exec tail-syslog
EXPOSE 6667
