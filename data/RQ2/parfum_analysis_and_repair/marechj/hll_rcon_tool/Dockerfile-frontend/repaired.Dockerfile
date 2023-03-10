FROM node:15-stretch

WORKDIR /code

RUN apt-get update -y && apt-get install --no-install-recommends -y nginx apache2-utils && rm -rf /var/lib/apt/lists/*;


RUN mkdir /pw

COPY rcongui/package.json package.json
COPY rcongui/package-lock.json package-lock.json

RUN npm ci

ENV REACT_APP_API_URL /api/

COPY rcongui/src/ src/
COPY rcongui/public/ public/


COPY .git/ .git/
RUN npx browserslist@latest --update-db
# Normal build
RUN npm run build

RUN mv /code/build /var/www/
# Public build
ENV REACT_APP_PUBLIC_BUILD on
RUN npm run build
RUN mkdir /var/www_public/
RUN mv /code/build /var/www_public/

RUN rm -rf src/
RUN rm -rf public/
RUN rm -rf node_modules/

COPY rcongui/nginx.conf /etc/nginx/sites-available/default
WORKDIR /var/www

VOLUME /certs
COPY rcongui/entrypoint.sh /code/entrypoint.sh
RUN chmod +x /code/entrypoint.sh

ENTRYPOINT [ "/code/entrypoint.sh" ]
