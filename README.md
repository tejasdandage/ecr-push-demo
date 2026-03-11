# 🐳 ECR Push Demo — Day 4

Pushing Docker images to **AWS Elastic Container Registry (ECR)** — a private, AWS-native container registry.

## DockerHub vs ECR

| Feature | DockerHub | AWS ECR |
|---------|-----------|---------|
| **Type** | Public/Private | Private (AWS-native) |
| **Auth** | `docker login` | `aws ecr get-login-password` → `docker login` |
| **URL** | `docker.io/username/image` | `<account>.dkr.ecr.<region>.amazonaws.com/image` |
| **Best for** | Open source, sharing | AWS workloads, EKS/ECS |
| **IAM integration** | No | Yes — full IAM policy control |

## Commands Used

### 1. Create ECR Repository
```bash
aws ecr create-repository --repository-name myflask --region us-east-1
# → 071308038782.dkr.ecr.us-east-1.amazonaws.com/myflask
```

### 2. Authenticate Docker to ECR
```bash
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin \
    071308038782.dkr.ecr.us-east-1.amazonaws.com
# → Login Succeeded (token valid for 12 hours)
```

### 3. Build, Tag & Push
```bash
# Build the image
docker build -t myflask:v1 .

# Tag for ECR
docker tag myflask:v1 071308038782.dkr.ecr.us-east-1.amazonaws.com/myflask:v1

# Push to ECR
docker push 071308038782.dkr.ecr.us-east-1.amazonaws.com/myflask:v1
```

### 4. Verify in ECR
```bash
aws ecr describe-images --repository-name myflask --region us-east-1
```

### 5. Pull & Run from ECR
```bash
# Delete local image
docker rmi myflask:v1

# Pull from ECR
docker pull 071308038782.dkr.ecr.us-east-1.amazonaws.com/myflask:v1

# Run it
docker run -d -p 5002:5000 071308038782.dkr.ecr.us-east-1.amazonaws.com/myflask:v1
```

## IAM Policies for ECR

| Policy | Access | Use case |
|--------|--------|----------|
| `AmazonEC2ContainerRegistryFullAccess` | Push + Pull | Developers, CI/CD |
| `AmazonEC2ContainerRegistryReadOnly` | Pull only | EKS nodes, production servers |
| `AdministratorAccess` | Everything | Admins (not recommended for least privilege) |

## Key Concepts

- **ECR auth tokens** expire after 12 hours — re-run `get-login-password` when needed
- **EKS pulls from ECR** using the node's IAM role — same mechanism, no manual login needed
- **Registry concept:** A registry stores images. ECR = AWS's private registry, DockerHub = public registry
