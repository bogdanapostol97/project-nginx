<h1> Project Documentation </h1> 

<h2> Overview </h2>

This web application allows users to submit feedback or bug reports via a simple form. It consists of a front-end component built with HTML, CSS, and JavaScript.

The project aims to create a CI/CD pipeline for deploying the HTML file as an NGINX Docker image to an S3 bucket. The deployed application can be accessed through the public IP of the EC2 instance.

<h2> Tech Stack </h2> 

- HTML, CSS, JavaScript
- AWS EC2 Ubuntu
- Docker
- Github Actions for Pipelines

<h2> Deployment </h2>

The application is deployed using the following pipeline steps:

1. Checkout code from the repository.
2. Build and push a Docker image to Docker Hub.
3. Upload the Docker image as a tar file to an AWS S3 bucket.
4. Pull the Docker image from the S3 bucket and load it into a Docker container.
5. Start the Docker container on the AWS EC2 instance, deploying the application.
6. Access the application using HTTPS.
7. The pipeline is triggered automatically when changes are pushed to the main branch.

<h2> Code explanation </h2>

1. main.yaml: This GitHub Actions pipeline deploys a Docker container to an Amazon S3 bucket and then to an AWS EC2 Linux instance. It consists of two jobs: build and deploy.

  - The build job:
    a. Checks out the source code.
    b. Logs in to Docker Hub.
    c. Builds and pushes the Docker image.
    d. Configures AWS credentials.
    e. Uploads the Docker image to an S3 bucket.
   
  - The deploy job:
    a. Starts the Docker container on the specified server.
    b. Removes existing containers with the same name.
    c. Downloads and loads the Docker image.
    d. Starts a Docker container with port mapping and environment variable setup.

2. Dockerfile: Instructions to build the Docker image for the application.
    a. Uses the latest Ubuntu image.
    b. Sets the working directory.
    c. Updates packages and installs Nginx.
    d. Copies Nginx configuration and HTML template files.
    e. Exposes port 80 and specifies the command to start Nginx.

3. index.html: HTML code for the feedback form.
4. nginx.conf: Example configuration for an NGINX server.

<h2> Improvements </h2>

To enhance the pipeline, it is recommended to configure AWS credentials using an IAM user with an assigned IAM role. This provides better granularity and allows for easy role transfer in case of personnel changes within the organization.

<h2> Conclusion </h2>

This project is a simple web application enabling users to submit feedback or bug reports. With a modern tech stack and a robust CI/CD pipeline, the application is deployed efficiently, ensuring high quality and reliability.
