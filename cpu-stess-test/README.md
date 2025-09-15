# cpu-stress-demo

Ready-to-run demo repository that creates:
- a simple Flask app that can generate/remove CPU load
- Dockerfile to containerize the app
- Helm chart to deploy to Kubernetes (GKE)
- Terraform configs to provision a GKE standard cluster + node pool

## Structure
- app.py
- Dockerfile
- terraform/
- charts/cpu-stress/  (Helm chart)

## Quickstart (high-level)
1. Build and push container image:
   ```bash
   docker build -t gcr.io/PROJECT_ID/cpu-stress:v1 .
   docker push gcr.io/PROJECT_ID/cpu-stress:v1
   ```

2. Provision cluster (Terraform):
   ```bash
   cd terraform
   terraform init
   terraform apply -var="project_id=PROJECT_ID" -var="region=us-central1" -var="zone=us-central1-a"
   ```

3. Get credentials:
   ```bash
   gcloud container clusters get-credentials cpu-stress-cluster --region us-central1 --project PROJECT_ID
   ```

4. Install Helm chart (update values.yaml image.repository/tag):
   ```bash
   helm install cpu-stress charts/cpu-stress -f charts/cpu-stress/values.yaml
   ```

5. Simulate load:
   ```bash
   EXTERNAL_IP=<service-ip>
   curl -X POST -H "Content-Type: application/json" -d '{"action":"start","workers":2}' http://$EXTERNAL_IP/load
   curl -X POST -H "Content-Type: application/json" -d '{"action":"stop"}' http://$EXTERNAL_IP/load
   ```

See `terraform/README-TERRAFORM.md` and `charts/cpu-stress/README-HELM.md` for more details.
