diff --git a/Dockerfile.s390x b/Dockerfile.s390x
index afd20ec..da96352 100644
--- a/Dockerfile.s390x
+++ b/Dockerfile.s390x
@@ -15,4 +15,5 @@ FROM scratch
 
 ADD bin/dikastes-s390x /dikastes
 ADD bin/healthz-s390x /healthz
-CMD ["/dikastes"]
+ENTRYPOINT ["/dikastes"]
+CMD ["server"]