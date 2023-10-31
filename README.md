# PoC GCP OIDC for Github bootstrap

This Proof of Concept (PoC) will involve setting up OIDC authentication between Google Cloud Platform (GCP) and Github.

## Prerequisites

Before commencing, ensure that the following components are in place:

* GCP account
* Github account
* Visual Studio Code
* Docker desktop

## Fork the repo (optional)

If you want to have this repo handy, you can create a fork of the repository under your preferred owner.

## Devcontainer

To begin, open the repository within the devcontainer. Launch this repository in Visual Studio Code and switch it to devcontainer mode.

## Authenticate in GCP

Before running the Terraform we need to be authenticated against GCP

```bash
gcloud auth application-default login
```

### Personal credentials (optional)

If you wish to create a new project or a new storage bucket, you'll need to obtain personal credentials. Therefore, execute this command to acquire them.

```bash
gcloud auth login
```

## Select the project

Indicate the project ID (not Project Number) that will be utilized, whether it is an existing one or a new project.

```bash
export GOOGLE_PROJECT=poc-gcp-oidc-github-bootstrap 
```

### Create project (optional)

Execute the following gcloud command in your terminal to initiate the creation of a new project.

```bash
gcloud projects create ${GOOGLE_PROJECT} --name=${GOOGLE_PROJECT}
# Assuming, there is a single billing account available,
# we will utilize it to associate and link it with new project.
gcloud billing projects link ${GOOGLE_PROJECT} \
  --billing-account=$(gcloud billing accounts list --filter='open=true' --format='get(name)' --limit 1)
```

## Choose the storage bucket where you will store the Terraform state file

Define environment variable for Terraform state file

```bash
export TF_STATE_BUCKET=poc-gcp-oidc-github-bootstrap 
```

### Create storage bucket (optional)

If the bucket for the Terraform state file doesn't already exist, please create it.

```bash
gsutil mb -p ${GOOGLE_PROJECT} -c standard -l us-central1 gs://${TF_STATE_BUCKET}
gcloud storage buckets update gs://${TF_STATE_BUCKET} --public-access-prevention
```

## Terraform

Specify Terraform input variables; in this lab, there's only one parameter, which is the owner of the repository.

```bash
export TF_VAR_repository_owner='organisation'
```

Initializing Terraform and apply configuration

```bash
terraform init -backend-config="bucket=${TF_STATE_BUCKET}"
terraform apply
```

## Verify the functionality of the OIDC configuration

Before proceeding to verify the authentication, you must have two essential parameters at your disposal: the project ID and project number.

```bash
gcloud projects list
```

Next, navigate to the Github Actions section and initiate the GCP OIDC authentication validation pipeline.
