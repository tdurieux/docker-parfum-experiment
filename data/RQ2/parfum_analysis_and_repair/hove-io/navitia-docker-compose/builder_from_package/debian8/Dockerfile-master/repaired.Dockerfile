FROM navitia/debian8_dev

# update package list from providers
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y postgresql-client \
                        netcat \
                        curl && rm -rf /var/lib/apt/lists/*; # upgrade installed packages
RUN  apt-get upgrade -y

# install postgresql-client for tyr-beat
#         netcat for kraken
#         curl for jormun




