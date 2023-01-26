import { mkdir, readFile, writeFile } from "fs/promises";
import { existsSync } from "fs";
import { dirname, join } from "path";
import ProgressBar from "progress";
import * as async from "async";
import yargs from "yargs";
import config from "../../config";
import * as utils from "../utils";

const tokens = {};
for (let token of config.github_tokens) {
  tokens[token] = {};
}

/**
 * Download the file tree of a project
 * @param repoName the repository name
 * @param available_tokens the available tokens
 */
async function downloadTreeProject(
  repoName: string,
  token: string,
  outputDir: string
) {
  const [owner, repo] = repoName.split("/");
  const tree_sha = "HEAD";
  const recursive = "1";

  const octokit = utils.createOctokit(token);
  const response = await octokit.git.getTree({
    owner,
    repo,
    tree_sha,
    recursive,
  });
  const files = response.data;
  for (let file of files.tree) {
    delete file.url;
  }
  const outputFilePath = join(outputDir, owner, `${repo}.json`);
  if (!existsSync(dirname(outputFilePath))) {
    await mkdir(dirname(outputFilePath), { recursive: true });
  }
  await writeFile(outputFilePath, JSON.stringify(files), {
    encoding: "utf-8",
  });
}

(async () => {
  const argv = await yargs(process.argv.slice(2))
    .option("repositoriesPath", {
      type: "string",
      default: config.defaultRepositoryListPath,
    })
    .option("output", {
      type: "string",
      default: config.defaultFileListOutputPath,
      alias: "o",
    })
    .option("skip-existing", {
      type: "boolean",
      default: true,
      alias: "s",
      description:
        "Skip repositories that the file list have been already downloaded",
    })
    .parse();

  if (config.github_tokens.length == 0) {
    throw new Error(
      "No github token available, the tokens need to be provided in the config file (./config.ts)"
    );
  }
  // cread the csv file that contains the list of repositories
  const repos = (
    await readFile(argv.repositoriesPath, {
      encoding: "utf-8",
    })
  ).split("\n");

  const bar = new ProgressBar(
    "[:bar] :current :rate/bps :percent :etas :step",
    {
      complete: "=",
      incomplete: " ",
      width: 30,
      total: repos.length,
    }
  );
  const available_tokens = [...config.github_tokens];

  async.forEachOfLimit(
    repos,
    available_tokens.length,
    async (repoInfo, _, callback) => {
      const repoName = repoInfo.split(",")[0].replace(/"/g, "");
      bar.tick({ step: repoName });

      const filePath = join(argv.output, `${repoName}.json`);
      if (argv.skipExisting && existsSync(filePath)) return callback();

      const token = available_tokens.pop();
      if (!token) {
        throw new Error("No token available");
      }
      try {
        await downloadTreeProject(repoName, token, argv.output);
      } catch (e) {
        if (e.status != 404) console.log(e);
        // ignore errors
      } finally {
        available_tokens.push(token);
        callback();
      }
    }
  );
})();
