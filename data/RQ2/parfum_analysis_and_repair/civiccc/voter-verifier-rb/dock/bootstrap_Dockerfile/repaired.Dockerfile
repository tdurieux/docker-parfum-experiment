# Dockerfile for installing the necessary components (e.g. ruby gems) for
# launching a service within Dock.
# This file runs as root when the application container is being built.
# It is useful for adding any system level packages or system level client
# libraries if you need for testing.
# NOTE: do not install gems or run the application using this file. Instead
# use the dock/initialize and dock/run files since those files run as the app
# user and this file runs as root