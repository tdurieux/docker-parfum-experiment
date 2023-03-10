FROM gitpod/workspace-postgres

RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh \
             && sdk install java 11.0.13-tem"

# disable angular analytics
ENV NG_CLI_ANALYTICS=false

# Docker build does not rebuild an image when a base image is changed, increase this counter to trigger it.
ENV TRIGGER_REBUILD 4

RUN npm install -g @angular/cli && npm cache clean --force;

# Install odoo
ENV ODOO_VERSION 14.0
ENV ODOO_RELEASE latest
RUN curl -f -o odoo.deb -sSL https://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
    && sudo apt-get update \
    && sudo apt-get -y install --no-install-recommends ./odoo.deb \
    && sudo rm -rf /var/lib/apt/lists/* odoo.deb

# Install wkhtmltopdf
ENV WKHTMLTOPDF_VERSION 0.12.6-1
ENV WKHTMLTOPDF_RELEASE focal_amd64
RUN curl -f -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_VERSION}/wkhtmltox_${WKHTMLTOPDF_VERSION}.${WKHTMLTOPDF_RELEASE}.deb \
    && sudo apt-get update \
    && sudo apt-get install --no-install-recommends -y ./wkhtmltox.deb \
    && sudo rm -rf /var/lib/apt/lists/* wkhtmltox.deb
