FROM ubuntu:trusty

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get install -y

RUN apt-get install --no-install-recommends -y software-properties-common \
                       python-software-properties \
                       python3-pip \
                       wget && rm -rf /var/lib/apt/lists/*;
ADD requirements.txt .
RUN apt-get install --no-install-recommends cython -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt
# set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# language deps
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN add-apt-repository ppa:eugenesan/ppa -y
RUN apt-get update
RUN apt-get install --no-install-recommends elixir -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends php5 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends golang -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends clojure1.4 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends ghc -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends g++ gcc -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends lua5.2 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends ruby-full -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends sbcl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gawk -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends racket -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends ocaml -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /code
