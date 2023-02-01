FROM ubuntu

RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends dosbox make openssl ca-certificates git && rm -rf /var/lib/apt/lists/*;

WORKDIR /cpputest_build

CMD BUILD=make_dos /cpputest/scripts/travis_ci_build.sh
