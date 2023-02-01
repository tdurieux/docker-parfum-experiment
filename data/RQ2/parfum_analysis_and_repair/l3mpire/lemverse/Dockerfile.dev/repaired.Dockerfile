FROM geoffreybooth/meteor-base:2.7.3
# Disney Meteor base image

# Copy app package.json and package-lock.json into container
COPY ./public/app/package*.json $APP_SOURCE_FOLDER/

RUN bash $SCRIPTS_FOLDER/build-app-npm-dependencies.sh

# Copy app source into container
COPY ./public/app $APP_SOURCE_FOLDER/
RUN apt update && apt install --no-install-recommends -y \
		bash \
		ca-certificates \
        imagemagick \
        graphicsmagick \
        python3 make g++ && rm -rf /var/lib/apt/lists/*;


WORKDIR $APP_SOURCE_FOLDER

CMD ["meteor", "--unsafe-perm", "--settings", "settings-dev.json", "--port", "9000"]
