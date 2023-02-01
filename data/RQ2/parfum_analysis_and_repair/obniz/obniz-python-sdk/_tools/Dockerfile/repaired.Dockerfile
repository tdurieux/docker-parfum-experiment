FROM python:3
USER root

RUN apt-get update
RUN apt-get -y --no-install-recommends install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

RUN apt-get install --no-install-recommends -y vim less && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade setuptools
RUN pip install --no-cache-dir pipenv