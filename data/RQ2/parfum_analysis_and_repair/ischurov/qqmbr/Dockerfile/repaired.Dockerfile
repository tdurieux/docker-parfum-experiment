FROM ubuntu:latest
MAINTAINER Ilya Schurov <ilya@schurov.com>

RUN apt-get -qq update
RUN ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends -qq nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends -qq git vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends -qq gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq --no-install-recommends -y install curl bzip2 && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh
RUN bash /tmp/miniconda.sh -bfp /usr/local
RUN rm -rf /tmp/miniconda.sh
RUN conda install -y python=3
RUN conda update conda
RUN conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH

RUN pip install --no-cache-dir --upgrade pip
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN pip install --no-cache-dir beautifulsoup4 lxml
RUN conda install numpy scipy

RUN pip install --no-cache-dir indentml yattag mako fuzzywuzzy flask beautifulsoup4 \
    frozen-flask python-Levenshtein plotly
RUN pip install --no-cache-dir git+https://github.com/matplotlib/matplotlib.git
RUN pip install --no-cache-dir celluloid
RUN useradd -m user
USER user
WORKDIR /home/user
RUN mkdir -p qqmbr/third-party
WORKDIR qqmbr/third-party
RUN npm install mathjax-node-page@1.4.0 && npm cache clean --force;
WORKDIR /home/user/qqmbr
RUN mkdir -p qqmbr/assets/js
RUN cp -r third-party/node_modules/mathjax qqmbr/assets/js

COPY ./ ./
RUN python setup.py develop --user
ENV PATH ~/.local/bin:$PATH

RUN mkdir /home/user/thebook
WORKDIR /home/user/thebook

ENV LC_ALL='C.UTF-8'

ENTRYPOINT ["/home/user/.local/bin/qqmathbook"]

