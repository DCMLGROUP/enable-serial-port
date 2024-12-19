# Configuration du Port Série pour Proxmox

Ce script permet de configurer le port série sur un serveur Proxmox pour:

- Activer la console série sur le système hôte Proxmox
- Permettre la connexion aux VMs via le port série
- Gérer les VMs à distance via une connexion série

## Fonctionnalités

- Configure GRUB pour utiliser le port série (ttyS0)
- Active le service getty sur le port série
- Configure le débit à 115200 bauds
- Permet la connexion série via SSH

## Prérequis

- Accès root sur le serveur Proxmox
- Un port série physique ou virtuel disponible

## Installation

1. Cloner ce dépôt
2. Rendre le script exécutable: `chmod +x main.sh`
3. Exécuter le script en tant que root: `sudo ./main.sh`

## Utilisation

Pour se connecter à une VM via le port série depuis Proxmox: