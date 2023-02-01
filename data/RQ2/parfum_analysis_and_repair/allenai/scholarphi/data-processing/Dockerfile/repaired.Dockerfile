FROM ubuntu:bionic

RUN apt-get update

# Set DEBIAN_FRONTEND to disable tzdatainteractive dialogue
ARG DEBIAN_FRONTEND=noninteractive

# Install Perl
# Build-essential is required for installing Perl dependencies
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
# Old version (e.g., 5.22) needed to support TeX::AutoTeX
# Perl installation will take a very long time.
# Skip running tests for Perl 5.22.5, as version 5.22.4 has a couple minor test failures.
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN cpan App::perlbrew
RUN perlbrew init
RUN perlbrew --notest install perl-5.22.4
RUN perlbrew install-cpanm

# Install LaTeX suite
# This download will take an extremely long time to install, so we install it first
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://arxiv-web-static1.s3.amazonaws.com/semantic_scholar_20210412/arXivTeXLive2020.tar.gz
RUN tar -xf arXivTeXLive2020.tar.gz && rm arXivTeXLive2020.tar.gz
RUN echo "I" | perl 2020/install-tl
RUN rm -r arXivTeXLive2020.tar.gz 2020

# Install Perl dependencies
SHELL ["/bin/bash", "-c"]
RUN source ~/perl5/perlbrew/etc/bashrc \
  && perlbrew use perl-5.22.4 \
  && cpanm TeX::AutoTeX

# Install Postgres
RUN apt-get install --no-install-recommends -y postgresql && rm -rf /var/lib/apt/lists/*;

# Install Python
RUN apt-get install --no-install-recommends -y python3.7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-distutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3.7-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN python get-pip.py --force-reinstall

# Install Node.js
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Let ImageMagick to read and write PDFs
RUN apt-get install --no-install-recommends -y imagemagick imagemagick-6-common imagemagick-6.q16 \
  libmagick++-6.q16-7 libmagickcore-6.q16-3 libmagickcore-6.q16-3-extra libmagickwand-6.q16-3 && rm -rf /var/lib/apt/lists/*;
RUN sed -i '/pattern="PDF"/s/rights="none"/rights="read | write"/' /etc/ImageMagick-6/policy.xml

# Install GhostScript
RUN apt-get install --no-install-recommends -y ghostscript && rm -rf /var/lib/apt/lists/*;

# Install Node.js dependencies
WORKDIR /data-processing/node
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
COPY node/package*.json ./
RUN npm install && npm cache clean --force;
# As KaTeX is undegoing rapid changes, install it from sources
RUN npm install -g yarn && npm cache clean --force;
RUN npm run prepare-katex
RUN npm run install-katex

# Install vim for when we inevitably want to inspect files
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

# Install pip requireements
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy over the source code
WORKDIR /data-processing
COPY . .

# Set up path to include Python scripts
ENV PYTHONPATH="/data-processing"
