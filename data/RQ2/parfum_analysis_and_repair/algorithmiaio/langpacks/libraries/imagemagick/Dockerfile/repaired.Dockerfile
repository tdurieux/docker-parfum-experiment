RUN apt-get update && apt-get install --no-install-recommends -y imagemagick && \
 sed -i 's/^.*policy.*coder.*none.*PDF.*//' /etc/ImageMagick-6/policy.xml && rm -rf /var/lib/apt/lists/*;