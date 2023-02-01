FROM golang:1.16

RUN apt update
RUN apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y poppler-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unrtf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tidy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lynx && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtesseract-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libleptonica-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tesseract-ocr-eng && rm -rf /var/lib/apt/lists/*;

RUN go get -t github.com/otiai10/gosseract

RUN go get -tags ocr code.sajari.com/docconv/...

ENTRYPOINT ["docd"]
