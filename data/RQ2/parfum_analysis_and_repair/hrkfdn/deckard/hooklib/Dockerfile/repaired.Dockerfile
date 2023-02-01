FROM lakoo/android-ndk
ENV PATH ${PATH}:/opt/android-ndk-linux/
RUN apt-get update && apt-get install --no-install-recommends -y make file && rm -rf /var/lib/apt/lists/*;