FROM phusion/passenger-full

# Set correct environment variables.
ENV HOME /root
WORKDIR /home/app
VOLUME /config

COPY . /home/app

# Farcy + Python linters
RUN mkdir /root/.config && \
    ln -sf /config /root/.config/farcy && \
    curl -f https://bootstrap.pypa.io/get-pip.py | python3 && \
    apt-get update && \
    apt-get install --no-install-recommends -y python3-dev libffi-dev && \
    pip3 install --no-cache-dir .[python] && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ESLint
RUN npm install -g eslint babel-eslint eslint-plugin-react eslint-config-airbnb && npm cache clean --force;

# Rubocop and SCSS-Lint
RUN gem install rubocop scss_lint

CMD ["farcy"]
