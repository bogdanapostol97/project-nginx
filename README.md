Project Documentation

Overview

This project is a web application that allows users to submit feedback or bug reports. The application consists of a front-end component built using HTML, CSS, and JavaScript thatallows users to submit their feedback or bug reports using a simple form. 

Goal

The ultimate goal of the project was to be able to create the CI/CD pipeline through which to deploy the HTML file used for the NGINX docker image to an S3 bucket and to be able to access it through the public IP of the EC2 instance on which the image is built.

Deployment

The application is deployed using a pipeline that consists of several steps:

1. The code is checked out from the repository.
2. A Docker image is built and pushed to Docker Hub.
3. The Docker image is saved as a tar file and uploaded to an AWS S3 bucket.
4. The Docker image is pulled from the S3 bucket and loaded into a Docker container.
5. The Docker container is started on the AWS EC2 instance and the application is deployed. We can access the application using https:
6. The pipeline is triggered automatically whenever changes are pushed to the main branch of the repository.

Code explanation

1. main.yaml - This is a GitHub Actions pipeline that deploys a Docker container to an Amazon S3 bucket and then deploys the container to an AWS EC2 Linux instance The pipeline is triggered by a push event to the main branch. 

The pipeline consists of two jobs: build and deploy.

a. The build job uses an Ubuntu 22.04 runner and performs the following steps:

- Initial checkout: This step checks out the source code from the repository.
- Login to Docker Hub: This step logs in to Docker Hub using the Docker Hub username and password stored as secrets in the repository settings.
- Print working directory: This step prints the current working directory in the runner.
- Build & push docker image: This step builds a Docker image using the Dockerfile in the root directory of the repository and then pushes the image to Docker Hub. It also saves the Docker image as a tar file named project-nginx.tar.
- Configure AWS credentials: This step configures the AWS credentials using the AWS access key ID and AWS secret access key stored as secrets in the repository settings.
- Push Docker image to AWS S3: This step uses the AWS CLI to upload the Docker image tar file to an Amazon S3 bucket.

b. The deploy job runs on the same Ubuntu 22.04 runner and depends on the build job. It performs the following steps:

- Start the docker container: This step uses the SSH Action to connect to the server specified in the repository secrets and start the Docker container by performing the following operations:
  - Remove any existing Docker containers with the same name.
  - Download the Docker image tar file from the S3 bucket.
  - Load the Docker image from the tar file.
  - Start a Docker container with the loaded image, mapping port 80 of the host to port 80 of the container and specifying the environment variable Port=80.

2. Dockerfile -a set of instructions used to build the Docker image for the application.
- FROM ubuntu:latest: This instruction specifies the base image to use for the Docker container. In this case, it uses the latest version of the Ubuntu image.
- WORKDIR /app: This instruction sets the working directory to /app.
- RUN apt-get update && apt-get install -y nginx: This instruction updates the package lists and installs Nginx web server.
- COPY nginx.conf /etc/nginx/sites-available/default: This instruction copies the Nginx configuration file to the container. The file is copied to the location /etc/nginx/sites-available/default, which is the default location for Nginx configuration files.
- COPY index.html /var/www/html/: This instruction copies the HTML template file to the container. The file is copied to the location /var/www/html/, which is the default location for web content served by Nginx.
- EXPOSE 80: This instruction exposes port 80 on the Docker container to allow incoming connections.
- CMD ["nginx", "-g", "daemon off;"]: This instruction specifies the command to be run when the Docker container starts. In this case, it starts the Nginx service with the -g "daemon off;" flag to keep the service running in the foreground.

3. index.html - The HTML code that is a simple form that allows users to submit feedback or report issues. 
4. nginx.conf - This is an example configuration for an NGINX server that listens on port 80 and serves requests for the server name "localhost". The server block contains a single location block that specifies how NGINX should handle requests for the root URL "/".

The "root" directive specifies the location on the server's file system where NGINX should look for the files to serve in response to requests. In this case, the root is set to "/var/www/html", which means NGINX will look for files in the "/var/www/html" directory.

The "index" directive specifies the default file that NGINX should serve if a request is made for a directory instead of a specific file. In this case, the default file is "index.html", which means that if a request is made for "/", NGINX will look for an "index.html" file in the root directory specified by the "root" directive.

So, when a user makes a request to this server on port 80 and the server_name matches "localhost", NGINX will look for an "index.html" file in the "/var/www/html" directory and serve it in response to the request.

Improvements

In the pipeline it would be useful to configure the credentials in AWS so that we use an IAM user that has an IAM role set in AWS. This method is more granular and gives admins the ability that when the pipeline owner leaves the organization to assign that role with those permissions to another user. For now the pipeline uses my user with its specific secrets. If I were to work in a company and leave that company, then the secrets would have to be changed and it would be more time consuming. 

Conclusion

This project is a simple web application that allows users to submit feedback or bug reports. The application is built using a modern tech stack and is deployed using a pipeline that ensures the highest level of quality and reliability.
