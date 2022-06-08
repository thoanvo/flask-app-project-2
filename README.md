[![Actions Status](https://github.com/thoanvo/flask-app-project-2/workflows/Python%20application%20test%20with%20Github%20Actions/badge.svg)](https://github.com/thoanvo/flask-app-project-2/actions)

# Table of Contents

- **[Overview](#Overview)**

- **[Project Plan](#Project-Plan)**

- **[Architecture Diagram](#Architecture-Diagram)**

- **[Configuring Github](#Configuring-Github)**

- **[Instructions](#Instructions)**
  
  - **[Configuring Github](#Configuring-Github)**

  - **[Project Locally](#Project-Locally)**
  
  - **[Project Azure App Service](#Project-Azure-App-Service)**

    - **[ML Azure App Service](#ML-Azure-App-Service)**
  
  - **[Github Actions](#Github-Actions)**
  
  - **[Azure DevOps](#Azure-DevOps)**
  
    - **[Set Up Azure Pipelines for Continuous Delivery](#Set-Up-Azure-Pipelines-for-Continuous-Delivery)**

    - **[Azure Pipeline App](#Azure-Pipeline-App)**

    - **[Clean up resources](#Clean-up-resources)**

- **[Enhancements](#Enhancements)**

- **[Demo](#Demo)**

## Overview

In this project, We will build a Github repository from scratch and create a scaffolding in performing both Continuous Integration and Continuous Delivery.
- Using Github Actions along with a Makefile, requirements.txt and application code to perform an initial lint, test, and install cycle.
- Integrating this project with Azure Pipelines to enable Continuous Delivery to Azure App Service.
- Using Azure Cloud shell in this project.

## Project Plan

- [Trello Board](https://trello.com/b/vuyYKnJH/agile-sprint-board-for-nd082)
- [Original Project Plan](documents/Original-Project-Plan.xlsx)
- [Final Project Plan](documents/Final-Project-Plan.xlsx)

## Architecture Diagram

[Architectural Diagram](screenshots/architecture.png)

## Instructions
### Configuring Github

- Log into Azure Cloud Shell

- Create a ssh key

    ```bash
    ssh-keygen -t rsa -b 2048 -C "thoanvtt@gmail.com"
    ```
  ![Screenshot of SSH Key in Azure Cloud Shell](screenshots/git-ssh-key-in-azure.png)

- Copy the public key to your Github Account -> Settings ->  SSH and GPG keys (https://github.com/settings/keys)
  ![Screenshot of SSH Key in Github](screenshots/git-ssh-key.png)

- Once your public key is in Github, we can download the source code to Azure Cloud Shell

  ![Screenshot of Git Clone](screenshots/git-clone-ssh-succ.png)

### Project Locally

- Clone the project (In this project we used Azure Cloud Shell)

 ![Screenshot of Clone the project](screenshots/clone-the-project.png)

- Create a Python Virtual Environment to run your application

  ```bash
    python3 -m venv ~/.flask-ml-project-2
    source ~/.flask-ml-project-2/bin/activate
  ```

 - Install dependencies
   ```bash
    make all
    ```
  
  ![Screenshot of Make All Command](screenshots/make-all-result.png)

- Run application
    ```bash
    export FLASK_APP=app.py
    flask run
    ```
    
  ![Screenshot Local Run](screenshots/application-local-run.png)

- Above step would launch a Python Virtual Environment and would run the application. Launch a new Azure Cloud shell session and test the application by running the make_prediction.sh script

    ```bash
    ./make_prediction.sh
    {"prediction":[20.35373177134412]}
    ```
    ![Screenshot ML Prediction Local Test](screenshots/application-local-run-test.png)

- ```CTRL-C``` to stop the Flask application

- To deactivate the virtual environment run ```deactivate```

### Azure App Service

Azure App Service is a PASS solution provided by Azure which enables to quickly deploy web apps, mobile back-ends and RESTful API's without managing the infrastructure. Below are some of the advantages

- Support multiple languages(Java, Python, C#) and frameworks(.NET, Spring boot, Flask)

- High Availability and Scalability

- Supports both Windows and Linux OS

- Very good integration with Azure pipelines for Continuous Delivery

For more information and Tutorials please refer
[Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/)

#### ML Azure App Service

Azure App service offers multiple ways to create a new application. In this section we will be using the Azure CLI to deploy our app. In the another section we will show how to use the Azure Pipelines to deploy our application.

**Set up Azure CLI:**

- Create a new Resource Group for our app

   ```bash
    az group create --name vothoan2014_rg_0674 --location eastus
    ```

**Deploy Application:**

- Clone the project (In this project we used Azure Cloud Shell)

- Create a Python Virtual Environment to run your application

    ```bash
        python3 -m venv ~/.flask-ml-project-2
        source ~/.flask-ml-project-2/bin/activate
    ```

 - Install dependencies
   ```bash
    make all
    ```
    ![Screenshot of Make all command](screenshots/make-all-result.png)
    
- Deploy application into the our resource group

    ```bash
    az webapp up -n flask-app-thoanvtt --resource-group vothoan2014_rg_0674 --sku FREE
    ```

- Our application will be deployed and available at
  **(https://${app-name}azurewebsites.net)** default port is 443

  ![Screenshot of application available](screenshots/application-avaiable.png)
  
 - Azure app service from the Azure portal
  ![Screenshot of Azure app service from the Azure portal](screenshots/azure-app-service-from-portal.png)
  
  - Web application was deployed successfully using azure pipelines from Deployment Center
  ![Screenshot of Azure app service from the Deployment Center](screenshots/azure-app-service-deployment-center-portal.png)

**Test ML Application:**

- Edit the ```make_predict_azure_app.sh``` with the correct host name of the application to match the deployed prediction
![Screenshot of Edit Host Name](screenshots/edit-hostname.png)

- Run the script to test the app

    ```bash
        ./make_predict_azure_app.sh
        {"prediction":[20.35373177134412]}
    ```

  ![Screenshot of Test Result](screenshots/make-predict-azure-app-test.png)


**Logs of Azure Webapp:**

Azure App service provides ability to view the application logs. Application logs was be accessed using Azure CLI commands
    ```
    az webapp log tail --name flask-app-thoanvtt --resource-group vothoan2014_rg_0674
    ```

![Screenshot of Logs](screenshots/az-webapp-log.png)

### Github Actions

Github actions is a feature of Github to do a complete CI/CD workflow. In this project we use Github actions to do our Continuous Integration workflow. We build, lint and test the code using Github actions.

- In your Git Repository, go to Actions Tab -> New Workflow -> Python Application Workflow ***Git hub can analyze your code and bring relevant workflow for your code***
![Github Actions Setup](screenshots/github-action-setup.png)

- Continue with the process, and Github Actions workflow will be setup for our code

- We will have to customize the actions for our needs. The default action steps will run the python commands, since we are using *Make* to 
build, test and lint our code we will modify the Github actions code.

- Edit the .github/workflows/python-app.yml

    ```yml
    # This workflow will install Python dependencies, run tests and lint with a single version of Python
    # For more information see: https://help.github.com/actions/language-and-framework-guides/using-python-with-github-actions
    
    name: Python application

    on:
    push:
        branches: [ "main" ]
    pull_request:
        branches: [ "main" ]

    permissions:
    contents: read

    jobs:
    build:

        runs-on: ubuntu-latest

        steps:
        - uses: actions/checkout@v3
        - name: Set up Python 3.7.13
        uses: actions/setup-python@v3
        with:
            python-version: "3.7.13"
        - name: Install dependencies
        run: |
            make install
        - name: Lint with Pylint
        run: |
            make lint
        - name: Test with pytest
        run: |
            make test
    ```

- Run the Action Manually. Once successfully launched you will see the result below
![Github Actions Result](screenshots/github-action-build-succ.png)

- Once the workflow is setup we will be able to Continuously build our application for every push or pull request on our main branch

### Azure DevOps

Azure DevOps provides developer services for allowing teams to plan work, collaborate on code development, and build and deploy applications. Azure DevOps supports a collaborative culture and set of processes that bring together developers, project managers, and contributors to develop software. It allows organizations to create and improve products at a faster pace than they can with traditional software development approaches.

- Azure Repos provides Git repositories or Team Foundation Version Control (TFVC) for source control of your code.

- Azure Pipelines provides build and release services to support continuous integration and delivery of your applications. 

- Azure Boards delivers a suite of Agile tools to support planning and tracking work, code defects, and issues using Kanban and Scrum methods.

- Azure Test Plans provides several tools to test your apps, including manual/exploratory testing and continuous testing.

- Azure Artifacts allows teams to share packages such as Maven, npm, NuGet, and more from public and private sources and integrate package sharing into your pipelines. 

#### Set Up Azure Pipelines for Continuous Delivery

In this project we use Azure Pipelines for Continuous Delivery of Flask ML App.

- Navigate to [dev.azure.com](https://dev.azure.com) and sign in. You might have to create a Free Account if you don't have a Azure DevOps account

- Create an Azure DevOps project. We'll need to create an Azure DevOps project and connect to Azure. The screenshots below show the steps

- Create an Azure DevOps project and connect to Azure

  ![Azure Project Create](screenshots/devops-create-new-project.png)

- Once the project is created, from the new project page, select Project settings from the left navigation. On the Project Settings page, select Pipelines > Service connections, then select New service connection
![Azure Project Settings](screenshots/new-service-connection.png)

- In the New Service Connections dialog, select Azure Resource Manager from the dropdown.
![New ARM](screenshots/azure-resource-manager.png)

- In the Service Connection dialogue box
  1. Select scope level as Subscription
  
  2. You might need to log in

  3. Pick the Resource Group of the Azure Web App deployed
  
  4. Input a valid Service Connection Name
  
  5. Need to check the box *Grant Access Permissions to all pipelines*\

  6. Save
  
  ![New ARM2](screenshots/azure-resource-manager-option.png)

#### Azure Pipeline App

- From your project page left navigation, navigate to PipeLines -> New Pipelines

- In the New Pipeline Interface -> Select GitHub as Repo -> Select the Project 

  ![New Pipeline](screenshots/select-github-as-repo.png)

  ![New Pipeline2](screenshots/select-repo-github.png)

- In Configure, select *Python to Linux Azure Webapp* -> select the deployed app -> Validate and Review
  ![New Pipeline3](screenshots/configure-your-pipeline.png)

  ![New Pipeline4](screenshots/select-an-azure-subscription.png)

  ![New Pipeline5](screenshots/select-web-app-name.png)

- In the Review, validate the Pipeline YAML and hit the *Save and Run* button, you might be prompted to save the code into GitHub
  ![New Pipeline6](screenshots/review-your-pipeline.png)

- We can also Customize the pipeline to our needs as well

- Now that the pipeline is configured, we can Continuously Deliver our ML Flask App, run the pipeline

  ![PipelineBuild](screenshots/build-job.png)

  ![PipelineDeploy](screenshots/deployment-job.png)

  ![PipelineStage](screenshots/pipeline-build-finish.png)

### Clean up resources
To avoid incurring charges on the Azure resources created in this project, delete the resource group that contains the App Service and the App Service Plan.

## Enhancements
- Build effective microservices.
- Build effective alerts that are useful and actionable.

## Demo

[CI/CD Demo Link](https://youtu.be/1MNKBPZUMtU)
