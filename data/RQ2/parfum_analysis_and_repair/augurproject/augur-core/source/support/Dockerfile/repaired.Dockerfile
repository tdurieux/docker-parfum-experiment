##
# Build a base package for augur-core.
#
# The build process is structured this way to encourage fail fast behavior so
# that this image's build will fail earlier for compiling contracts than
# for other pieces
FROM augurproject/python2-and-3:latest
ARG SOLC_VERSION=v0.4.20

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
	&& apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN wget --quiet --output-document /usr/local/bin/solc https://github.com/ethereum/solidity/releases/download/${SOLC_VERSION}/solc-static-linux \
	&& chmod a+x /usr/local/bin/solc

COPY requirements.txt /app/requirements.txt

WORKDIR /app
RUN pip2 install --no-cache-dir --upgrade pip setuptools \
	&& pip2 install --no-cache-dir --upgrade pip-tools \
	&& pip2 install --no-cache-dir -r requirements.txt

# Install basics of the application
COPY .soliumrc.json /app/.soliumrc.json
COPY .soliumignore /app/.soliumignore
COPY tsconfig.json /app/tsconfig.json
COPY typings/ /app/typings/
COPY source/contracts/ /app/source/contracts/
COPY source/deployment/compileContracts.ts /app/source/deployment/compileContracts.ts
COPY source/libraries/CompilerConfiguration.ts /app/source/libraries/CompilerConfiguration.ts
COPY source/libraries/DeployerConfiguration.ts /app/source/libraries/DeployerConfiguration.ts
COPY source/libraries/NetworkConfiguration.ts /app/source/libraries/NetworkConfiguration.ts
COPY source/libraries/ContractCompiler.ts /app/source/libraries/ContractCompiler.ts
COPY source/tools/installSolidityFlattener /app/source/tools/installSolidityFlattener
COPY package.json /app/package.json

RUN npm install && npm cache clean --force;

# Lint
RUN npm run lint

# Build first chunk
RUN npm run build:source
RUN npm run build:flattener
RUN npm run build:contracts

COPY source/libraries/ContractInterfacesGenerator.ts /app/source/libraries/ContractInterfacesGenerator.ts
COPY source/tools/generateContractInterfaces.ts /app/source/tools/generateContractInterfaces.ts

# Build contract interfaces
RUN npm run build:source
RUN npm run build:interfaces

# Copy source
COPY source/ /app/source/
COPY tests/ /app/tests/

# Copy the git info so ContractDeployer can read the hash on deploy
RUN npm run build:source
COPY .git/ /app/.git/

ENTRYPOINT ["npm"]
