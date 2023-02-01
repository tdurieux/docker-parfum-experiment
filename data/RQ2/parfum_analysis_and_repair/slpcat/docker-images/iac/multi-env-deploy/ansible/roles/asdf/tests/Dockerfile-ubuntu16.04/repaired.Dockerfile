FROM ubuntu:16.04

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq sudo python-apt python-pycurl python-pip python-dev \
                        libffi-dev libssl-dev && \
    pip install --no-cache-dir -U setuptools && \
    pip install --no-cache-dir -q ansible==2.5.1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/ansible-role-asdf
COPY  .  /tmp/ansible-role-asdf

RUN useradd -m vagrant
RUN echo localhost > inventory

RUN ansible-playbook -i inventory -c local tests/playbook.yml

RUN sudo -iu vagrant bash -lc 'asdf --version'
RUN sudo -iu vagrant bash -lc 'elixir --version'
