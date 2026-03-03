#!/bin/bash
# --- CONFIGURATION ---
REGISTRY="otniel217"
PROJECT="ecom"
TAG="latest"
SERVICES=(
  "api-gateway"
  "service-registry"
  "order-service"
  "inventory-service"
  "payment-service"
  "notification-service"
  "shipping-service"
)
# Couleurs pour la visibilité
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color
echo -e "${BLUE}🚀 Starting build and push process for project: $PROJECT${NC}\n"
# Vérification de la connexion Docker
docker info > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Docker n'est pas lancé ou vous n'êtes pas connecté.${NC}"
    exit 1
fi
# Boucle sur chaque service
for SERVICE in "${SERVICES[@]}"
do
    echo -e "${BLUE}--------------------------------------------${NC}"
    echo -e "${BLUE}📦 Processing: $SERVICE${NC}"
    echo -e "${BLUE}--------------------------------------------${NC}"
    # Nom de l'image (Format: otniel217/ecom-service-name:latest)
    IMAGE_NAME="$REGISTRY/$PROJECT-$SERVICE:$TAG"
    
    echo -e "🔨 Building Docker image: ${BLUE}$IMAGE_NAME${NC}..."
    
    # Build de l'image depuis la racine du projet pour que le pom.xml parent soit accessible
    docker build -f "./$SERVICE/Dockerfile" -t "$IMAGE_NAME" .
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Build successful for $SERVICE${NC}"
        
        # Push vers Docker Hub
        echo -e "⬆️  Pushing image to Docker Hub..."
        docker push "$IMAGE_NAME"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}🚀 Push successful: $IMAGE_NAME${NC}"
        else
            echo -e "${RED}❌ Error during push for $SERVICE${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Error during build for $SERVICE${NC}"
        exit 1
    fi
done
echo -e "\n${GREEN}✨ All services have been built and pushed to otniel217/$PROJECT-* successfully!${NC}"