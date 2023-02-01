# This Dockerfile builds the image used in Cloud Build CI to run 'make test'.
# To push a new image, run 'gcloud builds submit --project=cloud-eng-council --tag gcr.io/cloud-eng-council/make .'
# from this directory.

FROM python:3.8-slim

# install core tools
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# install yapf
RUN pip install --no-cache-dir yapf
RUN pip3 install --no-cache-dir yapf
RUN pip3 install --no-cache-dir flake8

# install golang (+gofmt)
RUN apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;

# Install nodejs (for gts)

RUN apt-get install --no-install-recommends -y wget nodejs && rm -rf /var/lib/apt/lists/*;

# installing npm 6.12.0
RUN wget https://github.com/npm/cli/archive/v6.12.0.tar.gz
RUN tar xf v6.12.0.tar.gz && rm v6.12.0.tar.gz
WORKDIR cli-6.12.0
RUN make install

RUN npm install gts && npm cache clean --force;

# Install java + google-java-format jar
RUN apt-get install --no-install-recommends -y default-jdk && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/google/google-java-format/releases/download/google-java-format-1.7/google-java-format-1.7-all-deps.jar --directory-prefix=/usr/share/java/

# install bash linter
RUN apt-get install --no-install-recommends -y shellcheck && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["make"]
