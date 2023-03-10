# Dockerfile extending the generic Node image with application files for a
# single application.
FROM gcr.io/google_appengine/nodejs
# Check to see if the the version included in the base runtime satisfies \
# ~0.12.0, if not then do an npm install of the latest available \
# version that satisfies it. \
RUN npm install && npm cache clean --force;
https://storage.googleapis.com/gae_node_packages/semver.tar.gz && \
  (node -e 'var semver = require("semver"); \
            if (!semver.satisfies(process.version, "~0.12.0")) \
              process.exit(1);' || \
   (version=$(curl -L
https://storage.googleapis.com/gae_node_packages/node_versions | \
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
                "~0.12.0") && \
                rm -rf /nodejs/* && \
                (curl
https://storage.googleapis.com/gae_node_packages/node-$version-linux-x64.tar.gz
| \
                 tar xzf - -C /nodejs --strip-components=1 \
                 ) \
    ) \
   )
RUN apt-get update && apt-get install --no-install-recommends imagemagick graphicsmagick -y && rm -rf /var/lib/apt/lists/*;
RUN npm install parse-anywhere -g && npm cache clean --force;
