FROM debian

ENV BUILD_DEPS $(perl -ne 'next if /^#/; $p=(s/^Build-Depends:\s*/ / or (/^ / and $p)); s/,|\n|\([^)]+\)//mg; print if $p' < debian/control)

RUN apt-get update && apt-get install --no-install-recommends -y $BUILD_DEPS devscripts && rm -rf /var/lib/apt/lists/*;

CMD ['make']

