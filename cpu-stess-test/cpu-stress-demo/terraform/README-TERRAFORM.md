# Terraform for GKE (cpu-stress-demo)

Before running:
- Ensure you have `gcloud` installed and authenticated.
- Your account must have permissions to enable APIs and create GKE clusters.

Quick run:
```
cd terraform
terraform init
terraform apply -var="project_id=YOUR_PROJECT_ID" -var="region=us-central1" -var="zone=us-central1-a"
```
