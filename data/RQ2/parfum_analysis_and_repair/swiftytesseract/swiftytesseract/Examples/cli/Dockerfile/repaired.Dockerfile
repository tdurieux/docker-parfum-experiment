FROM swiftlang/swift:5.3-focal

RUN apt-get update && \
    apt-get install --no-install-recommends -yq libtesseract-dev libleptonica-dev && \
    mkdir -p /usr/src/swiftytesseract && rm -rf /usr/src/swiftytesseract && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/cli
COPY . .

RUN swift build -c release
ENV PATH $PATH:/usr/src/cli/.build/release
