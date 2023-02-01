FROM {{ "quibble-buster-php72" | image_tag }}

USER root

# Fresnel needs firefox-esr in order for Headless Chromium to work.
# There are numerous libs that Chromium only needs for headless mode
# and these are not statically linked in the distribution provided by Google,
# and they also aren't specified by Debian as deps for 'chromium'.
# The full list is documented at:
#   https://github.com/puppeteer/puppeteer/blob/v4.0.1/docs/troubleshooting.md
# In WMF CI has installed Firefox and Chromium together since 2015, so keep doing that for now.
# https://phabricator.wikimedia.org/T226078
RUN {{ "firefox-esr" | apt_install }}

#
# Install Fresnel
#
RUN mkdir -p /opt/npm-tmp /opt/fresnel \
    && chown nobody:nogroup /opt/npm-tmp /opt/fresnel
USER nobody
RUN cd /opt/fresnel \
    && NPM_CONFIG_cache=/opt/npm-tmp NPM_CONFIG_update_notifier=false npm install fresnel@1.1.1 \
    && find /opt/npm-tmp -mindepth 1 -delete && npm cache clean --force;
USER root
RUN rm -rf /opt/npm-tmp \
    && ln -s /opt/fresnel/node_modules/.bin/fresnel /usr/local/bin/fresnel
COPY mediawiki-fresnel-patch.sh /usr/local/bin/mediawiki-fresnel-patch

# TODO: Move to quibble base image and then remove from quibble-…-bundle/mwselenium.sh
ENV CHROMIUM_FLAGS="--no-sandbox"

# Unprivileged
RUN install --directory /workspace --owner=nobody --group=nogroup
USER nobody
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/quibble"]
