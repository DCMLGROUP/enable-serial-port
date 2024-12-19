#!/bin/bash

# Variables
SERIAL_PORT="ttyS0"
BAUD_RATE="115200"

# Vérifier si le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root."
  exit 1
fi

# Configuration de GRUB
echo "Configuration de GRUB pour utiliser le port série..."
sed -i "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"console=tty0 console=$SERIAL_PORT,$BAUD_RATE\"/" /etc/default/grub
sed -i "s/#GRUB_TERMINAL=.*/GRUB_TERMINAL=serial/" /etc/default/grub
sed -i "s/#GRUB_SERIAL_COMMAND=.*/GRUB_SERIAL_COMMAND=\"serial --speed=$BAUD_RATE --unit=0 --word=8 --parity=no --stop=1\"/" /etc/default/grub

# Mise à jour de GRUB
update-grub

# Configuration du noyau pour utiliser le port série avec systemd
echo "Configuration du noyau pour utiliser le port série..."
systemctl enable serial-getty@$SERIAL_PORT.service
systemctl start serial-getty@$SERIAL_PORT.service

# Redémarrage du système
echo "Configuration terminée. Le système va maintenant redémarrer."
reboot
