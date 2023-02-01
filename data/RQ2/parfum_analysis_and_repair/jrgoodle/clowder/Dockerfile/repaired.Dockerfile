# Dockerfile for clowder project tests
FROM python:3.8.5

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH
ENV PYTHONPATH $PYTHONPATH:/clowder

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

COPY build/ssh /root/.ssh

# Update package list
RUN apt-get update -y

# Install netstat and route
RUN apt-get install --no-install-recommends net-tools -y && rm -rf /var/lib/apt/lists/*;

# Install git
RUN apt-get install --no-install-recommends python-dev -y && rm -rf /var/lib/apt/lists/*;

# Install git-lfs
RUN curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get install -y --no-install-recommends git-lfs && rm -rf /var/lib/apt/lists/*;

# Set up git config
RUN git config --global user.email "joe@polka.cat"
RUN git config --global user.name "Clowder Docker"
RUN git config --global push.default simple
RUN git config --system --unset-all filter.lfs.clean
RUN git config --system --unset-all filter.lfs.smudge
RUN git config --system --unset-all filter.lfs.process
RUN git config --system --unset-all filter.lfs.required

# Install pipenv
RUN pip install --no-cache-dir -U pipenv

CMD ["/usr/bin/env bash"]
