#!/bin/bash

# Source variables file
if [ -f "variables.sh" ]; then
    source variables.sh
else
    echo "Le fichier variables.sh est manquant. Veuillez le créer avec les variables requises."
    exit 1
fi

# Fonction pour détecter la distribution
detect_distribution() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VERSION=$VERSION_ID
    else
        echo "Impossible de détecter la distribution"
        exit 1
    fi
}

# Installation des dépendances selon la distribution
install_dependencies() {
    case $OS in
        "Debian GNU/Linux"|"Ubuntu")
            apt update
            apt install -y grub2 systemd
            ;;
        "Fedora")
            dnf update -y
            dnf install -y grub2 systemd
            ;;
        *)
            echo "Distribution non supportée"
            exit 1
            ;;
    esac
}

# Configuration du port série
configure_serial() {
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
}

# Exécution principale
echo "Début de la configuration du port série..."

detect_distribution
install_dependencies
configure_serial

echo "Configuration terminée! Le système va maintenant redémarrer."
echo "Vous pourrez vous connecter via le port série $SERIAL_PORT à $BAUD_RATE bauds"
reboot
