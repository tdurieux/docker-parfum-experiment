FROM registry.lil.tools/library/python:3.9-bullseye
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_SRC=/usr/local/src

# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

# Add Lambda Runtime Interface Emulator and set up the entrypoint script
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/download/v1.5/aws-lambda-rie /usr/local/bin/aws-lambda-rie
COPY entrypoint.sh /
RUN chmod 755 /usr/local/bin/aws-lambda-rie /entrypoint.sh
EXPOSE 8080

# Install Pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/2.14.2/pandoc-2.14.2-1-$(dpkg --print-architecture).deb \
    && dpkg -i pandoc-2.14.2-1-$(dpkg --print-architecture).deb

# Install the python requirements, including the AWS Lambda runtime interface client
COPY function/requirements.txt .
RUN pip install --no-cache-dir pip==21.3.1 \
    && pip install --no-cache-dir -r requirements.txt \
    && rm requirements.txt

# Add the function code
RUN mkdir -p /function
WORKDIR /function
COPY function /function

# Set CMD to the handling function defined in app.py, and via the entrypoint, arrange for
# that function to be run via actual AWS Lambda or via the container's own Lambda runtime emulator,
# whichever is correct for the environment.
CMD [ "app.handler" ]
ENTRYPOINT [ "/entrypoint.sh" ]
