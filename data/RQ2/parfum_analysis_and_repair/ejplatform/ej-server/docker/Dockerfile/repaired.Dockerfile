FROM python:3.7.10
ARG tag
ARG env
# Install debian dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    gcc \
    git \
    ruby-sass \
    gnupg2 \
    libc6-dev \
    libdpkg-perl \
    make \
    gettext && rm -rf /var/lib/apt/lists/*;
# Move ej nginx conf to nginx volume
RUN touch /etc/apt/preferences.d/nodejs && \
    echo "Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 1001" > /etc/apt/preferences.d/nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install --no-install-recommends nodejs -y && npm install -g yarn webpack@4.6.0 && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
COPY ./ /ej-server
WORKDIR ej-server
RUN pip install --no-cache-dir poetry
RUN poetry install
