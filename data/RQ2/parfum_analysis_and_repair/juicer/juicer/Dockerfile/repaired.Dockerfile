# Latest juicer running on f23
#
# You have to mount the configuration directory and work directory to run:
#
#   docker run -v <myconfigdir>:/root/.config/juicer -v <workdir>:/rpms -w /rpms <image> 'juicer rpm upload -r <rpmname>'
#