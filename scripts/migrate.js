const fs = require("fs");
const { execSync } = require("child_process");

// Delete folder
try {
  fs.rmSync("./build/contracts", { recursive: true, force: true });
  console.log("Folder ./build/contracts has been deleted!");
} catch (error) {
  console.error(`An error occurred: ${error.message}`);
}

console.log("Deleted build, now compiling contracts...");

// Introduce a pause of 4 seconds (4000 milliseconds)
const sleepMilliseconds = 4000;
const end = Date.now() + sleepMilliseconds;
while (Date.now() < end) {
  // Busy-wait
}

// Run migration
try {
  const stdout = execSync("truffle migrate --reset");
  console.log(`stdout: ${stdout.toString()}`);
} catch (error) {
  console.error(`Error executing the command: ${error}`);
}
