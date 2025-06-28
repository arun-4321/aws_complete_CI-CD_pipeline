# AWS_complete_CI-CD_pipeline

## Overview

This repository contains the source code for a simple Python application. We have set up a **Continuous Integration (CI)** and **Continuous Deployment (CD)** process using **AWS CodePipeline**, **AWS CodeBuild**, and **AWS CodeDeploy**.

The CI/CD pipeline automatically builds, tests, and deploys the application when changes are pushed to this GitHub repository. The deployment targets an **EC2 instance**, where the application is **pulled via Docker** and executed.

---

## Prerequisites

Before setting up the CI/CD pipeline, ensure you have:

- An **AWS account**
- A **GitHub account**
- Permission to create and manage:
  - CodePipeline
  - CodeBuild
  - CodeDeploy
  - EC2 instances
- A provisioned **EC2 instance** with:
  - An IAM role that allows access to CodeDeploy and S3
  - **Docker** installed and running
  - **CodeDeploy agent** installed and running

---

## Step 1: Set Up GitHub Repository

1. Go to [GitHub](https://github.com) and sign in.
2. Create a new repository for your Python application.
3. Clone the repository locally and push your source code.
4. Include a `buildspec.yml` and `appspec.yml` file (details below).

---

## Step 2: Create AWS CodePipeline

1. Go to the **AWS Management Console** > **CodePipeline** > **Create pipeline**.
2. Name your pipeline.

### Source Stage:
- Source provider: **GitHub**
- Connect to your GitHub account and select the repository and branch

### Build Stage:
- Build provider: **AWS CodeBuild**
- Create a new project or choose an existing one
- Follow the setup in Step 3

### Deploy Stage:
- Deploy provider: **AWS CodeDeploy**
- Application name: Create or use existing
- Deployment group: Choose the group targeting your EC2 instance

3. Review and create the pipeline.

---

## Step 3: Configure AWS CodeBuild

1. Navigate to **AWS CodeBuild** > **Create build project**
2. Project settings:
   - Name your project
   - Source provider: **AWS CodePipeline**

### Build Environment:
- OS: Ubuntu or Amazon Linux
- Runtime: **Standard** with Python
- Environment type: Managed image
- Compute: Based on your app requirements

### Buildspec:
- Provide a `buildspec.yml` in your repo.

- # Step 4: Configure AWS CodeDeploy (CD)

## In AWS Console

1. Go to **CodeDeploy**.
2. Create a new **application** with platform: `EC2/On-premises`.
3. Create a **deployment group**:
   - Select your EC2 instances (use tags or manual selection)
   - Attach the necessary IAM role
   - Enable **CodeDeploy agent** on the EC2 instance

## On EC2: Install CodeDeploy Agent

Run the following commands on your EC2 instance:

```bash
sudo yum update -y
sudo yum install ruby wget -y
cd /home/ec2-user
wget https://bucket-name.region.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start```



# Step 5: Add AppSpec and Deployment Scripts

Ensure the following are already present in your repository:

- `appspec.yml` file in the root directory, configured to copy files to the EC2 instance and trigger the deployment script after installation.
- `scripts/deploy.sh` file under the `scripts/` directory. This script should handle stopping the existing container, rebuilding the Docker image, and restarting the application.

Make sure the deployment script is executable (`chmod +x scripts/deploy.sh`) and committed to your GitHub repository.

These files are used by **AWS CodeDeploy** during the deployment phase of the pipeline to automate delivery to your EC2 instance.

---

# Step 6: Trigger the CI/CD Pipeline

To initiate the deployment process:

1. Make a change to your application code or configuration.
2. Commit and push the changes to the GitHub branch connected to your AWS CodePipeline.
3. AWS CodePipeline will automatically:
   - Fetch the source from GitHub.
   - Run the build process via CodeBuild.
   - Deploy the updated application to the EC2 instance using CodeDeploy.

After deployment, verify that the application is running correctly on your EC2 instance by accessing its public IP or DNS.

---

#  Conclusion

- This setup automates both CI and CD for your Python application.
- Every code push initiates a full build–test–deploy cycle.
- Docker provides consistency, while CodeDeploy handles seamless updates.

