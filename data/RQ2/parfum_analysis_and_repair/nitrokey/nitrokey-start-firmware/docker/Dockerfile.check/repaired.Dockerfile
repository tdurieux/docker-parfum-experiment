FROM gnuk:latest

LABEL Description="Image for checking gnuK"

RUN apt install --no-install-recommends -y shellcheck && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y clang libfindbin-libs-perl && rm -rf /var/lib/apt/lists/*;
RUN apt clean
