FROM node:12.2.0

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential git curl libfontconfig && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends nodejs-legacy -y && rm -rf /var/lib/apt/lists/*;
RUN npm install -g @angular/cli@7.3.9 && npm cache clean --force;

RUN mkdir /code

# Copy codebase
COPY . /code

WORKDIR /code
RUN npm install && npm cache clean --force;
RUN npm audit fix

EXPOSE 8888

CMD ["ng","serve", "--host", "0.0.0.0"]
