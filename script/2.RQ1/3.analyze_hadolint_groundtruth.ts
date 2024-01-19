import { exec } from "child_process";
import config from "../../config";
import { walkSync } from "../utils";
import { writeFile } from "fs/promises";
import { basename, join } from "path";

async function main() {
  for (const dockerfilePath of walkSync(config.groundTruthDockerfiles)) {
    const cmd = `hadolint -f json ${dockerfilePath}`;
    const { stdout } = exec(cmd);
    await writeFile(
      join(
        config.dataFolder,
        "dataset/groud_truth/hadolint",
        basename(dockerfilePath).replace(/\.Dockerfile$/, ".json")
      ),
      stdout
    );
  }
}

if (require.main === module) {
  main();
}
