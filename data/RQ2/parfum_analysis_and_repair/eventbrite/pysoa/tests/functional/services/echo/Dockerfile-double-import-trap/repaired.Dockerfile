FROM pysoa-test-service-echo

# This should fail to start, and we'll have a test that verifies that
CMD ["/srv/echo/echo_service/standalone.py", "-s", "echo_service.settings", "-f", "3", "--use-file-watcher", "echo_service,pysoa"]