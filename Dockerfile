# Stage 1: Build the Node.js application
FROM node:latest AS build
WORKDIR /app
# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install
# Copy the rest of the application code and build
COPY . .
RUN npm run build

# Stage 2: Serve the compiled application with Nginx
FROM nginx:latest
# Copy the built artifacts from the 'build' stage to Nginx's default public directory
# Note: Change '/app/dist/' to your framework's build output folder if it differs (e.g., /app/build/)
COPY --from=build /app/dist/ /usr/share/nginx/html/
EXPOSE 80
