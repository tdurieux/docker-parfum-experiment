# Make sure drivers are >= 390
# docker run -p 2000-2002:2000-2002 --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=ID carla:latest ./CarlaUE4.sh
# -carla-rpc-port=2000 -carla-streaming-port=2001