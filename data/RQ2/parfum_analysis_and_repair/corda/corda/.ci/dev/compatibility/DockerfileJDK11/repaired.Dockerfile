FROM azul/zulu-openjdk:11.0.14
RUN apt-get update && apt-get install --no-install-recommends -y curl apt-transport-https \
                                              ca-certificates \
                                              curl \
                                              gnupg2 \
                                              software-properties-common \
                                              wget && rm -rf /var/lib/apt/lists/*;
ARG USER="stresstester"
RUN useradd -m ${USER}
