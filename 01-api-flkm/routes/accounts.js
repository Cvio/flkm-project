require("dotenv").config();
const {
  Client,
  PrivateKey,
  AccountCreateTransaction,
  AccountBalanceQuery,
  Hbar,
} = require("@hashgraph/sdk");

const express = require("express");
const router = express.Router();
const User = require("../models/user.model");
