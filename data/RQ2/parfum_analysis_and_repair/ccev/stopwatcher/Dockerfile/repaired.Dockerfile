# docker build -t stopwatcher .
# docker run --rm -v "$(pwd)"/config:/usr/src/app/config -t stopwatcher python3 stop_watcher.py --init
# docker run --rm -v "$(pwd)"/config:/usr/src/app/config -t stopwatcher