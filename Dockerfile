# Use official Node.js LTS image
FROM node:18

# Set working directory inside container
WORKDIR /usr/src/app

# Copy package files first (better for caching)
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy rest of the application code
COPY . .

# Expose the app port
EXPOSE 3000

# Run the application
CMD ["npm", "start"]
