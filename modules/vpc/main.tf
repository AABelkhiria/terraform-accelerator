resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = merge(var.tags, { Name = "${var.name}-vpc" })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index].cidr
  availability_zone       = var.public_subnets[count.index].az
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "${var.name}-public-${count.index + 1}" })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index].cidr
  availability_zone = var.private_subnets[count.index].az
  tags              = merge(var.tags, { Name = "${var.name}-private-${count.index + 1}" })
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? length(var.public_subnets) : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? length(var.public_subnets) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags          = merge(var.tags, { Name = "${var.name}-nat-${count.index + 1}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index % length(aws_nat_gateway.main)].id
  }
  tags = merge(var.tags, { Name = "${var.name}-private-rt-${count.index + 1}" })
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_vpc_flow_log" "main" {
  count           = var.enable_flow_logs ? 1 : 0
  vpc_id          = aws_vpc.main.id
  traffic_type    = "ALL"
  log_destination = var.flow_log_destination_arn
  iam_role_arn    = var.flow_log_iam_role_arn
}
