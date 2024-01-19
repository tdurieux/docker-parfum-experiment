import { parseDocker } from "@tdurieux/dinghy";
import config from "../../../config";
import { SIZE_RULES, walkSync } from "../../utils";
import { eachOfLimit } from "async";
import { readFile } from "fs/promises";

(async () => {
  const dockerfiles = walkSync(config.groundTruthSmells);
  const distribution = {};
  for (let rule of SIZE_RULES) {
    distribution[rule.name] = 0;
  }
  eachOfLimit(
    dockerfiles,
    10,
    async (resultFile, _, callback) => {
      try {
        const data = JSON.parse(await readFile(resultFile, "utf-8"));
        for (let smell in data) {
          if (distribution[smell] !== undefined) {
            distribution[smell] += data[smell].length;
          }
        }
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
