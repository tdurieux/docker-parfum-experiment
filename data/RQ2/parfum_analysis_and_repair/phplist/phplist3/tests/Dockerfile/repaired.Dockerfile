FROM debian:buster-slim

LABEL maintainer="michiel@phplist.com"

RUN apt -y update && apt -y upgrade

RUN apt install --no-install-recommends -y -qq postfix && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y php-cli mariadb-server bash sudo composer git php-curl php-mysqli php-dom make firefox-esr wget && rm -rf /var/lib/apt/lists/*;
## otherwise jdk fails, https://github.com/geerlingguy/ansible-role-java/issues/64
RUN mkdir -p /usr/share/man/man1
RUN apt install --no-install-recommends -y default-jdk && rm -rf /var/lib/apt/lists/*;

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt -y --no-install-recommends install ./google-chrome-stable_current_amd64.deb && rm -rf /var/lib/apt/lists/*;

## debugging utils, that can be removed once it works
RUN apt install --no-install-recommends -y vim curl telnet psutils && rm -rf /var/lib/apt/lists/*;

RUN useradd -m -s /bin/bash -d /home/phplist phplist

COPY . /var/www/phplist3
RUN chown -R phplist: /var/www
USER phplist
WORKDIR /var/www/phplist3/
RUN rm -rf vendor


ENTRYPOINT [ "./scripts/run-tests.sh" ]

#ENTRYPOINT [ "/bin/bash" ]
