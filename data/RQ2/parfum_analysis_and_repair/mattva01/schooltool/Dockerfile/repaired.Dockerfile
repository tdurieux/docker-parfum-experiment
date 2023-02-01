FROM ubuntu:trusty
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN echo 'APT::Get::Assume-Yes "true";'  > /etc/apt/apt.conf.d/90forceyes


ADD . /schooltool/
WORKDIR /schooltool/

RUN make ubuntu-environment
RUN make
RUN make compile-translations
RUN make instance

RUN sed -i s/127.0.0.1/0.0.0.0/g instance/paste.ini

CMD make run

EXPOSE 7080
