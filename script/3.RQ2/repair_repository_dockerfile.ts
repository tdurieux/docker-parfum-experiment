import { basename, dirname, join } from "path";
import { existsSync } from "fs";
import { mkdir, rm, writeFile } from "fs/promises";
import { exec } from "child_process";

import { parseDocker } from "@tdurieux/dinghy";
import { Matcher, Violation } from "@tdurieux/docker-parfum";

import yargs from "yargs/yargs";
import { bytesToSize, msToReadableTime, percent } from "../utils";
import config from "../../config";

function repoName(repository: string) {
  return basename(repository).replace(".git", "");
}
function ownerName(repositoryUrl: string) {
  return repositoryUrl.split("/").at(-2);
}

export async function getCommit({
  repository,
  workdirectory,
}: {
  repository: string;
  workdirectory: string;
}): Promise<string> {
  const repo = repoName(repository);
  const repoPath = join(workdirectory, repo);
  return new Promise((resolve, reject) => {
    exec(`git rev-parse HEAD`, { cwd: repoPath }, (error, stdout, stderr) => {
      if (error) return reject(error);
      return resolve(stdout.trim());
    });
  });
}
export async function clone({
  repository,
  workdirectory,
}: {
  repository: string;
  workdirectory: string;
}): Promise<{
  stdout: string;
  stderr: string;
  error: any;
  commit?: string;
  startTime: number;
  endTime: number;
}> {
  const repo = repoName(repository);
  const repoPath = join(workdirectory, repo);
  await rm(repoPath, { recursive: true, force: true });
  const output: any = {
    startTime: new Date().getTime(),
  };
  return new Promise((resolve, reject) => {
    exec(
      `git clone --depth=1 ${repository} ${repoPath}`,
      async (error, stdout, stderr) => {
        output.stdout = stdout;
        output.stderr = stderr;
        output.error = error;
        output.endTime = new Date().getTime();

        if (error) return resolve(output);

        try {
          output.commit = await getCommit({ repository, workdirectory });
        } catch (error) {}
        return resolve(output);
      }
    );
  });
}

export async function buildDockerImage({
  repository,
  dockerfilePath,
  workdirectory,
}: {
  repository: string;
  dockerfilePath: string;
  workdirectory: string;
}): Promise<{
  startTime: number;
  endTime: number;
  error: any;
  stdout: string;
  stderr: string;
  imageSize?: number;
}> {
  const repo = repoName(repository);

  await removeDockerImage(repo);
  const dockerfile = join(workdirectory, repo, dockerfilePath);

  const startTime = new Date().getTime();

  const outputR: any = {
    startTime,
    endTime: undefined,
    error: null,
  };
  return new Promise((resolve, reject) => {
    exec(
      `docker build --no-cache --force-rm -t ${repo}:latest -f ${dockerfile} .`,
      { cwd: join(workdirectory, repo) },
      async (error, stdout, stderr) => {
        outputR.endTime = new Date().getTime();
        outputR.error = error;
        outputR.stdout = stdout;
        outputR.stderr = stderr;
        if (error) {
          return resolve(outputR);
        }
        outputR.imageSize = await imageSize(repo);
        return resolve(outputR);
      }
    );
  });
}

export async function repair({
  repository,
  dockerfilePath,
  workdirectory,
  repairedDockerfile,
}: {
  repository: string;
  dockerfilePath: string;
  workdirectory: string;
  repairedDockerfile?: string;
}): Promise<{
  startTime: number;
  endTime: number;
  error?: any;
  violations: {
    name: string;
    position: {
      start: number;
      end: number;
      columnStart: number;
      columnEnd: number;
    };
  }[];
  repairedDockerfile: string;
}> {
  const repo = repoName(repository);

  const outputR: Awaited<ReturnType<typeof repair>> = {
    startTime: new Date().getTime(),
    endTime: undefined,
    violations: [],
    repairedDockerfile: repairedDockerfile || "",
  };
  const dockerfile = join(workdirectory, repo, dockerfilePath);
  try {
    const ast = await parseDocker(dockerfile);
    const violations = new Matcher(ast).matchAll();

    if (!repairedDockerfile) {
      for (const v of violations) {
        await v.repair();
      }
      outputR.repairedDockerfile = ast.toString(true);
    }
    await writeFile(dockerfile, outputR.repairedDockerfile, {
      encoding: "utf-8",
    });
    outputR.violations = violations.map((v: Violation) => {
      return {
        name: v.rule.name,
        position: {
          start: v.node.position.lineStart,
          end: v.node.position.lineEnd,
          columnStart: v.node.position.columnStart,
          columnEnd: v.node.position.columnEnd,
        },
      };
    });
  } catch (error) {
    outputR.error = error;
  }
  outputR.endTime = new Date().getTime();
  return outputR;
}

async function existsDockerImage(repo: string) {
  return new Promise<boolean>((resolve, reject) => {
    exec(`docker image inspect ${repo}:latest`, (error, stdout, stderr) => {
      if (error) {
        return resolve(false);
      }
      return resolve(true);
    });
  });
}
async function removeDockerImage(repo: string) {
  if (!(await existsDockerImage(repo))) {
    return;
  }
  return new Promise<void>((resolve, reject) => {
    exec(`docker rmi ${repo}:latest`, (error, stdout, stderr) => {
      if (error) {
        return reject(error);
      }
      return resolve();
    });
  });
}

export async function clean({
  repository,
  workdirectory,
}: {
  repository: string;
  workdirectory: string;
}) {
  const repo = repoName(repository);

  // Remove the working directory
  await rm(join(workdirectory, repo), {
    recursive: true,
    force: true,
  });
  await removeDockerImage(repo);
}

export async function imageSize(repoName: string) {
  return new Promise<number>((resolve, reject) => {
    exec(
      `docker inspect -f "{{ .Size }}" ${repoName}:latest`,
      (error, stdout, stderr) => {
        if (error) {
          return reject(error);
        }
        return resolve(parseInt(stdout));
      }
    );
  });
}

export interface RepositoryAnalysisResult {
  repository: string;
  dockerfilePath: string;
  startTime: number;
  endTime: number;
  clone?: Awaited<ReturnType<typeof clone>>;
  originalBuild?: Awaited<ReturnType<typeof buildDockerImage>>;
  repairedBuild?: Awaited<ReturnType<typeof buildDockerImage>>;
  repair?: Awaited<ReturnType<typeof repair>>;
}
export async function analyze({
  repository,
  dockerfilePath,
  workdirectory,
  repairedDockerfile,
}: {
  repository: string;
  dockerfilePath: string;
  workdirectory: string;
  repairedDockerfile?: string;
}) {
  const outputR: RepositoryAnalysisResult = {
    repository,
    dockerfilePath,
    startTime: new Date().getTime(),
    endTime: undefined,
  };
  const name = `${ownerName(repository)}/${repoName(repository)}`;
  try {
    // clone the repository inside the working directory
    outputR.clone = await clone({ repository, workdirectory });

    // build the docker image
    outputR.originalBuild = await buildDockerImage({
      repository,
      dockerfilePath,
      workdirectory,
    });
    if (outputR.originalBuild.imageSize) {
      console.log(
        `\t[${name}] Original build \x1b[32m\u2713\x1b[0m: ${bytesToSize(
          outputR.originalBuild.imageSize
        )} in ${msToReadableTime(
          outputR.originalBuild.endTime - outputR.originalBuild.startTime
        )}`
      );
    } else {
      console.log(
        `\t[${name}] Original build \x1b[31m\u2717\x1b[0m: \x1b[31mFAILED\x1b[0m in ${msToReadableTime(
          outputR.originalBuild.endTime - outputR.originalBuild.startTime
        )}`
      );
    }
    if (outputR.originalBuild.error) {
      return;
    }
    outputR.repair = await repair({
      repository,
      dockerfilePath,
      workdirectory,
      repairedDockerfile,
    });
    console.log(
      `\t[${name}] Repaired: ${
        outputR.repair.violations.length
      } violations in ${msToReadableTime(
        outputR.repair.endTime - outputR.repair.startTime
      )}`
    );
    if (outputR.repair.violations.length === 0) {
      return;
    }
    outputR.repairedBuild = await buildDockerImage({
      repository,
      dockerfilePath,
      workdirectory,
    });

    if (outputR.repairedBuild.imageSize) {
      console.log(
        `\t[${name}] Repaired build \x1b[32m\u2713\x1b[0m: ${bytesToSize(
          outputR.repairedBuild.imageSize
        )} in ${msToReadableTime(
          outputR.repairedBuild.endTime - outputR.repairedBuild.startTime
        )}`
      );
    } else {
      console.log(
        `\t[${name}] Repaired build \x1b[31m\u2717\x1b[0m: \x1b[31mFAILED\x1b[0m in ${msToReadableTime(
          outputR.repairedBuild.endTime - outputR.repairedBuild.startTime
        )}\n\t\tERROR: ${outputR.repairedBuild.stderr
          ?.trim()
          .split("\n")
          .at(-1)}`
      );
    }

    console.log(
      `\t[${name}] \x1b[4mDifference\x1b[0m: ${bytesToSize(
        Math.abs(
          outputR.originalBuild.imageSize - outputR.repairedBuild.imageSize
        )
      )} (${percent(
        Math.abs(
          outputR.originalBuild.imageSize - outputR.repairedBuild.imageSize
        ),
        outputR.originalBuild.imageSize
      )}), ${msToReadableTime(
        Math.abs(
          outputR.originalBuild.endTime -
            outputR.originalBuild.startTime -
            (outputR.repairedBuild.endTime - outputR.repairedBuild.startTime)
        )
      )} (${percent(
        Math.abs(
          outputR.originalBuild.endTime -
            outputR.originalBuild.startTime -
            (outputR.repairedBuild.endTime - outputR.repairedBuild.startTime)
        ),
        outputR.originalBuild.endTime - outputR.originalBuild.startTime
      )})`
    );
  } catch (e) {
    console.error(e);
  } finally {
    await clean({ repository, workdirectory });
    outputR.endTime = new Date().getTime();
    return outputR;
  }
}

async function main() {
  const argv = await yargs(process.argv.slice(2))
    .option("repository", {
      type: "string",
      demandOption: true,
      description: "The git repository to analyze and repair",
    })
    .option("dockerfile", {
      type: "string",
      default: "/Dockerfile",
      description: "Path to the dockerfile in the repository",
    })
    .option("workdirectory", {
      alias: "w",
      type: "string",
      default: "/tmp/dinghy-experiment",
      description: "Path to the working directory",
    })
    .option("output", {
      type: "string",
      default: config.defaultBuildDockerfileOutputPath,
    }).argv;

  const repository = argv.repository;
  const dockerfile = argv.dockerfile;
  const output = join(
    argv.output,
    ownerName(repository),
    `${repoName(repository)}.json`
  );
  const workdirectory = argv.workdirectory;

  const outputR = await analyze({
    repository,
    dockerfilePath: dockerfile,
    workdirectory,
  });

  if (!existsSync(dirname(output))) {
    await mkdir(dirname(output), { recursive: true });
  }
  await writeFile(output, JSON.stringify(outputR), {
    encoding: "utf-8",
  });
}

if (require.main === module) {
  (async () => {
    try {
      await main();
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  })();
}
