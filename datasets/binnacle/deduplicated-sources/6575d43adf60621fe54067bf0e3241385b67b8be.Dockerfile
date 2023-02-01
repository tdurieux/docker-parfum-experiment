#
# Copyright (c) 2012-2016 Codenvy, S.A.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#   Codenvy, S.A. - initial API and implementation
#

FROM codenvy/python27

EXPOSE 8000
ENV CODENVY_APP_PORT_8000_HTTP 8000

RUN mkdir /tmp/application /home/user/application

ENV CODENVY_APP_BIND_DIR /home/user/application

VOLUME ["/home/user/application"]

ADD $app$/requirements.txt /tmp/application/requirements.txt

RUN cd /tmp/application && \
    sudo virtualenv /env && \
    sudo /env/bin/pip install -r requirements.txt

# 1. Update permissions recursively
# 2. Make newly created files accessible for anyone
# 3. Start application
CMD sudo chmod a+rw -R /home/user/application/ && \
    umask 0 && \
    /env/bin/python /home/user/application/$executable:-manage.py$ runserver 0.0.0.0:8000 2>&1