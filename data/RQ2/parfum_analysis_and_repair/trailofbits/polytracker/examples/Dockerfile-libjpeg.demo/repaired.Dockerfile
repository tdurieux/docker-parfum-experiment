# Create a separate image with the latest source
FROM ubuntu:focal AS libjpeg-sources
WORKDIR /polytracker/the_klondike/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://jpegclub.org/reference/wp-content/uploads/2022/01/jpegsrc.v9e.tar.gz && tar xf jpegsrc.v9e.tar.gz && rm jpegsrc.v9e.tar.gz

# Now, build the libjpeg image using previously downloaded source
FROM trailofbits/polytracker:latest
LABEL org.opencontainers.image.authors="henrik.brodin@trailofbits.com"

WORKDIR /polytracker/the_klondike/
COPY --from=libjpeg-sources /polytracker/the_klondike/jpeg-9e /polytracker/the_klondike/jpeg-9e

WORKDIR /polytracker/the_klondike/jpeg-9e/build
# Configure build
RUN ../configure LDFLAGS="-static"
# Build and instrument
RUN polytracker build make -j$((`nproc`+1))
RUN polytracker instrument-targets djpeg --no-control-flow-tracking
# Create `djpeg_track`
RUN mv djpeg.instrumented djpeg_track