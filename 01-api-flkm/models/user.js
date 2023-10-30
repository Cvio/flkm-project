const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

const userSchema = new mongoose.Schema({
  username: { type: String, unique: true, required: true },
  email: { type: String, unique: true, required: true },
  password: { type: String, required: true },
  emailVerificationToken: { type: String, unique: true, sparse: true }, // sparse: true allows multiple documents without a token
  emailVerified: { type: Boolean, default: false },
  emailVerificationTokenExpiresAt: { type: Date, default: undefined },
  ethereumAddress: { type: String, unique: true, sparse: true },
});

// Hash the password before saving
userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();

  const salt = await bcrypt.genSalt(10);
  //this.password = await bcrypt.hash(this.password, salt);

  next();
});

const User = mongoose.model("User", userSchema);

module.exports = User;
