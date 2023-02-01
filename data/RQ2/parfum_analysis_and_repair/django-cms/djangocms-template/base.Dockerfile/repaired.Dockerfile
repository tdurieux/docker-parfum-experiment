FROM divio/base:2.1-py3.9-slim-buster


RUN apt update --quiet
RUN apt install --no-install-recommends --yes \

    git gnupg2 apt-transport-https \
    fish \
    nano \

    gcc build-essential autoconf \

    libpng-dev \

    libpq-dev && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir --upgrade pip
RUN apt --yes upgrade


# yarn
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update --quiet && apt-get install --no-install-recommends --yes yarn nodejs && rm -rf /var/lib/apt/lists/*;


# fish
RUN usermod -s /usr/bin/fish root
RUN curl -f -L https://get.oh-my.fish > fish-install
RUN fish fish-install --noninteractive --yes
