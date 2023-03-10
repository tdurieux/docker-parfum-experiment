# eclipseglsp/ci:uitest
# 1.0
FROM ubuntu:18.04
# Install node & other Theia related dependencies
RUN apt-get update && \
    #Install tools
    apt-get install --no-install-recommends wget gnupg curl make maven git g++-multilib g++-5-multilib libx11-dev libxkbfile-dev libsecret-1-dev -y && \
    #Install node
    curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends nodejs -y && \
    npm install -g yarn && \
    apt-get install --no-install-recommends lsof xvfb -y && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Install chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
