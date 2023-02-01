FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y \
  bash git curl unzip wget axel telnet && rm -rf /var/lib/apt/lists/*;

# create user
ENV user=fluter
RUN useradd -ms /bin/bash ${user}
USER ${user}
WORKDIR /home/${user}

# extract source
RUN git clone https://github.com/flutter/flutter.git -b alpha
ENV PATH=$PWD/flutter/bin:$PATH

RUN flutter doctor
