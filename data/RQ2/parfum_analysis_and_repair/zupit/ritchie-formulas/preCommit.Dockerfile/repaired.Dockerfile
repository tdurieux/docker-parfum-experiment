FROM circleci/python:3.8.5

USER root

RUN mkdir /app
WORKDIR /app

RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y default-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y shellcheck && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pre-commit

ENTRYPOINT ["pre-commit", "run", "--all-files"]
