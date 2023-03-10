FROM cptobvious/buildslave-go

RUN apt-get install --no-install-recommends --fix-missing -y cowbuilder dh-golang ubuntu-dev-tools && rm -rf /var/lib/apt/lists/*;

# Overwrite buildslave config, use .sample file or previously created buildslave config
ADD buildbot.tac slave/buildbot.tac
