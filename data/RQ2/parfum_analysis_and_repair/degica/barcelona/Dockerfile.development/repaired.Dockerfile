FROM degica/rails-buildpack:2.6

ARG UID=1000
ARG APP_HOME

RUN useradd --uid $UID --user-group --create-home app
RUN mkdir -p $APP_HOME && chown -R app:app $APP_HOME
RUN ln -s -f /app $APP_HOME

RUN apt-get install -y openssh-client --no-install-recommends && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
RUN rm -rf $APP_HOME && ln -s /app $APP_HOME
ENV PATH=/app/bin:$PATH
ENV HOME=/home/app

USER app
