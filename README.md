# Terraform AWS Infrastructure and Helm (lesson-7)

## 📁 Структура
```
lesson-7/
│
├── main.tf                         # Головний файл для підключення модулів
├── backend.tf                      # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf                      # Загальне виведення ресурсів
│
├── modules/                        # Каталог з усіма модулями
│   │
│   ├── s3-backend/                 # Модуль для S3 та DynamoDB
│   │   ├── s3.tf                   # Створення S3-бакета
│   │   ├── dynamodb.tf             # Створення DynamoDB
│   │   ├── variables.tf            # Змінні для S3
│   │   └── outputs.tf              # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                        # Модуль для VPC
│   │   ├── vpc.tf                  # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf               # Налаштування маршрутизації
│   │   ├── variables.tf            # Змінні для VPC
│   │   └── outputs.tf              # Виведення інформації про VPC
│   │
│   ├── ecr/                        # Модуль для ECR
│   │   ├── ecr.tf                  # Створення ECR репозиторію
│   │   ├── variables.tf            # Змінні для ECR
│   │   └── outputs.tf              # Виведення URL репозиторію ECR
│   │
│   └── eks/                        # Модуль для EKS
│       ├── eks.tf                  # Створення EKS кластеру
│       ├── node.tf                 # Створення Node Group
│       ├── variables.tf            # Змінні для EKS
│       └── outputs.tf              # Виведення інформації про EKS
│
├── charts/                         # Каталог з усіма Helm чартами
│   └── django-app/                 # Чарти для Django
│       ├── templates/              # Шаблони для Django
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml            # ConfigMap зі змінними 
│
└── README.md                       # Документація проєкту

```

## 🔧 Опис модулів

### `s3-backend`
- Створює S3-бакет для зберігання стейтів
- Увімкнене версіювання
- DynamoDB для блокування стейтів

### `vpc`
- Створює VPC, Internet Gateway, NAT Gateway
- 3 публічні та 3 приватні підмережі

### `ecr`
- Створює ECR репозиторій
- Увімкнене сканування образів при пуші

### `eks`
- Створює EKS кластер


## Опис Helm чарт

### `django-app`
- Створює Deployment, Service, ConfigMap та HorizontalPodAutoscaler для Django застосунку

## 🚀 Команди запуску

**Запуск інфраструктури**

```bash
terraform init
terraform plan
terraform apply
```

**Видалення інфраструктури**
```bash
terraform destroy
```

**Вхід в AWS ECR (отримання токену логіну)**
```bash
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 731464279148.dkr.ecr.eu-north-1.amazonaws.com
```

**Білдимо Docker image**

```bash
docker build -t django-app-ecr ./django-app
```

де `./django-app` - шлях до директорії з Dockerfile застосунку Django

**Додаємо тег імеджу для пушу в ECR**
```bash
docker tag django-app-ecr 731464279148.dkr.ecr.eu-north-1.amazonaws.com/django-app-ecr
```

**Пушимо в ECR**
```bash
docker push 731464279148.dkr.ecr.eu-north-1.amazonaws.com/django-app-ecr
```

**Додавання EKS кластеру в kubeconfig**
```bash
aws eks update-kubeconfig \
  --region eu-north-1 \
  --name eks-cluster-demo
```

**Встановлення Helm**
```bash
helm upgrade --install django ./django-app
```

**Виведення списку сервісів**
kubectl get scv -A

**Витягуємо пароль ArgoCD**
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d