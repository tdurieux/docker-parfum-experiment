FROM swift:5.1
RUN apt-get update && apt-get install --no-install-recommends -y zlib1g-dev ruby && rm -rf /var/lib/apt/lists/*;
CMD cd xclogparser && swift build
