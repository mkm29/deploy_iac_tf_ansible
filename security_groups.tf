resource "aws_security_group" "lb-sg" {
  provider    = aws.region-master
  name        = "lb-sg"
  description = "Allow traffic from port 80 and 443"
  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_rules
    content {
      from_port  = port.value
      to_port    = port.value
      protocol   = "TCP"
      cidr_block = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins-sg" {
  provider    = aws.region-master
  name        = "jenkins-sg"
  description = "Allow TCP/8080 and TCP/22"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow port 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description     = "Allow anyone on port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "TCP"
    security_groups = [aws_security_group.lb-sg.id]
  }
  ingress {
    description = "Allow traffic from us-west-1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create SG for allowing TCP/22 from your IP in us-west-1
resource "aws_security_group" "jenkins-dg-ohio" {
  name        = "jenkins-sg-ohio"
  description = "Allow TCP/8080 and TCP/22"
  vpc_id      = aws_vpc.vpc_worker_ohio.id
  ingress {
    description = "Allow port 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description     = "Allow anyone on port 8080"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["10.0.1.0/24"]
  }
  ingress {
    description = "Allow traffic from us-west-1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

