
Vagrant.configure(2) do |config|
  # Imagen de centos 7
  config.vm.box = "centos/7"

  # Habilitar check de updates
  config.vm.box_check_update = false

  # Crear una red privada, lo que preminitrá unicamente a la maquina host acceder a la red
  # Configurar IP.
  config.vm.network "private_network", ip: "192.168.33.55"

  # Copiar script de instalación
  config.vm.provision "file", source: "./install.sh", destination: "install.sh"

  # Dar permisos de ejecuion al script 
  config.vm.provision "shell", inline: "chmod +x install.sh"

  # Especificar el hypervisor y configurar memoria
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
end
