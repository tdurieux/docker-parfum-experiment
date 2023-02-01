FROM gcr.io/google-appengine/debian9@sha256:1d6a9a6d106bd795098f60f4abb7083626354fa6735e81743c7f8cfca11259f0
# First, try adding some regular files
ADD context/foo foo
ADD context/foo /foodir/
ADD context/bar/b* bar/
ADD . newdir
ADD ["context/foo", "/tmp/foo" ]

# Next, make sure environment replacement works
ENV contextenv ./context
ADD $contextenv/* /tmp/${contextenv}/

# Now, test extracting local tar archives
ADD context/tars/fil* /tars/
ADD context/tars/file.tar /tars_again

# This tar has some directories that should be whitelisted inside it.

ADD context/tars/sys.tar.gz /

# Test with ARG
ARG file
COPY $file /arg

# Finally, test adding a remote URL, concurrently with a normal file
ADD https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v1.4.3/docker-credential-gcr_linux_386-1.4.3.tar.gz context/foo /test/all/

# Test environment replacement in the URL
ENV VERSION=v1.4.3
ADD https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/${VERSION}-static/docker-credential-gcr_linux_amd64-1.4.3.tar.gz /destination
