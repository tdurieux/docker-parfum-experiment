# Unit testing dockerfile (for CI/CD)
FROM node:14.13.1

WORKDIR /usr/src/app

# Install app dependencies
COPY package.json package-lock.json ./

# Install Node Packages
RUN npm install && npm cache clean --force;

# Copying app source
COPY src/ src/

# Copying jest mocks
COPY __mocks__/ __mocks__/

# Copying test suite
COPY test/ test/

# Copying linting configuration (for running the linter)
COPY .eslintrc .
# Copying babel configuration
COPY babel.config.json .
# Copying jest configs (for running the tests)
COPY jest.config.js .

# Copying .env files
COPY .env* ./

CMD ["npm", "run", "ci"]
