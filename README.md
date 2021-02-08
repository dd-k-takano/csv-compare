## 1. Install
```sh
yum update -y
yum install -y git docker
service docker start
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
git clone https://github.com/dd-k-takano/csv-compare.git
mkdir -p csv-data/data && cd $_
```

### 1.1 download csv
```
aws s3 cp s3://...
aws s3 cp s3://...
find ./ -type f -name "*.gz" -exec gunzip {} \;
```

## 2. Start MySQL
```sh
cd ~/csv-compare
docker-compose up -d db
```

## 3. Import Csv
```sh
docker-compose run app bash -c 'ruby main.rb'
```
