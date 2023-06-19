provider "hcloud" {
  token = "<your-hetzner-api-token>"
}

resource "hcloud_server" "woocommerce" {
  name = "woocommerce"
  server_type = "cx11"
  image = "ubuntu-18.04"
  location = "fsn1"
  
  ssh_keys = [ 
    "<your-ssh-key-name>" 
  ]

  connection {
    type = "ssh"
    user = "root"
    private_key = file("<path-to-your-private-key>")
  }

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -",
      "add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable\"",
      "apt-get update",
      "apt-get install -y docker-ce",
      "curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      "mkdir /root/woocommerce",
      "echo \"version: '3'\nservices:\n  db:\n    image: mysql:5.7\n    volumes:\n      - db_data:/var/lib/mysql\n    restart: always\n    environment:\n      MYSQL_ROOT_PASSWORD: somewordpress\n      MYSQL_DATABASE: wordpress\n      MYSQL_USER: wordpress\n      MYSQL_PASSWORD: wordpress\n\n  wordpress:\n    depends_on:\n      - db\n    image: wordpress:latest\n    ports:\n      - 8080:80\n    restart: always\n    environment:\n      WORDPRESS_DB_HOST: db:3306\n      WORDPRESS_DB_USER: wordpress\n      WORDPRESS_DB_PASSWORD: wordpress\n      WORDPRESS_DB_NAME: wordpress\n    volumes:\n      - wordpress_data:/var/www/html\n\nvolumes:\n    db_data: {}\n    wordpress_data: {}\" > /root/woocommerce/docker-compose.yml",
      "cd /root/woocommerce",
      "docker-compose up -d",
    ]
  }
}

resource "hcloud_firewall" "woocommerce_firewall" {
  name = "woocommerce_firewall"

  rule {
    direction = "in"
    protocol = "icmp"
  }

  rule {
    direction = "in"
    protocol = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0", "::/0",  # ssh should be restricted to your IP
    ]
  }

  rule {
    direction = "in"
    protocol = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0", "::/0",  # http
    ]
  }

  rule {
    direction = "in"
    protocol = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0", "::/0",  # https
    ]
  }
}

resource "hcloud_server_network" "woocommerce_network" {
  server_id  = hcloud_server.woocommerce.id
  subnet_id  = hcloud_network_subnet.woocommerce_subnet.id
}

resource "hcloud_server_firewall" "woocommerce_server_firewall" {
  server_id    = hcloud_server.woocommerce.id
  firewall_id  = hcloud_firewall.woocommerce_firewall.id
}