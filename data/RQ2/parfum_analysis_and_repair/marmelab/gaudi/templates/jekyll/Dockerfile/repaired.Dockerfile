FROM stackbrew/debian:wheezy

[[ updateApt ]]
[[ addUserFiles ]]

# Install jekyll
RUN apt-get -y --no-install-recommends --force-yes install ruby1.9.1-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install jekyll execjs therubyracer

ENTRYPOINT ["jekyll"]
