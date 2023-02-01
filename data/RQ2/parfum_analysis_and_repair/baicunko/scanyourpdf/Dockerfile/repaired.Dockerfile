FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y ghostscript imagemagick && rm -rf /var/lib/apt/lists/*;

RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml

WORKDIR /app

COPY scanned_pdf.sh ./

CMD ./scanned_pdf.sh
