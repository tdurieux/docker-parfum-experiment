FROM gcr.io/cloud-builders/bazel

RUN apt-get update && apt-get install --no-install-recommends -y \
        zip \
	libxml2-dev \
	build-essential && rm -rf /var/lib/apt/lists/*;

