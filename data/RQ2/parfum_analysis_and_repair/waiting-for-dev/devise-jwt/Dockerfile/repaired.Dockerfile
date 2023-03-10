FROM ruby:3.0.0
ENV APP_USER devise_jwt_user
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash $APP_USER
USER $APP_USER
WORKDIR /home/$APP_USER/app
