FROM golang:latest

# Update registry and install tesseract and dependencies
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
      libtesseract-dev \
      libleptonica-dev \
      tesseract-ocr-eng && rm -rf /var/lib/apt/lists/*;

ENV GO111MODULE=auto
RUN go get -u -v -t github.com/otiai10/gosseract

# Test it!
CMD ["go", "test", "-v", "github.com/otiai10/gosseract"]
