FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y
RUN apt install --no-install-recommends -y mysql-server && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y postgresql && rm -rf /var/lib/apt/lists/*;


USER postgres
RUN service postgresql start && createuser root && createdb root && psql -c "alter user root superuser;" && service postgresql stop
USER root

RUN apt install --no-install-recommends -y python python3 && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python-pip python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

ADD requirement-files /scalyr-agent-2/agent_build/requirement-files

COPY dev-requirements.txt /scalyr-agent-2/dev-requirements.txt

RUN python2 -m pip install -r /scalyr-agent-2/dev-requirements.txt
# We need newer version of pip since old version don't support manylinux wheels
RUN python3 -m pip install --upgrade "pip==21.0"
RUN python3 -m pip --version
RUN python3 -m pip install -r /scalyr-agent-2/dev-requirements.txt

WORKDIR /
