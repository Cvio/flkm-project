const fs = require("fs");
const path = require("path");

const listFiles = (startPath, indent = 0) => {
  const files = fs.readdirSync(startPath);

  files.forEach((file) => {
    const filePath = path.join(startPath, file);
    const stats = fs.statSync(filePath);

    if (stats.isDirectory()) {
      console.log(" ".repeat(indent * 4) + file + "/");
      listFiles(filePath, indent + 1);
    } else {
      console.log(" ".repeat(indent * 4 + 4) + file);
    }
  });
};

// Replace 'your_directory_path_here' with the directory you want to explore
listFiles("./contracts");
