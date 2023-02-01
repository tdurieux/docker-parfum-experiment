FROM dockcross/linux-arm64-lts

ENV DEFAULT_DOCKCROSS_IMAGE mavsdk/mavsdk-dockcross-linux-arm64-custom

RUN apt install --no-install-recommends rubygems -y && rm -rf /var/lib/apt/lists/*;
RUN gem install fpm
