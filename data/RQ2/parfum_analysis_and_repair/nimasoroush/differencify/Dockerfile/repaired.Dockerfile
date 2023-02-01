FROM nimasoroush/differencify
RUN mkdir ./differencify
WORKDIR ./differencify
COPY ./package.json ./package-lock.json ./.eslintrc ./.eslintignore ./.babelrc ./
RUN npm install && npm cache clean --force;
COPY ./src ./src
VOLUME ./src/integration.tests:/differencify/src/integration.tests