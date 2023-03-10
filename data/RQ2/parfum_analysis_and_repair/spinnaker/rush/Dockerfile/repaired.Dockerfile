FROM java:8

MAINTAINER delivery-engineering@netflix.com

COPY . workdir/

WORKDIR workdir

RUN GRADLE_USER_HOME=cache ./gradlew buildDeb -x test

RUN dpkg -i ./build/distributions/*.deb

RUN mkdir /packer

WORKDIR /packer

RUN wget https://releases.hashicorp.com/packer/0.10.0/packer_0.10.0_linux_amd64.zip

RUN apt-get install --no-install-recommends unzip -y && rm -rf /var/lib/apt/lists/*;

RUN unzip packer_0.10.0_linux_amd64.zip

ENV PATH "/packer:$PATH"

CMD ["/opt/rush/bin/rush"]
