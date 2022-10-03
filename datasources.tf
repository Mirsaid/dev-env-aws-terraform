data "aws_ami" "server_ami" {
	most_recent = true
	owners = ["09962723774"]
	
	filter {
	name = "name"
	values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-* "]
		
}

} 
