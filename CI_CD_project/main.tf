resource "aws_key_pair" "Cicd" {
    key_name = "cicd_key"
    public_key = file("/cicd")
}
resource "aws_instance" "mini" {
  ami = "ami-0e1bed4f06a3b463d"
  instance_type = "t2.micro"
  key_name = aws_key_pair.Cicd.key_name
  vpc_security_group_ids = ["sg-0cf4b32deebc7e0a8"]
  tags = {
    Name: "Minikube"
    project: "Ci/Cd"
  }
  user_data = file("/user_data.sh")
  
}
