# vale build container

# Define on fstar-version.json what FStar base container image
# vale build should use.
# By default it always look for the latest FStar container available
# In case you would like to reference a specific commit,
# replace latest with the commit id from github using 12 characters.
# Latest can only be used with branch master,
# for any other branch please use the specific commit id on the config file.
ARG DOCKERHUBPROJECT
ARG COMMITID
FROM ${DOCKERHUBPROJECT}fstar-windows-nt:${COMMITID}

ARG BUILDLOGFILE
ARG MAXTHREADS
ARG BUILDTARGET
ARG BRANCHNAME

# Add ssh key
# We cannot copy directly to the .ssh folder, instead we copy to a temp folder
WORKDIR "everestsshkey"
COPY id_rsa .
WORKDIR ".."

# Now, using bash we copy the file, set the correct security and remove the previous folder
RUN Invoke-BashCmd '"cd .ssh && cp ../everestsshkey/id_rsa . && chmod 600 id_rsa && rm -rf ../everestsshkey"'

# Copy source files
WORKDIR "vale"
COPY / .
WORKDIR ".."

# Do some cleanup
RUN Invoke-BashCmd rm -f build.sh
RUN Invoke-BashCmd rm -f build_helper.sh
RUN Invoke-BashCmd rm -f buildlogfile.txt
RUN Invoke-BashCmd rm -f log_no_replay.html
RUN Invoke-BashCmd rm -f log_worst.html
RUN Invoke-BashCmd rm -f orange_status.txt
RUN Invoke-BashCmd rm -f result.txt
RUN Invoke-BashCmd rm -f status.txt
RUN Invoke-BashCmd rm -f commitinfofilename.json

RUN Invoke-BashCmd rm vale/Dockerfile
RUN Invoke-BashCmd rm vale/build.sh
RUN Invoke-BashCmd rm vale/build_helper.sh
RUN Invoke-BashCmd rm vale/id_rsa
RUN Invoke-BashCmd rm vale/commitinfofilename.json

COPY build.sh build.sh
COPY build_helper.sh build_helper.sh

RUN Invoke-BashCmd ./build_helper.sh $Env:BUILDTARGET $Env:BUILDLOGFILE $Env:MAXTHREADS $Env:BRANCHNAME '||' true

# Remove ssh key.
RUN Invoke-BashCmd rm .ssh/id_rsa
