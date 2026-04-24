resource "aws_s3_bucket" "tfstate" {
  bucket = "harsh11-threetierarch-tfstate"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr                 = "10.0.0.0/16"
  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  private_db_subnet_cidrs  = ["10.0.20.0/24", "10.0.21.0/24"]
  availability_zones       = ["ap-south-1a", "ap-south-1b"]
  env                      = "dev"
}

module "security" {
  source = "./modules/security"

  vpc_id = module.vpc.vpc_id
  env    = "dev"
}

module "alb" {
  source = "./modules/alb"

  vpc_id        = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnet
  env           = "dev"
  alb_sg        = module.security.alb-sg
}

module "compute" {
  source = "./modules/compute"

  instance_type      = "t3.micro"
  vpc_id             = module.vpc.vpc_id
  env                = "dev"
  private_app_subnet = module.vpc.private_app_subnet
  app_sg             = module.security.app-sg
  target_group       = module.alb.target_group_arn
}

module "rds" {
  source = "./modules/rds"


  env               = "dev"
  db_sg             = module.security.db-sg
  private_db_subnet = module.vpc.private_db_subnet
  db_name           = var.db_name
  db_password       = var.db_password
  db_user           = var.db_username
}