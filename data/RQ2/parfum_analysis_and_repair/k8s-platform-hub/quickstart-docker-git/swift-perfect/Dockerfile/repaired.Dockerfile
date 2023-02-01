FROM swift

RUN apt-get update && apt-get install --no-install-recommends -y openssl libssl-dev uuid-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /swift-perfect
ADD . /swift-perfect
RUN swift build

CMD .build/debug/swift-perfect


