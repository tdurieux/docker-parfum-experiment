FROM python:alpine

RUN apk add --no-cache groff less mailcap

LABEL io.whalebrew.name 'formica'
LABEL io.whalebrew.config.environment '["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_SESSION_TOKEN", "AWS_DEFAULT_REGION", "AWS_PROFILE", "AWS_CONFIG_FILE"]'
LABEL io.whalebrew.config.volumes '["~/.aws:/.aws"]'

WORKDIR /formica

COPY ./ ./

RUN pip install --no-cache-dir .

ENTRYPOINT ["formica"]