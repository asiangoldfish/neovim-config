KEY_PATH="$HOME/.ssh/id_rsa"

if [ ! -f "$KEY_PATH" ]; then
    echo "Generating RSA keypair..."
    ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""
    echo "RSA key generated at $KEY_PATH."
fi
