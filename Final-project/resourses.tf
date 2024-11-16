  
module "ec2-web" {
  source        = "./modules/ec2-web"
  
}
module "ec2-backend" {
  source        = "./modules/ec2-backend"
  
}
module "lb-web" {
  source        = "./modules/lb-web"
  
}
module "lb-backend" {
  source        = "./modules/lb-backend"
  
}
module "network" {
  source        = "./modules/network"
  
}
