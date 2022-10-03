resource "aws_subnet" "dev_subnet" {
	vpc_id = aws_vpc.dev_vpc.id
	cidr_block = "10.1.1.0/24"
	map_public_ip_on_launch = true
	availability_zone = "us-west-2a"
	
	tags = {
			Name = "dev-public-subnet"
		}	
}

resource "aws_internet_gateway" "dev_internet_gateway" {
	vpc_id = aws_vpc_dev_vpc.id
	tags = {
		Name = "dev_igw"
		}
}

resource "aws_route_table" "dev_public_rt" {
	vpc_id = aws_vpc.dev_vpc.id
	tags = {
		Name = "dev-rt"
	}
} 

resource "aws_route" "default_route" {

	route_table_id = aws_route_table.dev_public_rt.id
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.dev_internet_gateway.id
}

resource "aws_route_table_association" "dev_public_assoc" {
	subnet_id = aws_subnet.dev_subnet.id
	route_table_id = aws_route_table.dev_public_rt.id
}

resource "aws_security_group" "dev_sg" {
	name = "dev-sg"
	description = "dev-sec-group"
	vpc_id = aws_vpc.dev_vpc.id
	
	
ingress {
	
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		  }
	
egress {
	
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		  }
}

resource "aws_key_pair" "dev_auth" {
	key_name = "devkey"
	public_key = file("~/.ssh/devkey.pub")	

}

resource "aws_instance" "dev_node" {
	ami = data.aws_ami.server_ami.id
	instance_type = "t2.micro"
	user_data = file("userdata.tpl")
	
	tags = {
		Name = "dev-node"
		}
	key_name = aws_key_pair.dev.auth.id
	vpc_security_group_ids = aws_security_group.dev_sg.id
	subnet_id = aws_subnet.dev_public_subnet.id
	
	root_block_device {
		volume_size = 10
		}
}
