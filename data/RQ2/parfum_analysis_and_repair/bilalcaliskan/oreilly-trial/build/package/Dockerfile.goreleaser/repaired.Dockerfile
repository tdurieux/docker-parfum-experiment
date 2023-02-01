FROM gcr.io/distroless/static:nonroot-amd64

ADD oreilly-trial /usr/local/bin/oreilly-trial
ADD build/ci/banner.txt /usr/local/banner.txt

USER nonroot
ENTRYPOINT ["oreilly-trial", "--bannerFilePath", "/usr/local/banner.txt"]