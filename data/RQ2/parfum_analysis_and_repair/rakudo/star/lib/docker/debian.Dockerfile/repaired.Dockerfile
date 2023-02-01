FROM debian:latest AS base

COPY . /home/rstar

RUN apt-get update && apt-get install --no-install-recommends -y git build-essential libreadline7 && rm -rf /var/lib/apt/lists/*;
RUN /home/rstar/bin/rstar install -p /home/raku
RUN apt-get -y remove git build-essential
RUN apt-get -y autoremove

FROM debian:latest

COPY --from=base /home/raku /usr/local
COPY --from=base /lib       /lib

ENV PATH=/usr/local/share/perl6/site/bin:$PATH
ENV PATH=/usr/local/share/perl6/vendor/bin:$PATH
ENV PATH=/usr/local/share/perl6/core/bin:$PATH
ENV PERL6LIB=/app/lib

WORKDIR /app

CMD [ "raku" ]
