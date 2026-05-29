# Use a stable Node.js LTS version (Hardhat compatible)
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy dependency files first (better caching)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy rest of the project files
COPY . .

# Compile contracts (optional but recommended)
RUN npx hardhat compile

# Default command: run test suite
CMD ["npx", "hardhat", "test"]
