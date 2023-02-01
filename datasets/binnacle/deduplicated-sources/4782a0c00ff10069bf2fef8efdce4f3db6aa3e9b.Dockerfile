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
RUN echo 'USE="${USE} sqlite"' >> /etc/portage/make.conf
RUN sed -i 's/\(PYTHON_TARGETS\)=.*/\1="python2_7"/' /etc/portage/make.conf
RUN sed -i 's/\(PYTHON_SINGLE_TARGET\)=.*/\1="python2_7"/' /etc/portage/make.conf
RUN echo 'USE_PYTHON="2.7"' >> /etc/portage/make.conf
RUN emerge -v --newuse --deep --with-bdeps=y @system @world
RUN eselect python set $(eselect python show --python2)
RUN mkdir /etc/portage/package.accept_keywords
COPY package.accept_keywords /etc/portage/package.accept_keywords/docker-registry
RUN emerge -v dev-python/blinker dev-python/boto dev-python/backports-lzma dev-python/flask dev-python/flask-cors dev-python/gevent dev-python/pyyaml dev-python/redis-py dev-python/requests dev-python/rsa dev-python/simplejson dev-python/sqlalchemy dev-vcs/git www-servers/gunicorn
RUN eselect news read new
RUN git clone git://github.com/dotcloud/docker-registry.git
RUN cp --no-clobber docker-registry/config/config_sample.yml docker-registry/config/config.yml

# Disable strict dependencies (see dotcloud/docker-registry#466)
RUN sed -i 's/\(install_requires=\)/#\1/' docker-registry/setup.py docker-registry/depends/docker-registry-core/setup.py

RUN cd docker-registry/depends/docker-registry-core/ && python setup.py install
RUN cd docker-registry && python setup.py install

CMD exec docker-registry
EXPOSE 5000
