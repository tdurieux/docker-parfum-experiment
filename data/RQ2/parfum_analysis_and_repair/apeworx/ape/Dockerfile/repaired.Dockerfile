FROM ubuntu:20.04
RUN apt-get update && apt-get upgrade --yes && apt-get install --no-install-recommends git python3.8 python3-pip --yes && rm -rf /var/lib/apt/lists/*;
ADD . /code
WORKDIR /code

# need to use typing-extensions<4 to deal with issue 387 bug: Docker will not build
# TODO: Figure out a better solution or wait for it to resolve itself.
RUN pip install --no-cache-dir typing-extensions==3.10.0.2
RUN pip install --no-cache-dir .[recommended-plugins]
ENTRYPOINT ["ape"]
