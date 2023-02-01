FROM cypress/base:12

COPY . /workbench/tests-cypress/

WORKDIR /workbench/tests-cypress/

RUN npm install && npm install --save-dev cypress && npm cache clean --force;

CMD ["npm", "test"]
