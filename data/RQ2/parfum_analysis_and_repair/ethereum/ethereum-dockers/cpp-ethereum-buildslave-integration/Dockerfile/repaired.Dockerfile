FROM cptobvious/buildslave-cpp-develop

RUN apt-get install --no-install-recommends --fix-missing -y xvfb curl && rm -rf /var/lib/apt/lists/*;

# Install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup | sudo bash -
RUN apt-get install --no-install-recommends --fix-missing -y nodejs && rm -rf /var/lib/apt/lists/*;

# RUN wget https://launchpad.net/~ubuntu-mozilla-security/+archive/ubuntu/ppa/+build/6749624/+files/firefox_35.0.1%2Bbuild1-0ubuntu0.14.04.1_amd64.deb
RUN apt-get install --no-install-recommends --fix-missing -y firefox && rm -rf /var/lib/apt/lists/*;
RUN apt-get remove -y firefox
RUN wget https://launchpadlibrarian.net/195802338/firefox_35.0.1%2Bbuild1-0ubuntu0.14.04.1_amd64.deb
RUN dpkg -i firefox_35.0.1+build1-0ubuntu0.14.04.1_amd64.deb
RUN apt-get install -y -f

RUN pip install --no-cache-dir nose nose-html coverage selenium

# Overwrite buildslave config, use .sample file or previously created buildslave config
ADD buildbot.tac slave/buildbot.tac
