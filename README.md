 Employee Records Management

**Employee Records Management** is an enterprise-grade cloud application designed to manage employee profiles securely.  
The application is built using a modern React frontend and a Node.js/Prisma backend, deployed entirely on **Microsoft Azure** using **Terraform** (Infrastructure as Code) and **Azure DevOps** for fully automated CI/CD.

---

## Tech Stack & Azure Services Used

- **Frontend:** React, Vite, TypeScript
- **Backend:** Node.js, Express, Prisma, PostgreSQL
- **Azure App Service (Linux Web App)** – Hosts the Dockerized frontend and backend APIs
- **Azure Database for PostgreSQL (Flexible Server)** – Relational database for employee records
- **Azure Blob Storage** – Secure storage for employee profile photos
- **Azure Key Vault** – Centralized secrets management (DB passwords, JWT secrets)
- **Azure Container Registry (ACR)** – Private registry for Docker images
- **Azure Managed Identities & RBAC** – Passwordless secure authentication between Azure services
- **Azure Application Insights & Log Analytics** – Telemetry, logging, and application monitoring
- **Terraform** – Infrastructure provisioning and state management
- **Azure DevOps** – CI/CD pipelines for infrastructure and application code

---

## Features

- **Employee Directory**: View, add, edit, and manage employee profiles.
- **Profile Photo Management**: Secure image upload and retrieval using time-limited SAS tokens.
- **Enterprise Security**: Zero-trust architecture using Managed Identities (no hardcoded passwords in configuration files).
- **Fully Automated CI/CD**: Two-stage pipelines (Infrastructure & Application) built with Azure DevOps.
- **Containerized Workloads**: Microservices packaged as Docker containers.
- **Infrastructure as Code**: 100% of the Azure infrastructure is defined and version-controlled in Terraform.

---

## Screenshots

<img width="1440" height="900" alt="Screenshot 2026-08-02 at 2 53 35 PM" src="https://github.com/user-attachments/assets/0738173e-b058-4f6d-9ad6-c208ce446c30" />

<img width="1440" height="900" alt="image" src="https://github.com/user-attachments/assets/88c17e8e-3b65-4847-bcc9-709391ceab0b" />


---

##  Architecture & Security Highlights

- **Secretless Backend**: The Node.js backend uses a System-Assigned Managed Identity to read secrets directly from Azure Key Vault at runtime.
- **Secure Storage**: The profile photo Blob Storage is completely locked down from public access (`allow_nested_items_to_be_public = false`). The backend generates time-limited **SAS (Shared Access Signature)** tokens for the frontend to securely render images.
- **CI/CD RBAC Enforcement**: The Azure DevOps Service Principal is granted specific, least-privilege roles (e.g., `User Access Administrator`, `Storage Account Contributor`) to execute Terraform runs safely without needing global subscription Owner rights.

---

##  How It Works (DevOps Workflow)

1. **Infrastructure Pipeline**: A developer merges Terraform code. Azure DevOps runs `terraform init`, `validate`, `plan`, and waits for manual approval. Upon approval, it runs `terraform apply` to provision Azure resources.
   
   <img width="681" height="249" alt="image" src="https://github.com/user-attachments/assets/142e15f3-f720-4560-804e-54821a1f10bc" />

3. **Application Pipeline**: A developer merges application code. The pipeline builds the Node.js/React code, runs `oxlint` and TypeScript checks, builds Docker images, and authenticates to ACR using native `az acr login`.
   
   <img width="1105" height="214" alt="image" src="https://github.com/user-attachments/assets/b0d97a20-b6c6-4fe6-b972-a8d2332d7309" />

5. **Database Migration**: The pipeline fetches the DB password from Key Vault via Azure DevOps native tasks and runs `prisma migrate deploy` securely.
6. **Deployment**: The Docker images are pushed to ACR, and Azure App Service is updated to pull the latest image tags.

   <img width="1440" height="814" alt="image" src="https://github.com/user-attachments/assets/62dcbeb8-5d38-4e2b-90a7-f7ec097f1d52" />

8. **Health Check**: The pipeline continuously polls the `/health` endpoint until the new containers are successfully running.

---

##  Prerequisites

- **Microsoft Azure Account**
- **Azure DevOps Organization**
- **Azure CLI** installed locally
- **Terraform** (`>= 1.5.7`) installed locally
- **Docker** installed locally
- **Node.js** (`20.x`) and `npm`

---

##  Setup Instructions

1. **Bootstrap Terraform State**
   - Navigate to `terraform/bootstrap`
   - Run `terraform init` and `terraform apply` to create the remote state storage account.
   - Run the provided `az role assignment create` commands to grant your Azure DevOps Service Principal the `Storage Account Contributor` and `User Access Administrator` roles.

2. **Configure Azure DevOps**
   - Create an ARM Service Connection (e.g., `AzureConnection`) in Azure DevOps.
   - Link the Service Connection to the Service Principal.
   - Install the **Terraform by Microsoft DevLabs** extension in your Azure DevOps organization.

3. **Deploy Infrastructure**
   - Import `.azure-pipelines/azure-pipelines-infra.yml` into Azure DevOps.
   - Run the pipeline to provision the Resource Group, PostgreSQL, Key Vault, Storage, ACR, App Services, and Application Insights.

4. **Deploy Application**
   - Import `.azure-pipelines/azure-pipelines-app.yml` into Azure DevOps.
   - Run the pipeline to build Docker images, run Prisma migrations, and deploy the code to Azure App Service.
