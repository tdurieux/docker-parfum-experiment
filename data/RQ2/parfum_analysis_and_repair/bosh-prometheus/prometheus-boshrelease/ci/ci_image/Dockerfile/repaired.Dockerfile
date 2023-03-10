FROM bosh/main-bosh-docker

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y apt-utils wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O - https://raw.githubusercontent.com/starkandwayne/homebrew-cf/master/public.key | apt-key add -
RUN echo "deb http://apt.starkandwayne.com stable main" | tee /etc/apt/sources.list.d/starkandwayne.list
RUN apt-get update && apt-get install -y --no-install-recommends jq spruce git && rm -rf /var/lib/apt/lists/*;
