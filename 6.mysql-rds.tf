# In case if we need to use RDS instaed of MySQL pods then we can use this. this will create MYSQL RDS instance and cobfigue user, password as petclinic
resource "aws_db_instance" "spc-mysql" {
  #  name                        = "petclinic"
  identifier        = "spc-db"
  allocated_storage = 20
  #  multi_az                    = true
  #  availability_zone           = "us-east-1a"
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "8.0.33"
  instance_class              = "db.t2.micro"
  db_name                     = "petclinic"
  username                    = "petclinic"
  password                    = "petclinic"
  parameter_group_name        = "default.mysql8.0"
  db_subnet_group_name        = aws_db_subnet_group.rds-private-subnet.name
  vpc_security_group_ids      = [aws_security_group.eks-sg.id]
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true


  #  backup_retention_period     = 35
  #  backup_window               = "22:00-23:00"
  #  maintenance_window          = "Sat:00:00-Sat:03:00"
  skip_final_snapshot = true

  tags = {
    Name = "spc-mysql"
    ENV  = var.tag_env
  }
}