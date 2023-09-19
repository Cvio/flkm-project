const fs = require("fs");
const path = require("path");

const components = [
  "authentication/registration",
  "authentication/login",
  "Dashboard/dashboard",
  "Dashboard/accountBalance",
  "Project/projectList",
  "Project/projectDetails",
  "Project/projectParticipants",
  "Project/datasetUpload",
  "Training/startTraining",
  "Training/stopTraining",
  "Training/uploadModels",
  "Evaluation/setEvaluationCriteria",
  "Evaluation/trainingResults",
  "Security/eryption",
  "Security/compliance",
  "Security/IPFSDataStorage",
  "Security/FilecoinDataStorage",
  "FLKM/ResourceList",
  "FLKM/UploadResource",
  "FLKM/ResourceDetails",
  "FLKM/AccessControl",
  "FLKM/SmartContracts",
  "Collaboration/CollaborationList",
  "Collaboration/CollaborationDetails",
  "Collaboration/Contribution",
  "Collaboration/Rewards",
  "Monetization/DataMonetizationTerms",
  "Monetization/DataTracking",
  "Monetization/TransactionRecords",
  "Monetization/PayoutRequest",
  "ModelRepository/ModelList",
  "ModelRepository/ModelDetails",
  "ModelRepository/ModelAccessControl",
  "ModelRepository/ModelVersionControl",
  "Shared/NavigationBar",
  "Shared/Footer",
  "Shared/ModalDialog",
  "Shared/UserProfile",
];

function createComponentDirectories(components) {
  components.forEach((componentPath) => {
    const componentFolderPath = path.join(
      __dirname,
      "02-ui-flkm/src/app/components",
      componentPath
    );
    fs.mkdirSync(componentFolderPath, { recursive: true });
    console.log(`Created directory: ${componentFolderPath}`);
  });
}

function createServiceDirectories(components) {
  components.forEach((componentPath) => {
    const serviceFolderPath = path.join(
      __dirname,
      "02-ui-flkm/src/app/services",
      componentPath
    );
    fs.mkdirSync(serviceFolderPath, { recursive: true });
    console.log(`Created directory: ${serviceFolderPath}`);
  });
}

function generateComponentFiles(components) {
  components.forEach((componentPath) => {
    const componentName = path.basename(componentPath);
    const componentFilePath = path.join(
      __dirname,
      "02-ui-flkm/src/app/components",
      componentPath,
      `${componentName}.component.ts`
    );

    const componentContent = `import { Component, OnInit } from '@angular/core';

@Component({
  selector: '${componentName}-component',
  templateUrl: './${componentName}.component.html',
  styleUrls: ['./${componentName}.component.css']
})
export class ${componentName}Component implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

}`;

    const componentHtmlFilePath = path.join(
      __dirname,
      "02-ui-flkm/src/app/components",
      componentPath,
      `${componentName}.component.html`
    );

    const componentHtmlContent = `<p>${componentName} works!</p>`;

    const componentCssFilePath = path.join(
      __dirname,
      "02-ui-flkm/src/app/components",
      componentPath,
      `${componentName}.component.css`
    );

    const componentCssContent = `/* Add your component-specific styles here */`;

    fs.writeFileSync(componentFilePath, componentContent);
    fs.writeFileSync(componentHtmlFilePath, componentHtmlContent);
    fs.writeFileSync(componentCssFilePath, componentCssContent);

    console.log(`Generated component files for: ${componentPath}`);
  });
}

function generateServiceFiles(components) {
  components.forEach((componentPath) => {
    const componentName = path.basename(componentPath);
    const serviceFilePath = path.join(
      __dirname,
      "02-ui-flkm/src/app/services",
      componentPath,
      `${componentName}.service.ts`
    );

    const serviceContent = `import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ${componentName}Service {
  constructor() { }
}
`;
    fs.writeFileSync(serviceFilePath, serviceContent);
    console.log(`Generated service file for: ${componentPath}`);
  });
}

createComponentDirectories(components);
createServiceDirectories(components);
generateComponentFiles(components);
generateServiceFiles(components);

console.log("Generation completed.");
