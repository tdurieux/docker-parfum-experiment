# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                                                                            ║
# ║                 __ \             |               _|_) |                    ║
# ║                 |   |  _ \   __| |  /  _ \  __| |   | |  _ \               ║
# ║                 |   | (   | (      <   __/ |    __| | |  __/               ║
# ║                ____/ \___/ \___|_|\_\\___|_|   _|  _|_|\___|               ║
# ║                                                                            ║
# ║           * github.com/paperwork * twitter.com/paperworkcloud *            ║
# ║                                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# We have to use Node 11 instead of the latest, because node-sass is only
# compatible with Node 12 from v4.12.0 upwards but
# @angular-devkit/build-angular hasn't updated to node-sass@4.12.0 or newer yet.