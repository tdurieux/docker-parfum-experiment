FROM debian:bullseye

RUN apt-get update && apt-get install --no-install-recommends -y \
	python3-clang \
	python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

ARG UID=1000
ARG GID=1000

WORKDIR /src

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

USER ${UID}:${GID}
