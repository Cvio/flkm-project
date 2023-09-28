const nodemailer = require("nodemailer");

// Set up nodemailer transporter
// Consider using environment variables to store email and password
const transporter = nodemailer.createTransport({
  service: "gmail", // replace with your email provider
  auth: {
    user: process.env.GMAIL, // Use environment variables
    pass: process.env.GMAIL_PW, // Use environment variables
  },
});

const sendVerificationEmail = async (recipientEmail, token) => {
  const verificationLink = `http://localhost:4200/verify-email/${token}`; // Replace with your Frontend URL

  const mailOptions = {
    from: process.env.GMAIL, // Use environment variables
    to: recipientEmail,
    subject: "Email Verification",
    text: `Please verify your email by clicking the following link: ${verificationLink}`,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`Verification email sent to ${recipientEmail}`);
  } catch (error) {
    console.error("Error sending verification email:", error);
  }
};

module.exports = {
  sendVerificationEmail,
};
