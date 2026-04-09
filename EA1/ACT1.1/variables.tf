variable "region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "Rango de red para la VPC principal"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags_comunes" {
  description = "Etiquetas estándar para todos los recursos"
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "Evaluacion-Formativa"
    ManagedBy   = "Terraform"
  }
}

variable "public_subnets" {
  description = "Lista de CIDRs para subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  description = "Zonas de disponibilidad"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mi_vpc.id
  tags   = merge(var.tags_comunes, { Name = "public-route-table" })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}