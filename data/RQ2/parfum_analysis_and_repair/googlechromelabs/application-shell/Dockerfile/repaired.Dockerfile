# Dockerfile extending the generic Node image with application files for a
# single application.
FROM beta.gcr.io/google_appengine/nodejs
# Check to see if the the version included in the base runtime satisfies \
# >=4.1.0, if not then do an npm install of the latest available \
# version that satisfies it. \
RUN npm install         https://storage.googleapis.com/gae_node_packages/semver.tar.gz && \
  ( node -e 'var semver = require("semver"); \
            if (!semver.satisfies(process.version, ">=4.1.0")) \
              process.exit(1);' || \
   ( version=$( curl -f -L https://storage.googleapis.com/gae_node_packages/node_versions | \
              node -e ' \
                var semver = require("semver"); \
                var http = require("http"); \
                var spec = process.argv[1]; \
                var latest = ""; \
                var versions = ""; \
                var selected_version; \
 \
                function verifyBinary(version) { \
                  var options = { \
                    "host": "storage.googleapis.com", \
                    "method": "HEAD", \
                    "path": "/gae_node_packages/node-" + version + \
                            "-linux-x64.tar.gz" \
                  }; \
                  var req = http.request(options, function (res) { \
                    if (res.statusCode == 404) { \
                      console.error("Binaries for Node satisfying version " + \
                                    version + " are not available."); \
                      process.exit(1); \
                    } \
                  }); \
                  req.end(); \
                } \
                function satisfies(version) { \
                  if (semver.satisfies(version, spec)) { \
                    process.stdout.write(version); \
                    verifyBinary(version); \
                    return true; \
                  } \
                } \
                process.stdin.on("data", function(data) { \
                  versions += data; \
                }); \
                process.stdin.on("end", function() { \
                  versions = \
                      versions.split("\n").sort().reverse(); \
                  if (!versions.some(satisfies)) { \
                    console.error("No version of Node found satisfying: " + \
                                  spec); \
                    process.exit(1); \
                  } \
                });' \
                ">=4.1.0") && \
                rm -rf /nodejs/* && \
                ( curl -f https://storage.googleapis.com/gae_node_packages/node-$version-linux-x64.tar.gz | \
                 tar xzf - -C /nodejs --strip-components=1))) && npm cache clean --force;
COPY . /app/
# You have to specify "--unsafe-perm" with npm install
# when running as root.  Failing to do this can cause
# install to appear to succeed even if a preinstall
# script fails, and may have other adverse consequences
# as well.
RUN npm --unsafe-perm install && npm cache clean --force;
CMD npm start
