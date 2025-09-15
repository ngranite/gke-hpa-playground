# Helm chart: cpu-stress

Update `values.yaml` image.repository to point to your pushed image (e.g. gcr.io/PROJECT_ID/cpu-stress) and tag.

Install:
```
helm install cpu-stress charts/cpu-stress -f charts/cpu-stress/values.yaml
```

Check HPA and pods:
```
kubectl get hpa
kubectl get pods -l app=cpu-stress
kubectl get svc
```
