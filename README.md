```
yum update -y
yum install -y git docker
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
git clone https://github.com/dd-k-takano/csv-compare.git
mkdir -p csv-data/data && cd $_
```
