FROM gitpod/workspace-full
SHELL ["/bin/bash", "-c"]

RUN sudo apt-get -qq update
# Install required libraries for Projector + PhpStorm
RUN sudo apt-get -qq --no-install-recommends install -y python3 python3-pip libxext6 libxrender1 libxtst6 libfreetype6 libxi6 telnet netcat && rm -rf /var/lib/apt/lists/*;
# Install Projector
RUN pip3 install --no-cache-dir projector-installer
# Install PhpStorm
RUN mkdir -p ~/.projector/configs  # Prevents projector install from asking for the license acceptance
RUN projector install 'PhpStorm 2021.1.4' --no-auto-run

# Install ddev
RUN brew update && brew install drud/ddev/ddev && mkcert -install
