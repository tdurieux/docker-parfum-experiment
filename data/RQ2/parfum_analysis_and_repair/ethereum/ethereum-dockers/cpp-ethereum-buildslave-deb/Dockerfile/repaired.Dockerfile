FROM cptobvious/buildslave-cpp

RUN apt-get install --no-install-recommends --fix-missing -y cowbuilder ubuntu-dev-tools dh-autoreconf pkg-kde-tools && rm -rf /var/lib/apt/lists/*;

# Overwrite buildslave config, use .sample file or previously created buildslave config
ADD buildbot.tac slave/buildbot.tac
