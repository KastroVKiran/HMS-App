# Use official Node.js image as base
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the application
COPY . .

# Build the React app
RUN npm run build

# Use Nginx to serve the build
FROM nginx:stable-alpine

# Copy build files to Nginx public folder
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom Nginx config to change port
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose custom port
EXPOSE 1111

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
