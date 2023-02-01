# Image name: daqf/aardvark
#
# Base image called aardvark because the code is lazy and evaluates alphabetically.
#
#              _.---._    /\\
#           ./'       "--`\//
#         ./              o \
#        /./\  )______   \__ \
#       ./  / /\ \   | \ \  \ \
#          / /  \ \  | |\ \  \7
#           "     "    "  "

# Need to use ubuntu because mininet is very persnickity about versions.
FROM ubuntu:focal

# Dump all our junks into the root home directory.