FROM debian
RUN apt-get update && apt-get install --no-install-recommends -qqy x11-apps && rm -rf /var/lib/apt/lists/*;
CMD xeyes
