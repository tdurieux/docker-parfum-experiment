ARG BASE_IMAGE

# hadolint ignore=DL3006
FROM ${BASE_IMAGE}

CMD ["bash", "-c", "./manage.py migrate --no-input && ./manage.py collectstatic --no-input"]