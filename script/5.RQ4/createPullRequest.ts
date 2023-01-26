import { dirname, join } from "path";
import { readFile, mkdir, writeFile } from "fs/promises";

import { existsSync } from "fs";
import Yargs from "yargs/yargs";
import inquirer from "inquirer";
import * as diff from "diff";

import { File, parseDocker, nodeType } from "@tdurieux/dinghy";
import { Matcher, Violation, rules } from "@tdurieux/docker-parfum";

import {
  RepositoryAnalysisResult,
  analyze,
} from "../3.RQ2/repair_repository_dockerfile";
import { bytesToSize, percent, createOctokit, wait } from "../utils";
import config from "../../config";

const outputPath = join(
  config.dataFolder,
  "..",
  "..",
  "..",
  "data",
  "evaluation",
  "pr_analysis"
);

async function getFile(
  repositoryUrl: string,
  branch: string | undefined,
  token: string,
  path: string
) {
  // get a file using the GitHub API
  const octokit = createOctokit(token);
  const [owner, repo] = repositoryUrl.replace(".git", "").split("/").slice(-2);
  const response = await octokit.repos.getContent({
    owner,
    repo,
    path,
    ref: branch,
  });
  if (!("content" in response.data))
    throw new Error("Unable to get the dockerfile");
  return {
    file: Buffer.from(response.data.content, "base64").toString("utf-8"),
    sha: response.data.sha,
  };
}

async function forkRepository(
  repositoryUrl: string,
  token: string,
  organization: string
) {
  // fork a repository using the GitHub API
  const octokit = createOctokit(token);
  const [owner, repo] = repositoryUrl.replace(".git", "").split("/").slice(-2);
  const o = await octokit.repos.createFork({
    owner,
    repo,
    organization,
    default_branch_only: true,
  });
  console.log(`Fork created at ${o.data.html_url}`);
  return o.data;
}

async function createBranch(
  repositoryUrl: string,
  token: string,
  originalBranch: string,
  branch: string
) {
  // create a branch using the GitHub API
  const octokit = createOctokit(token);
  const [owner, repo] = repositoryUrl.replace(".git", "").split("/").slice(-2);
  const o = await octokit.git.createRef({
    owner,
    repo,
    ref: `refs/heads/${branch}`,
    sha: (
      await octokit.repos.getBranch({ owner, repo, branch: originalBranch })
    ).data.commit.sha,
  });
  await wait(1000);
  return o;
}

async function updateFile(
  repositoryUrl: string,
  branch: string,
  sha: string,
  token: string,
  path: string,
  content: string
) {
  // update a file using the GitHub API
  const octokit = createOctokit(token);
  const [owner, repo] = repositoryUrl.replace(".git", "").split("/").slice(-2);
  return octokit.repos.createOrUpdateFileContents({
    owner,
    repo,
    path,
    author: {
      name: "tdurieux",
      email: "durieuxthomas@hotmail.com",
    },
    message: "chore: update Dockerfile to reduce the image size",
    content: Buffer.from(content).toString("base64"),
    branch,
    sha,
  });
}
async function createPullRequest(
  repositoryUrl: string,
  branch: string,
  token: string,
  info: RepositoryAnalysisResult,
  violationsToRepair: Violation[]
) {
  // create a pull request using the GitHub API
  const octokit = createOctokit(token);
  const [owner, repo] = repositoryUrl.replace(".git", "").split("/").slice(-2);

  const body = generatePRBody(info, repo, violationsToRepair);
  return await octokit.pulls.create({
    owner,
    repo,
    head: branch,
    base: branch,
    title: "Fix Dockerfile",
    body,
  });
}

const explanations = {
  pipUseNoCacheDir:
    "I added the `--no-cache-dir` to the `pip` command to disable the package cache.",
  aptGetInstallUseNoRec:
    "I added the `--no-install-recommends` to with apt-get in order to not install unnecessary packages and reduce the image size.",
  apkAddUseNoCache:
    "I added `--no-cache` flag to `apk add` to ensure that no useless information is kept inside the Docker image.",
  npmCacheCleanAfterInstall:
    "I added `npm cache clean` after `npm install` to remove `npm` cache that is not needed inside the Docker image.",
  yumInstallRmVarCacheYum:
    "I remove the yum cache after the `yum install` which reduces the size of the final image.",
  ruleAptGetInstallThenRemoveAptLists:
    "I added `rm -rf /var/lib/apt/lists/*` after `apt-get install` which removes unnecessary files and reduces the size of the image.",
  aptGetUpdatePrecedesInstall:
    "I put `apt-get update` and `apt-get install` in a single layer to optimize the layers and reduce the number of unneeded files",
};

function generatePRBody(
  info: RepositoryAnalysisResult,
  repo: string,
  violationsToRepair: Violation[]
) {
  const sizeDiff = info.originalBuild.imageSize - info.repairedBuild.imageSize;
  let body = `Hi there,

I've made a small improvement to the Dockerfile that I think could `;

  if (sizeDiff > 100) {
    body += "help optimize the image size.";
  } else {
    body += "improve the security of the image.";
  }

  const vDesc = new Set(
    violationsToRepair.map((v) => {
      if (explanations[v.rule.name]) {
        return explanations[v.rule.name];
      }
      return v.rule.description;
    })
  );
  if (vDesc.size > 1) {
    body += "\n\nSummary of the changes:\n";
  } else {
    body += "\n\nThe change I made:\n";
  }

  vDesc.forEach((d) => {
    body += `* ${d}\n`;
  });
  body += `\n`;

  if (sizeDiff > 100) {
    body += `\nImpact on the image size:
* Image size before repair: ${bytesToSize(info.originalBuild.imageSize)}
* Image size after repair: ${bytesToSize(info.repairedBuild.imageSize)}
* Difference: ${bytesToSize(sizeDiff)} (${percent(
      sizeDiff,
      info.originalBuild.imageSize
    )})\n\n`;
  }

  if (vDesc.size > 0) {
    body += "I hope that you will find these changes useful to you. ";
  } else {
    body += "I hope that you will find this change useful to you. ";
  }

  body += `Let me know if you have any questions or concerns.

Thanks,\n\n`;

  return body;
}

// display diff between two strings in the console
function displayDiff(original: string, repaired: string) {
  const diffResult = diff.createTwoFilesPatch(
    "/Dockerfile",
    "/Dockerfile",
    original,
    repaired,
    undefined,
    undefined,
    {
      context: 3,
    }
  );
  diffResult.split("\n").forEach((line) => {
    if (
      line.startsWith("Index") ||
      line.startsWith("====") ||
      line === "" ||
      line.startsWith("+++") ||
      line.startsWith("---")
    ) {
      return;
    }
    if (line.startsWith("@@")) {
      console.log("\x1b[36m%s\x1b[0m", line);
    } else if (line.startsWith("+")) {
      console.log("\x1b[32m%s\x1b[0m", line);
    } else if (line.startsWith("-")) {
      console.log("\x1b[31m%s\x1b[0m", line);
    } else {
      console.log(line);
    }
  });
}

async function getRepositoryAnalysisResults(repositoryUrl: string) {
  // get the analysis results from the result folder
  const [owner, repo] = repositoryUrl.replace(".git", "").split("/").slice(-2);
  const path = join(
    config.defaultBuildDockerfileOutputPath,
    `${owner}/${repo}.json`
  );
  try {
    return JSON.parse(
      await readFile(path, "utf-8")
    ) as RepositoryAnalysisResult;
  } catch (error) {
    return null;
  }
}
// read arguments from command line that requires a repository url using yargs
async function main() {
  const argv = await Yargs(process.argv.slice(2))
    .usage("Usage: $0 -r [string]")
    .option("r", {
      alias: "repository",
      describe: "The repository url to repair",
      type: "string",
      demandOption: true,
    })
    .option("b", {
      alias: "branch",
      describe: "The branch to repair",
      type: "string",
      demandOption: false,
    })
    .option("t", {
      alias: "token",
      describe: "The GitHub token",
      type: "string",
      demandOption: false,
      default: process.env.GITHUB_TOKEN,
    })
    .option("p", {
      alias: "path",
      describe: "The path to the file to repair",
      type: "string",
      demandOption: false,
      default: "/Dockerfile", // Dockerfile in root folder
    })
    .option("o", {
      alias: "organization",
      describe: "The GitHub organization",
      type: "string",
      demandOption: false,
      default: process.env.GITHUB_ORGANIZATION,
    })
    .parse();
  if (!argv.t) {
    throw new Error("GitHub token is required (-t).");
  }

  const repository = argv.r.endsWith("/") ? argv.r.slice(0, -1) : argv.r;
  const [owner, repo] = repository.replace(".git", "").split("/").slice(-2);
  const branch = argv.b;
  const token = argv.t;
  const organization = argv.o;
  const path = argv.p.startsWith("/") ? argv.p.substring(1) : argv.p;

  const output = {
    startTime: new Date(),
    endTime: undefined,
    repository,
    branch,
    organization,
    dockerfilePath: path,
    dockerfile_sha: undefined,
    dockerfile: undefined,
    error: undefined,
  };

  try {
    const { sha, file } = await getFile(repository, branch, token, path);
    output.dockerfile_sha = sha;
    output.dockerfile = file;

    const ast = await parseDocker(new File(null, file));

    const violationsToRepair: Violation[] = [];
    const violations: Violation[] = [];

    const consideredRules = [
      rules.npmCacheCleanAfterInstall,
      rules.npmCacheCleanUseForce,
      rules.rmRecursiveAfterMktempD,
      rules.curlUseHttpsUrl,
      rules.wgetUseHttpsUrl,
      rules.pipUseNoCacheDir,
      rules.mkdirUsrSrcThenRemove,
      rules.configureShouldUseBuildFlag,
      rules.gemUpdateSystemRmRootGem,
      rules.sha256sumEchoOneSpaces,
      rules.gemUpdateNoDocument,
      rules.gpgVerifyAscRmAsc,
      rules.yumInstallForceYes,
      rules.yumInstallRmVarCacheYum,
      rules.tarSomethingRmTheSomething,
      rules.gpgUseBatchFlag,
      rules.gpgUseHaPools,
      rules.aptGetInstallUseY,
      rules.aptGetInstallUseNoRec,
      rules.aptGetUpdatePrecedesInstall,
      rules.aptGetInstallThenRemoveAptLists,
      rules.apkAddUseNoCache,
    ];
    for (const rule of consideredRules) {
      new Matcher(ast).match(rule).forEach((v) => violations.push(v));
    }

    const allViolations = await inquirer.prompt([
      {
        type: "confirm",
        name: "confirm",
        message: `Select which of the ${violations.length} violations to repair?`,
        default: false,
      },
    ]);
    if (allViolations.confirm) {
      for (const v of violations) {
        const newAst = await v.repair({
          clone: true,
        });
        console.log(v.toString());
        displayDiff(file, newAst.getParent(nodeType.DockerFile).toString(true));

        const confirm = await inquirer.prompt([
          {
            type: "confirm",
            name: "confirm",
            message: `Include this repair in the patch?`,
            default: true,
          },
        ]);
        if (confirm.confirm) {
          violationsToRepair.push(v);
        }
      }
    } else {
      violations.forEach((v) => violationsToRepair.push(v));
    }
    if (violationsToRepair.length == 0) {
      console.log("No repairs were selected");
      return;
    }
    for (const v of violationsToRepair) {
      await v.repair();
    }
    displayDiff(file, ast.toString(true));
    const confirm = await inquirer.prompt([
      {
        type: "confirm",
        name: "confirm",
        message: `Confrim that the generated Dockerfile is correct.`,
        default: true,
      },
    ]);
    if (!confirm.confirm) {
      return;
    }
    let info = await getRepositoryAnalysisResults(repository);
    let reexecute = true;
    if (info) {
      const reexecuteQ = await inquirer.prompt([
        {
          type: "confirm",
          name: "reexecute",
          message: `Do you want to execute the analysis on this updated Dockerfile?`,
          default: false,
        },
      ]);
      reexecute = reexecuteQ.reexecute;
    }
    if (reexecute) {
      console.log(`Executing analysis on ${repository}.`);
      info = await analyze({
        repository: `https://github.com/${owner}/${repo}`,
        dockerfilePath: path,
        workdirectory: join("/tmp", "dinghy-analysis", owner),
        repairedDockerfile: ast.toString(true),
      });
    }
    const analysisPath = join(outputPath, owner, repo, "analysis.json");
    await mkdir(dirname(analysisPath), { recursive: true });

    if (!existsSync(dirname(analysisPath))) {
      await mkdir(dirname(analysisPath), { recursive: true });
    }
    await writeFile(analysisPath, JSON.stringify(info), {
      encoding: "utf-8",
    });

    const forked = await forkRepository(repository, token, organization);
    const newBranchName = "improve_dockerfile";
    try {
      await createBranch(
        forked.url,
        token,
        forked.default_branch,
        newBranchName
      );
    } catch (error) {
      console.error(error.message);
    }
    try {
      await updateFile(
        forked.url,
        newBranchName,
        sha,
        token,
        path,
        ast.toString(true)
      );
    } catch (error) {
      console.error(error.message);
    }
    console.log(`Pull request created for ${repository}.`);
    console.log(`Body:\n`);

    console.log(generatePRBody(info, repo, violationsToRepair));

    console.log(
      `https://github.com/${owner}/${repo}/compare/${forked.default_branch}...${forked.owner.login}:${repo}:${newBranchName}`
    );
    // await createPullRequest(
    //   repository,
    //   token,
    //   organization,
    //   info,
    //   violationsToRepair
    // );
  } catch (error) {
    console.error(error);
    output.error = error.message;
  } finally {
    output.endTime = new Date().getTime();
    await writeFile(
      join(outputPath, owner, repo, "pr_creation.json"),
      JSON.stringify(output),
      {
        encoding: "utf-8",
      }
    );
  }
}

if (require.main === module) {
  main();
}
