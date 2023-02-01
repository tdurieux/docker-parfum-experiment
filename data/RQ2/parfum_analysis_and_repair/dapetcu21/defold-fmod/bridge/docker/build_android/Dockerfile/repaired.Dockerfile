FROM lakoo/android-ndk:28-28.0.2-r17c

RUN apt-get update && apt-get install --no-install-recommends make -y && rm -rf /var/lib/apt/lists/*;

VOLUME [ "/repo" ]
WORKDIR /repo/bridge

ENTRYPOINT [ "make", "-f", "Makefile.android" ]