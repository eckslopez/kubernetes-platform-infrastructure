#cloud-config
datasource_list: [ NoCloud, None ]
datasource:
  NoCloud:
    fs_label: cidata

hostname: ${hostname}
fqdn: ${hostname}.local

users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_public_key}

ssh_pwauth: true
chpasswd:
  expire: false
  list:
    - ubuntu:ubuntu

timezone: UTC

package_update: true
package_upgrade: true

packages:
  - curl
  - vim
  - htop
  - net-tools
  - jq
  - redis-server

write_files:
  - path: /etc/motd
    permissions: "0644"
    content: |
      Shared Redis host for tenant workloads.
      This VM provides the platform-owned Redis runtime only.
      Tenant-facing broker/cache URLs are managed separately by platform config and Vault.

runcmd:
  - |
    echo "Waiting for network..."
    for i in {1..30}; do
      if ip route | grep -q "default"; then
        echo "Network ready"
        break
      fi
      sleep 2
    done

    echo "Configuring Redis for internal subnet access..."
    sed -i "s/^bind .*/bind 127.0.0.1 ${redis_ip}/" /etc/redis/redis.conf
    sed -i "s/^protected-mode .*/protected-mode yes/" /etc/redis/redis.conf
    sed -i "s/^appendonly .*/appendonly yes/" /etc/redis/redis.conf

    echo "Enabling Redis service..."
    systemctl enable redis-server
    systemctl restart redis-server
    systemctl --no-pager --full status redis-server || true

    echo "Shared Redis VM baseline complete"

final_message: "Shared Redis VM ${hostname} is ready after $UPTIME seconds"
