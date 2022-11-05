job "fabio" {
  datacenters = ["dc1"]
  type = "system"

  group "fabio" {
    network {
      port "http" {
        static = 80
      }
      port "ui" {
        static = 9998
      }
    }
    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio"
        network_mode = "host"
        ports = ["http","ui"]
        volumes = [
          "custom/fabio.properties:/etc/fabio/fabio.properties"
        ]
      }

      template {
        data = <<EOH
          # ref: https://github.com/fabiolb/fabio/blob/master/fabio.properties
          proxy.addr = :80
          ui.access = ro
          log.access.target = stdout
          log.level = INFO
          proxy.maxconn = 10000
          ui.color = "pink lighten-3"
          ui.title = "JamLab L7 Load Balancer"
        EOH

        destination = "custom/fabio.properties"
      }

      resources {
        cpu    = 500
        memory = 2048
      }
    }
  }
}
