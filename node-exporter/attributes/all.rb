ne = {"ver" => "1.0.1", "bins" => "node_exporter"}
ne["arch"] = "node_exporter-#{ne['ver']}.linux-amd64"
default['node_exporter'] = ne
default['node_exporter']["src"] = "https://github.com/prometheus/node_exporter/releases/download/v#{ne['ver']}/#{ne['arch']}.tar.gz"
