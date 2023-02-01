from ubuntu
MAINTAINER Michael Bartling "michael.bartling15@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-pip \
    gcc-arm-none-eabi \
    git \
    mercurial \
    vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir mbed-cli 'colorama<0.4.0,>=0.3.9' pyserial prettytable jinja2 intelhex junit_xml pyyaml requests mbed_ls mbed_host_tests mbed_greentea beautifulsoup4 fuzzywuzzy pyelftools jsonschema future six manifest_tool mbed_cloud_sdk icetea

