# Use official Terraform image
FROM hashicorp/terraform:1.5.7

# Set the working directory
WORKDIR /app

# Copy all Terraform files into the image
COPY . .

# Optional: Run Terraform init and apply automatically
CMD sh -c "terraform init && terraform apply -auto-approve"
