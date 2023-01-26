import { parseDocker } from "@tdurieux/dinghy";
import config from "../../../config";
import { walkSync } from "../../utils";
import { eachOfLimit } from "async";

(async () => {
  const dockerfiles = walkSync(config.defaultDockerfileOutputPath);
  const distribution = {};
  eachOfLimit(
    dockerfiles,
    10,
    async (dockerfile, _, callback) => {
      try {
        const ast = await parseDocker(dockerfile);
        distribution[ast.children.length] = distribution[ast.children.length]
          ? distribution[ast.children.length] + 1
          : 1;
      } catch (error) {
        // console.log(error);
      } finally {
        callback();
      }
    },
    () => {
      console.log(JSON.stringify(distribution, null, 2));
    }
  );
})();
