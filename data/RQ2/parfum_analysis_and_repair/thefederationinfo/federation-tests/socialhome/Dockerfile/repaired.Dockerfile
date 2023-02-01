FROM python:3

RUN apt-get update
RUN apt-get install --no-install-recommends -y git-core && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/jaywink/socialhome.git
WORKDIR /socialhome

RUN bash install_ubuntu_dependencies.sh install

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip setuptools==30.4 pip-tools
RUN pip-sync dev-requirements.txt

RUN npm install && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;
RUN bower install --allow-root
RUN npm -g install grunt && npm cache clean --force;
RUN npm run build

COPY .env /socialhome/.env
COPY start.sh /start.sh

CMD [ "/bin/bash", "/start.sh" ]
