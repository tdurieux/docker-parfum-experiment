FROM continuumio/miniconda3
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing -qq
RUN apt-get -y --no-install-recommends -qq install software-properties-common dirmngr apt-transport-https lsb-release ca-certificates xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# install node14, see comment at the to of node14source_setup.sh
ADD src/docker/common/node14source_setup.sh /nodesource_setup.sh
RUN ["chmod", "+x", "/nodesource_setup.sh"]
RUN bash nodesource_setup.sh
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install aws-lambda-cpp build dependencies, this is for the post install script in aws-lambda-ric (in package.json)
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  g++ \
  make \
  cmake \
  unzip \
  automake autoconf libtool \
  libcurl4-openssl-dev \
  curl \
  git && rm -rf /var/lib/apt/lists/*;

# Add the lambda emulator for local dev, (see entrypoint.sh for where it's used),
# I have the file locally (gitignored) to speed up build times (as it downloads everytime),
# but you can use the http version of the below ADD command or download it yourself from that url.
ADD src/docker/common/aws-lambda-rie /usr/local/bin/aws-lambda-rie
# ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/download/v1.0/aws-lambda-rie /usr/local/bin/aws-lambda-rie
RUN ["chmod", "+x", "/usr/local/bin/aws-lambda-rie"]

WORKDIR /var/task/
COPY package*.json /var/task/
RUN npm install && npm cache clean --force;
RUN npm install aws-lambda-ric@1.0.0 && npm cache clean --force;

RUN conda --version

# Install CadQuery
RUN conda install -c cadquery -c conda-forge cadquery=master ocp=7.5.2 python=3.8
RUN conda info

# Get a copy of cq-cli from GitHub
RUN git clone https://github.com/CadQuery/cq-cli.git

# Get the distribution copy of cq-cli
RUN apt-get install --no-install-recommends -y libglew2.1 && rm -rf /var/lib/apt/lists/*;

RUN echo "cadhub-concat-split" > /var/task/cadhub-concat-split

# using built javascript from dist
# run `yarn rw build` before bulding this image
COPY dist/docker/cadquery/*.js /var/task/js/
COPY dist/docker/common/*.js /var/task/common/
COPY src/docker/common/entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD [ "js/cadquery.stl" ]
