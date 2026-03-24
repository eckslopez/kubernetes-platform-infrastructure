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
  - postgresql
  - postgresql-contrib

write_files:
  - path: /etc/motd
    permissions: "0644"
    content: |
      Shared PostgreSQL host for tenant workloads.
      This VM provides the platform-owned Postgres runtime only.
      Tenant databases, roles, and grants are managed separately by the pg platform-service.
  - path: /etc/postgresql/16/main/conf.d/99-zavestudios-network.conf
    permissions: "0644"
    content: |
      listen_addresses = '${postgres_ip}'
  - path: /etc/postgresql/16/main/pg_hba.conf
    permissions: "0640"
    content: |
      # PostgreSQL Client Authentication Configuration File
      # Managed by cloud-init for the shared PostgreSQL host.

      local   all             postgres                                peer
      local   all             all                                     peer
      host    all             all             127.0.0.1/32            scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
      host    all             all             192.168.122.0/24        scram-sha-256

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

    echo "Enabling PostgreSQL service..."
    systemctl enable postgresql
    systemctl restart postgresql
    systemctl --no-pager --full status postgresql || true

    echo "PostgreSQL VM baseline complete"

final_message: "Shared PostgreSQL VM ${hostname} is ready after $UPTIME seconds"
