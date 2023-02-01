FROM ubuntu:14.04
RUN apt-get update && apt-get -y --no-install-recommends install rsync && rm -rf /var/lib/apt/lists/*;
CMD /bin/bash /OnlineJudge/dockerfiles/test_case_rsync/run.sh
