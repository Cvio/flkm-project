const mongoose = require("mongoose");

const projectSchema = new mongoose.Schema({
  projectName: {
    type: String,
    required: true,
  },
  description: {
    type: String,
  },
  dataset: {
    type: String, // Assuming a string field for the dataset, you can adjust this based on your requirements
  },
  modelType: {
    type: String,
    default: "classification", // Default to classification if not provided
  },
  learningRate: {
    type: Number,
    default: 0.01, // Default learning rate if not provided
  },
  privacySettings: {
    type: String,
  },
  participants: {
    type: String, // Assuming a string field for participants, you can adjust this based on your requirements
  },
  startDate: {
    type: Date, // Assuming a date field for start date, you can adjust this based on your requirements
  },
  endDate: {
    type: Date, // Assuming a date field for end date, you can adjust this based on your requirements
  },
  accessControl: {
    type: String,
  },
  dataPreprocessing: {
    type: String,
  },
  evaluationMetrics: {
    type: String,
    default: "accuracy", // Default to accuracy if not provided
  },
  acceptanceCriteria: {
    type: Number,
    default: 0.8, // Default to 0.8 if not provided
  },
});

const Project = mongoose.model("Project", projectSchema);

module.exports = Project;
