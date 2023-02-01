# --- build stereofy static binary

FROM debian:10 as stereofy

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libsndfile-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code
COPY ./_sandbox/stereofy /code
WORKDIR /code/
RUN make clean && make

# --- main Freesound docker file contents

FROM freesound:2020-02

# Install specific dependencies needed for processing, building static files and for ssh
RUN wget -q -O - https://deb.nodesource.com/setup_14.x | bash - && apt-get update \
	&& apt-get install -y --no-install-recommends \
		sndfile-programs \
		libsndfile1-dev \
		libasound2-dev \
		mplayer \
		lame \
		vorbis-tools \
		flac \
		faad \
		libjpeg-dev \
		zlib1g-dev \
		libpng-dev \
		libyaml-dev \
		nodejs \
		ffmpeg \
		openssh-client \
		rsync \
	&& rm -rf /var/lib/apt/lists/*

# Make some folders to add code and data
RUN mkdir /code
RUN mkdir /freesound-data
WORKDIR /code

# Copy  stereofy binary
COPY --from=stereofy /code/stereofy /usr/local/bin

# Install python dependencies
COPY --chown=fsweb:fsweb requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir -r /code/requirements.txt

# Copy source code
COPY --chown=fsweb:fsweb . /code
