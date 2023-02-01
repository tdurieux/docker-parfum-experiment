#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
FROM ubuntu

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y thunderbird && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y psmisc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y language-pack-en-base && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y mime-support && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rng-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y haveged && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g eslint@2.12 && npm cache clean --force;
RUN wget -O /tmp/jsunit-0.1.4.xpi https://www.enigmail.net/jsunit/jsunit-0.1.4.xpi
RUN rm -rf /usr/lib/thunderbird-addons/extensions/jsunit@enigmail.net
RUN unzip /tmp/jsunit-0.1.4.xpi -d /usr/lib/thunderbird-addons/extensions/jsunit@enigmail.net
RUN rm -rf '/usr/lib/thunderbird-addons/extensions/{847b3a00-7ab1-11d4-8f02-006008948af5}'
RUN echo "/enigmail-src/build/dist" > '/usr/lib/thunderbird-addons/extensions/{847b3a00-7ab1-11d4-8f02-006008948af5}'
RUN useradd -Ums /bin/bash testuser
WORKDIR /enigmail-src
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8
