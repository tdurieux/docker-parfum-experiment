ARG BASE_IMAGE
ARG CODE_PATH
FROM ${BASE_IMAGE}

ARG CODE_PATH

RUN mkdir -p /home/site/wwwroot
COPY ${CODE_PATH} /home/site/wwwroot
ENV AZURE_FUNCTIONS_ENVIRONMENT=Development
RUN pip3 install --no-cache-dir -r /home/site/wwwroot/requirements.txt
