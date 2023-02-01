FROM ruby:2.7-bullseye

ENV DOCKER 1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
    elinks \
    ghostscript \
    libmagic-dev \
    pdftk \
    poppler-utils \
    postgresql-client \
    sendmail \
    tnef \
    unrtf \
    mutt && rm -rf /var/lib/apt/lists/*;

# Wait-for-it
RUN git clone https://github.com/vishnubob/wait-for-it.git /tmp/wait-for-it && \
    chmod +x /tmp/wait-for-it/wait-for-it.sh && \
    ln -s /tmp/wait-for-it/wait-for-it.sh /bin/wait-for-it

WORKDIR /alaveteli/
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && rm -rf /root/.gem;
RUN gem install mailcatcher

EXPOSE 3000
EXPOSE 1080
CMD wait-for-it db:5432 --strict -- ./docker/entrypoint.sh
