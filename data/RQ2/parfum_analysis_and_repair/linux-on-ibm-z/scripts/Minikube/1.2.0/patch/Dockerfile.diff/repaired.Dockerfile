diff --git a/deploy/storage-provisioner/Dockerfile b/deploy/storage-provisioner/Dockerfile
index bef335d51..f2732312c 100644
--- a/deploy/storage-provisioner/Dockerfile
+++ b/deploy/storage-provisioner/Dockerfile
@@ -12,6 +12,6 @@
 # See the License for the specific language governing permissions and
 # limitations under the License.
 
-FROM scratch
+FROM ubuntu:16.04
 COPY out/storage-provisioner storage-provisioner
 CMD ["/storage-provisioner"]