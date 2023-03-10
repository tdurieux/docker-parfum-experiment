FROM cypress/browsers

WORKDIR /usr/src

RUN npm install --force-only @s-ui/test-e2e && npm cache clean --force;

ENTRYPOINT ["npx", "sui-test-e2e"]
