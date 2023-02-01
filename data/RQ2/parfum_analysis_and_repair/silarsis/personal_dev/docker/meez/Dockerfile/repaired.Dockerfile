FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN apt-get -yq update && apt-get -yq upgrade

RUN apt-get -yq --no-install-recommends install ruby && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yq --no-install-recommends install ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yq --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN gem install rdoc # Need to do first for https://github.com/rdoc/rdoc/issues/175
RUN gem install meez

CMD ['/bin/bash']
