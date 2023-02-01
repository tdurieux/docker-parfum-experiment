# TAG dnastack/signal:1
FROM finlaymaguire/signal

MAINTAINER Heather Ward <heather@dnastack.com>

RUN git pull

# This is not optimal, but it works & stays up to date