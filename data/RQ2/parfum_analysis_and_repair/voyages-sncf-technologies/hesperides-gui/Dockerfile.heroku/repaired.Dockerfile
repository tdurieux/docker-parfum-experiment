# Recipe from: https://stackoverflow.com/a/58204409/636849
FROM hesperides/hesperides-gui

# Quoting Heroku documentation:
# > If you would like to see streaming logs as release phase executes, your Docker image is required to have curl.
USER root
RUN apk add --no-cache curl
USER $UID
