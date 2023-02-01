FROM jetbrains/teamcity-agent:2021.2-linux-sudo
RUN sudo apt-get update -yq && \
 sudo apt-get install --no-install-recommends bsdmainutils -yq && \
 sudo apt-get install --no-install-recommends tree -yq && \
 sudo apt-get install --no-install-recommends openjdk-8-jdk -yq && \
 sudo apt-get install --no-install-recommends openjdk-17-jdk -yq && \
 sudo apt-get install --no-install-recommends binutils -yq && \
 sudo apt-get install --no-install-recommends lsof -yq && \
 sudo apt-get install --no-install-recommends curl -yq && rm -rf /var/lib/apt/lists/*;
