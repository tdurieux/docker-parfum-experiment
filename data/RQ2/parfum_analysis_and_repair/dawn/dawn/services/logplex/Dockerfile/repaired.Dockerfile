FROM ubuntu:14.04
MAINTAINER speed "blaz@roave.com"

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN echo deb http://packages.erlang-solutions.com/debian precise contrib >> /etc/apt/sources.list
RUN curl -f -s https://packages.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add -
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install openssl libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install esl-erlang=1:16.b.3-2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y autoremove
RUN git clone https://github.com/heroku/logplex.git /opt/logplex
RUN cd /opt/logplex && ./rebar --config public.rebar.config get-deps compile

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

EXPOSE 8001 8601

cmd ["/usr/local/bin/run"]
