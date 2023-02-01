FROM tiryoh/moddable-esp32:OS201127

RUN curl -f -SL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get update && apt-get install --no-install-recommends -y nodejs \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*