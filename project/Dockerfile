# Use the official Apache image as the base image
FROM httpd:latest

# Copy the website files into the Apache web root directory
COPY ./website/ /usr/local/apache2/htdocs/

# Expose port 80 for HTTP traffic
EXPOSE 80

# The Apache image already has a default CMD to start Apache, so no need to specify it
