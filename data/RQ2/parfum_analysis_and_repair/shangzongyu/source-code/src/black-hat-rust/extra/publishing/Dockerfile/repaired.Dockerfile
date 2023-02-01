FROM ubuntu:latest

RUN apt update
RUN apt upgrade -y

# Create ebook user
ENV USER=ebook
ENV UID=10001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"


# Install dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt install --no-install-recommends -y vim calibre pdftk epubcheck binutils make wget imagemagick && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y pandoc libpar-packer-perl perl-doc zlib1g zlib1g-dev expat \
    texlive-latex-base texlive-latex-extra texlive-xetex texlive librsvg2-bin \
    texlive-fonts-recommended texlive-fonts-extra texlive-xetex texlive-latex-recommended && rm -rf /var/lib/apt/lists/*;


USER ebook:ebook

WORKDIR /ebook

CMD ["make", "all"]
