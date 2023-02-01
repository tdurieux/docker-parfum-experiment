ARG BASE_IMAGE
FROM ${BASE_IMAGE} as build

RUN apt --fix-missing update
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;