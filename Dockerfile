# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set the working directory
WORKDIR /app

# Update the package lists and install Nginx
RUN apt-get update && apt-get install -y nginx

# Copy the Nginx configuration file to the container
COPY nginx.conf /etc/nginx/sites-available/default

# Copy the HTML template file to the container
COPY index.html /var/www/html/

# Expose port 80 for incoming connections
EXPOSE 80

# Start Nginx service when the container starts
CMD ["nginx", "-g", "daemon off;"]

