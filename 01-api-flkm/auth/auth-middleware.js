const jwt = require("jsonwebtoken");

function authenticate(req, res, next) {
  // Get the secret key from the environment variable
  const secretKey = process.env.SECRET_KEY;

  // Get the token from the request header
  const tokenHeader = req.header("Authorization");

  // Remove the "Bearer " prefix
  const token = tokenHeader.replace("Bearer ", "");

  // Check if the token exists
  if (!token) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  try {
    // Verify the token
    const decoded = jwt.verify(token, secretKey);

    // Attach the user data to the request for further use
    req.user = decoded;
    next(); // Continue to the next middleware or route handler
  } catch (error) {
    res.status(400).json({ message: "Invalid token" });
  }
}

module.exports = authenticate;
