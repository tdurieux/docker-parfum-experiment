import { readFile } from "fs/promises";
import { percent } from "../../utils";
import parfum from "@tdurieux/docker-parfum";

(async () => {
  const supportedCommandNames: string[] = parfum.enricher.supportedCommands
    .map((cmd) => cmd.providerFor)
    .flat();

  const commands: { [key: string]: number } = JSON.parse(
    await readFile("command_usage.json", "utf-8")
  );
  let totalCommand = Object.values(commands).reduce((a, b) => a + b, 0);
  let supportedCommand = 0;
  for (let cmd of Object.keys(commands).sort(
    (a, b) => commands[b] - commands[a]
  )) {
    const usage = commands[cmd];
    const normalizedCmd = cmd
      .replace("/usr/local/bin/", "")
      .replace("/usr/bin/", "")
      .replace("/bin/", "");
    if (supportedCommandNames.includes(normalizedCmd)) {
      supportedCommand += usage;
    }
    if (usage < 100) continue;
    console.log(cmd, usage, percent(usage, totalCommand));
  }

  console.log("Supported commands", percent(supportedCommand, totalCommand));
})();
