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

FROM ${NAMESPACE}/nginx:${TAG}
MAINTAINER ${MAINTAINER}

# Add a framework for easy virtual hosts
RUN mkdir /etc/nginx/vhosts
RUN chown nginx:nginx /etc/nginx/vhosts
RUN sed -i 's|^\([[:space:]]*\)\(server {\)|\1include vhosts/*.conf;\n\n\1\2|' /etc/nginx/nginx.conf
COPY vhost-template.conf /etc/nginx/vhosts/TEMPLATE
RUN chown nginx:nginx /etc/nginx/vhosts/TEMPLATE
COPY create-vhosts-from-environment.sh /usr/bin/create-vhosts-from-environment

# Uncomment the default HTTPS server
RUN sed -i 's/^\t#\([^ ]\)/\t\1/' /etc/nginx/nginx.conf
RUN sed -i 's/listen 127.0.0.1:443;/listen 443 default_server;/' /etc/nginx/nginx.conf

CMD create-vhosts-from-environment && rc default && exec tail-syslog
EXPOSE 443
