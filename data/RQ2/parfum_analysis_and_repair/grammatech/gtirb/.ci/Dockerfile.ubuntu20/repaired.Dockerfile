FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

# Install apt packages
RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install autoconf build-essential clang clang-format cmake curl \
        default-jdk doxygen elpa-paredit emacs-nox git graphviz libprotobuf-dev \
        libprotoc-dev libtool libboost-dev maven protobuf-compiler python3 \
        python3-pip python3-setuptools python3-venv wget \
        software-properties-common sbcl slime && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip mypy mypy-protobuf pre-commit

# The default version of maven from the ubuntu repositories contains a bug that
# causes warnings about illegal reflective accesses.  The build on apache's
# website fixes this bug, so we use that build instead.  On focal, we get
# version 3.6.3.
RUN wget https://www.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
RUN tar xf /tmp/apache-maven-*.tar.gz -C /opt && rm /tmp/apache-maven-*.tar.gz
RUN update-alternatives --install /usr/bin/mvn mvn /opt/apache-maven-3.6.3/bin/mvn 363

# Install the lisp-format pre-commit format checker.
RUN curl -f https://raw.githubusercontent.com/eschulte/lisp-format/master/lisp-format > /usr/bin/lisp-format
RUN chmod +x /usr/bin/lisp-format
RUN echo "(add-to-list 'load-path \"/usr/share/emacs/site-lisp/\")" > /root/.lisp-formatrc

# Setup pre-commit
WORKDIR /build/git-repo
RUN git init
COPY .pre-commit-config.yaml .
RUN pre-commit install-hooks

WORKDIR /
RUN rm -rf /build/git-repo
