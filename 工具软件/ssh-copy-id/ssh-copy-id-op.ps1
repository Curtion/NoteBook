param()
type $env:USERPROFILE\.ssh\id_rsa.pub | ssh $args[0] "cat >> /etc/dropbear/authorized_keys"

# example usage
# ssh-copy-id.ps1 user@host