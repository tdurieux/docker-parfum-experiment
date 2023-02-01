FROM debian:9

# Install kaldi binaries and dependencies
RUN apt-get update \
 && apt-get install --no-install-recommends -y apt-transport-https wget curl gnupg git libfst-tools libatlas3-base sphinxbase-utils \
 && echo "deb http://goofy.zamia.org/repo-ai/debian/stretch/amd64/ ./" >/etc/apt/sources.list.d/zamia-ai.list \
 && wget -qO - https://goofy.zamia.org/repo-ai/debian/stretch/amd64/bofh.asc | apt-key add - \
 && apt-get update \
 && apt-get install --no-install-recommends -y --allow-unauthenticated python-kaldiasr python-nltools pulseaudio-utils pulseaudio \
 && apt-get clean -y && rm -rf /var/lib/apt/lists/*;

# Checkout and configure zamia speech
RUN git clone https://github.com/pguyot/zamia-speech.git \
  && (echo "[speech]" && echo "kaldi_root = /opt/kaldi") > /root/.speechrc
