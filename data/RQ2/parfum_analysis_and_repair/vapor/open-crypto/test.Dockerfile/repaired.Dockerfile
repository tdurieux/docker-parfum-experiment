FROM swift:5.0-bionic
COPY Sources/ Sources/
COPY Tests/ Tests/
COPY Package.swift Package.swift
RUN apt-get -y --no-install-recommends install openssl libssl-dev && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT swift build -v
