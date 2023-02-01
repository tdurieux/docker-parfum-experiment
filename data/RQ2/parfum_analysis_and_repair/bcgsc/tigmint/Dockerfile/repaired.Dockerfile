FROM linuxbrew/linuxbrew
LABEL maintainer="Shaun Jackman <sjackman@gmail.com>"

WORKDIR /home/linuxbrew/tigmint
ADD . .
RUN sudo chown -R linuxbrew: . \
	&& brew bundle \
	&& rm -rf /home/linuxbrew/.cache \
	&& pip3 install --no-cache-dir cython git+https://github.com/daler/pybedtools.git \
	&& pip3 install --no-cache-dir -r requirements.txt
ENV PATH="/home/linuxbrew/tigmint/bin:$PATH"
