// emailService.js
const nodemailer = require("nodemailer");
require("dotenv").config();

// Configure your email service provider using environment variables
const transporter = nodemailer.createTransport({
  service: "Gmail",
  auth: {
    // user: process.env.EMAIL_SENDER_USER,
    // pass: process.env.EMAIL_SENDER_PASSWORD,
    user: "steven.robbins.000@gmail.com",
    pass: "hrrremzkwrzazsek",
  },
});

// Function to send a verification email
const sendVerificationEmail = (recipientEmail, verificationToken) => {
  const mailOptions = {
    from: "your_email@example.com",
    to: recipientEmail,
    subject: "Email Verification",
    text: `Click on this link to verify your email: http://localhost:3000/api/verify-email/${verificationToken}`,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error("Error sending verification email:", error);
    } else {
      console.log("Verification email sent:", info.response);
    }
  });
};

module.exports = { sendVerificationEmail };
