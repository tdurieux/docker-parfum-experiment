FROM ruby:3.1
ENV LANG C.UTF-8
RUN apt-get update \
  ; apt-get install --no-install-recommends -y wget texlive-base \
  ; rm -rf /var/lib/apt/lists/*; wget -q https://github.com/jgm/pandoc/releases/download/2.18/pandoc-2.18-1-amd64.deb \
  ; apt-get install -y --no-install-recommends ./pandoc-2.18-1-amd64.deb \
  ; useradd -ms /bin/bash paru-user
USER paru-user
SHELL ["/bin/bash", "-l", "-c"]
COPY . /home/paru-user/
WORKDIR /home/paru-user
RUN gem install bundler \
  ; bundler install
