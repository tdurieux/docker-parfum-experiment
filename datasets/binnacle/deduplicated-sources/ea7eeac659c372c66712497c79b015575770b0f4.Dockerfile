FROM python:3.6.1

ENV LT_ROOT /opt/lt
ENV LT /opt/lt/LanguageTool-4.4
ENV DIR /opt/dev
ENV DIR_TMT_GIT /opt/dev/tm-git

RUN apt-get update && apt-get install python3-dev libhunspell-dev gettext zip vim -y
RUN mkdir -p $DIR

# LanguageTool
RUN echo "deb http://http.debian.net/debian jessie-backports main" | tee --append /etc/apt/sources.list.d/jessie-backports.list > /dev/null
RUN apt-get update
RUN apt-get install -t jessie-backports openjdk-8-jdk -y
RUN mkdir -p $LT_ROOT
WORKDIR $LT_ROOT
RUN wget -q https://languagetool.org/download/LanguageTool-4.4.zip && unzip LanguageTool-4.4.zip

#Pology
RUN apt-get install cmake -y
RUN wget -q http://pology.nedohodnik.net//release/pology-0.12.tar.bz2
RUN tar xvjf pology-0.12.tar.bz2
WORKDIR pology-0.12
RUN mkdir build && cd build && cmake .. && make && make install
 
WORKDIR $DIR
RUN git clone --recursive https://github.com/Softcatala/translation-memory-tools.git $DIR_TMT_GIT 
RUN git clone https://github.com/Softcatala/web-2015.git

WORKDIR $DIR_TMT_GIT
RUN git submodule update --remote

RUN pip install -r requirements.txt

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
ENV PATH /root/.rbenv/bin:/root/.rbenv/shims:$PATH

RUN rbenv init -
RUN rbenv install 2.3.4
RUN rbenv global 2.3.4
RUN gem install i18n-translators-tools

# Locale ca-ES
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# ca_ES.UTF-8 UTF-8/ca_ES.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales

WORKDIR $DIR_TMT_GIT/cfg/projects
WORKDIR $DIR_TMT_GIT/src

# What get's executed on Run
ENTRYPOINT bash $DIR_TMT_GIT/docker/docker-builder-run.sh $DIR $DIR_TMT_GIT $LT
