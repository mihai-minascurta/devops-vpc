# 1. The Main Fence (The VPC)
# 10.0.0.0/16 gives us 65,536 potential IP addresses to use.
resource "aws_vpc" "andrei_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Andrei-VPC"
  }
}

# 2. The Web Zone (Public Subnet)
# We carve out a smaller chunk (256 IPs) for our web servers.
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.andrei_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a" # e.g., eu-central-1a
  map_public_ip_on_launch = true # Automatically give servers a public IP

  tags = {
    Name = "Andrei-Public-Subnet"
  }
}

# 3. The Database Zone (Private Subnet)
# Another 256 IPs, completely isolated. Notice map_public_ip_on_launch is missing!
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.andrei_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b" # e.g., eu-central-1b (Different data center for backup)

  tags = {
    Name = "Andrei-Private-Subnet"
  }
}
