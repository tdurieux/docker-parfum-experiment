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

FROM codenvy/jdk7_virgo

$debug?EXPOSE 8000:$
$debug?ENV CODENVY_APP_PORT_8000_DEBUG 8000:$
$debug?CMD ./startup.sh -debug:$

ENV CODENVY_APP_BIND_DIR /home/user/virgo/pickup/ROOT.war
VOLUME ["/home/user/virgo/pickup/ROOT.war"]