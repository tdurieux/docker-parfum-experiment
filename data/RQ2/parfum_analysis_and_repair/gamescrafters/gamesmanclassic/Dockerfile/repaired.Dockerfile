FROM python

RUN apt-get update -y && apt-get install --no-install-recommends git build-essential autoconf zlib1g-dev tcl-dev tk-dev -y && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/GamesCrafters/GamesmanClassic.git
WORKDIR GamesmanClassic

RUN autoconf && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make

CMD cd bin && ./XGamesman.new
