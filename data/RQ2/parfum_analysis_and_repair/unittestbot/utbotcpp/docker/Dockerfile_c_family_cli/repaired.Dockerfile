FROM ubuntu:bionic-20220531

ARG ACCESS_TOKEN

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential \
        software-properties-common \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install --no-install-recommends -y gcc-9 \
        g++-9 \
        curl \
        unzip \
        python3 \
        python3-requests \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 \
    && update-alternatives --config gcc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/

# Install UTBot C/C++ CLI
COPY docker/get_c_family_cli_download_url.py .

ENV C_FAMILY_CLI_ZIP_NAME "utbot_distr.zip"

RUN curl -f -H "Authorization: Bearer ${ACCESS_TOKEN}" \
        -L $(python3 get_c_family_cli_download_url.py) \
        -o "${C_FAMILY_CLI_ZIP_NAME}" \
    && unzip -q "${C_FAMILY_CLI_ZIP_NAME}" \
    && find . ! -name 'utbot_distr.tar.gz' -type f -exec rm -f {} + \
    && mkdir utbot-cli \
    && tar -xf utbot_distr.tar.gz -C utbot-cli \
    && chmod +x utbot-cli/utbot_distr/utbot_online_cli.sh \
    && chmod +x utbot-cli/utbot_distr/utbot_run_system.sh && rm utbot_distr.tar.gz
