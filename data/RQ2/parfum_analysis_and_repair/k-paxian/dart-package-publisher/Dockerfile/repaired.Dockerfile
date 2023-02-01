FROM dart:latest

# Installing prerequisites
RUN apt-get update && \
	apt-get install --no-install-recommends -y unzip && \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV PATH $PATH:/flutter/bin

COPY . /

ENTRYPOINT ["/entrypoint.sh"]
