FROM cumuluss/cumulus-build-env:build
RUN mkdir -p uncached && cd uncached && git clone https://github.com/nasa/cumulus && cd -
RUN git clone https://github.com/nasa/cumulus && \
  cd cumulus && npm install --no-package-lock && \
  npx lerna bootstrap --no-ci --force-local --ignore-scripts && \
  rm -Rf ./example/node_modules && npm cache clean --force;
RUN pip install --no-cache-dir pipenv

