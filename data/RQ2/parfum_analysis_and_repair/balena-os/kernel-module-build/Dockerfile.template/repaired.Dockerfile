FROM balenalib/%%BALENA_MACHINE_NAME%%-ubuntu-python:3.8.13-impish

RUN install_packages \
    curl \
    wget \
    build-essential \
    libelf-dev \
    awscli \
    bc \
    flex \
    libssl-dev \
    bison


COPY . /usr/src/app

WORKDIR /usr/src/app

ENV VERSION '2.88.4.prod'

RUN BALENA_MACHINE_NAME=%%BALENA_MACHINE_NAME%% ./build.sh build --device %%BALENA_MACHINE_NAME%% --os-version "$VERSION" --src example_module

CMD [ "/usr/src/app/run.sh" ]