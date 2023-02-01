FROM node:14.15.4-alpine3.12
RUN npm install -g @angular/cli@11.2.14 && npm cache clean --force;
RUN ng new okta-app --routing
WORKDIR okta-app

RUN npm i rxjs && npm cache clean --force;
RUN npm install @angular/router && npm cache clean --force;
RUN npm i @angular/common && npm cache clean --force;

RUN npm install @okta/okta-signin-widget && npm cache clean --force;
WORKDIR ../

ADD . / okta-angular/

WORKDIR okta-angular
RUN rm -rf node_modules
RUN yarn install && yarn cache clean;
RUN yarn build
RUN yarn link && yarn cache clean;
WORKDIR ../
WORKDIR okta-app
RUN yarn install && yarn cache clean;
RUN yarn link @okta/okta-angular && yarn cache clean;


COPY /test/selenium-test/sign-in-widget/app.module.ts /okta-app/src/app
COPY /test/selenium-test/sign-in-widget/app.component.html /okta-app/src/app
COPY /test/selenium-test/sign-in-widget/app.component.ts /okta-app/src/app
COPY /test/selenium-test/sign-in-widget/protected.component.ts /okta-app/src/app
COPY /test/selenium-test/sign-in-widget/login.component.ts /okta-app/src/app
COPY /test/selenium-test/tsconfig.json /okta-app
COPY environment.ts /okta-app/src/environments