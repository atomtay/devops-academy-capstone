resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = aws_subnet.main.*.id
}

resource "random_password" "postgres_admin_password" {
  length  = 32
  special = false
}

resource "random_password" "postgres_app_password" {
  length  = 32
  special = false
}

resource "aws_db_instance" "postgres" {
  #checkov:skip=CKV_AWS_17:Create public IP because we don't have access to private GH Actions runners

  name                      = "todo"
  apply_immediately         = true
  instance_class            = "db.t3.micro"
  storage_type              = "gp2"
  allocated_storage         = 10
  engine                    = "postgres"
  password                  = random_password.postgres_admin_password.result
  username                  = "main"
  multi_az                  = true
  db_subnet_group_name      = aws_db_subnet_group.main.name
  publicly_accessible       = false
  storage_encrypted         = true
  port                      = 5432
  skip_final_snapshot       = true
  final_snapshot_identifier = "its-the-final-snapshot"

  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      latest_restorable_time,
    ]
  }
}