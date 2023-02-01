# Warning: this file is outdated

FROM openjdk:alpine as JolieBuild

# Download and install Jolie. We need it for running the release tools.
RUN apk update
RUN apk add --no-cache git maven
RUN git clone --depth=1 https://github.com/jolie/jolie.git jolie-git
WORKDIR /jolie-git
RUN mvn clean install
RUN cp -avr /jolie-git/dist/jolie/ /usr/lib/jolie/
RUN cp -a /jolie-git/dist/launchers/unix/.  /usr/bin/
ENV JOLIE_HOME /usr/lib/jolie

# Download and use the release tools to generate jolie_installer.jar
WORKDIR /
RUN git clone --depth=1 https://github.com/jolie/release_tools.git
WORKDIR /release_tools/jolie_installer
RUN mvn clean install
WORKDIR /release_tools
RUN apk add --no-cache zip
RUN jolie release.ol ../jolie-git

# Start from scratch, copy the installer, install, remove the installer.
FROM openjdk:jre-alpine
RUN apk add --no-cache zip
WORKDIR /
COPY --from=JolieBuild /release_tools/release/jolie_installer.jar .
RUN java -jar jolie_installer.jar -jh /usr/lib/jolie -jl /usr/bin && rm jolie_installer.jar
ENV JOLIE_HOME /usr/lib/jolie
