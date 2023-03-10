FROM python:alpine

LABEL io.whalebrew.name 'formica'
LABEL io.whalebrew.config.environment '["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_SESSION_TOKEN", "AWS_DEFAULT_REGION", "AWS_DEFAULT_PROFILE", "AWS_PROFILE", "AWS_CONFIG_FILE"]'
LABEL io.whalebrew.config.volumes '["~/.aws:/.aws"]'

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir formica-cli

ENTRYPOINT ["formica"]
