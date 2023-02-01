##
# Build a base package for augur-core.
#
# The build process is strucutred this way to encourage fail fast behavior so
# that this image's build will fail earlier for compiling contracts than
# for other pieces
FROM augurproject/python2-and-3:latest

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
	&& apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN wget --quiet --output-document /usr/local/bin/solc https://github.com/ethereum/solidity/releases/download/v0.4.20/solc-static-linux \
	&& chmod a+x /usr/local/bin/solc

COPY requirements.txt /app/requirements.txt
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

WORKDIR /app
RUN npm install && npm cache clean --force;

RUN pip2 install --no-cache-dir --upgrade pip setuptools \
	&& pip2 install --no-cache-dir --upgrade pip-tools \
	&& pip2 install --no-cache-dir -r requirements.txt

