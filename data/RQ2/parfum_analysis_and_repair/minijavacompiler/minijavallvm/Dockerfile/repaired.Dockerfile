FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y \
            default-jdk \
            default-jre \
            ant-contrib \
            astyle \
            wget \
            git && rm -rf /var/lib/apt/lists/*; #Need these before running ant deps







RUN adduser --disabled-password --gecos '' mjc
ADD . /project
RUN chown -R mjc:mjc /project

WORKDIR /project
RUN ant deps
USER mjc
RUN ant clean
RUN ant test
