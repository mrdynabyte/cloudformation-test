if ! type "python" > /dev/null; then
    sudo apt-get update && sudo apt install python3
fi

if ! type "pip" > /dev/null; then
    sudo apt-get update && sudo apt install python3-pip
fi

pip3 install boto3 awscli

aws configure

chmod +x ./elasticsearch-cli

echo "ElasticSearch CLI installed successfully!"