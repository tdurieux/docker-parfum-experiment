# NOTE: replace YOUR-KEY with your endpoint key
#       you can use your authoring key if it still has available request quota 
#
# BUILD IMAGE
# $ docker build --no-cache -t luis-endpoint-go .
#
# RUN CODE
#
# WINDOWS BASH COMMAND 
# $ winpty docker run -it --rm --name luis-running-endpoint-go luis-endpoint-go
#
# NON-WINDOWS
# $ docker run -it --rm --name luis-running-endpoint-go luis-endpoint-go tail 