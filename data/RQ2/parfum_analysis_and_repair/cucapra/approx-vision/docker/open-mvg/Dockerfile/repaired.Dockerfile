FROM freakthemighty/openmvg
WORKDIR /root

# Install basics
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	git \
	cmake \
	wget \
	python && rm -rf /var/lib/apt/lists/*;

# Clone benchmark
RUN git clone https://github.com/mbuckler/SfM_quality_evaluation.git

# Install vim for my sanity
RUN apt-get install --no-install-recommends vim -y && rm -rf /var/lib/apt/lists/*;

# Re-set working directory
WORKDIR /root/SfM_quality_evaluation
