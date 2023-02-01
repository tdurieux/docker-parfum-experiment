# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM node:6

# npm throws an error when installing a dependency, because we
# are root. This setting works around that issue.
RUN npm config set unsafe-perm true

# Allow override of dashboard package version
ARG DASHBOARDS_SERVER_PKG
COPY ./dashboards_server /src/
RUN npm install -g "$DASHBOARDS_SERVER_PKG"

# always expose server on all interfaces in a container
ENV IP 0.0.0.0

# expose the default express http/https port (3000/3001) and the node debugger port (8080)
EXPOSE 3000 3001 8080

CMD ["jupyter-dashboards-server"]
