FROM ingest:latest

ENTRYPOINT ["celery", "-A", "irods_capability_automated_ingest.sync_task", "worker", "-Q", "restart,path,file"]
CMD ["-h"]