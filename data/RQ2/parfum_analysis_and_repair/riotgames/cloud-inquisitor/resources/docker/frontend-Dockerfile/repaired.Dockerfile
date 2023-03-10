FROM node:8.9
RUN cd /tmp \
    && mkdir -p /frontend/dist \
    && curl -f -L https://releases.cloud-inquisitor.io/cinq-frontend-latest.tar.gz > frontend.tar.gz \
    && tar -xvf frontend.tar.gz -C /frontend/dist \
    && cd / \
    && npm install -g serve && npm cache clean --force; && rm frontend.tar.gz
CMD cd /frontend \
    && if [ -r package.json ]; then npm i; npm rebuild node-sass; ./node_modules/gulp/bin/gulp.js dev & fi \
    && serve -p 3000 -s /frontend/dist

