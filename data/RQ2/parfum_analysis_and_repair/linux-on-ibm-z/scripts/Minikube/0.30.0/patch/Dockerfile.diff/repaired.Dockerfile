--- deploy/storage-provisioner/Dockerfile	2018-12-26 07:39:01.659302329 -0500
+++ deploy/storage-provisioner/Dockerfile2	2018-12-26 08:20:18.935161008 -0500
@@ -12,6 +12,6 @@
 # See the License for the specific language governing permissions and
 # limitations under the License.
 
-FROM scratch
+FROM ubuntu:16.04
 COPY out/storage-provisioner storage-provisioner
 CMD ["/storage-provisioner"]