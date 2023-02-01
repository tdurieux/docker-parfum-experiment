FROM jjmerelo/perl-test-text
LABEL version="1.0" maintainer="JJ Merelo <jjmerelo@GMail.com>" perl5version="5.22"

WORKDIR /home/install
ADD cpanfile .
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN cpanm --installdeps .

VOLUME /test
WORKDIR /test

ENTRYPOINT prove -I/usr/lib -c
