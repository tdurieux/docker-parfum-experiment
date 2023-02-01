FROM python:3.6-alpine
ARG version
RUN pip install --no-cache-dir tap-salesforce==${version}
WORKDIR /app
CMD ["tap-salesforce"]
