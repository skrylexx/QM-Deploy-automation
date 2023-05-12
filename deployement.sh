#!/bin/bash


echo "                                                           "
echo "  _____             _                                  _   "
echo " |  __ \           | |                                | |  "
echo " | |  | | ___ _ __ | | ___  _   _ _ __ ___   ___ _ __ | |_ "
echo " | |  | |/ _ \  _ \| |/ _ \| | | |  _   _ \ / _ \  _ \| __|"
echo " | |__| |  __/ |_) | | (_) | |_| | | | | | |  __/ | | | |_ "
echo " |_____/ \___| .__/|_|\___/ \__, |_| |_| |_|\___|_| |_|\__|"
echo "             | |             __/ |                         "
echo "             |_|            |___/                          "
echo " Script de déploiement automatique de VMs                  "
echo " Proxmox                                                   "
echo "                                                           "


###########################
#Paramètrage des variables#
###########################

#idclone -> ID de la machine à cloner
#nb -> nombre de clones
#iddebut -> ID de début du clonage
#ask -> demande de description
#desc -> description de VM souhaitée
#k -> interface réseau de la VM
#on -> démarrer VMs après clonage ou non


#################
#Début du script#
#################

echo -n "Entrez l'ID de la machine que vous souhaitez cloner : "
read idclone


echo -n "Combien de fois voulez-vous la cloner ? "
read nb


echo -n "A quel ID de machine voulez-vous commencer ? "
read iddebut


echo -n "Ajoutez une descriptions aux machines virtuelles. Si non, appuyez sur entrer :  "
read ask


#Boucle de vérification pour le choix de l'utilisateur

if [ -z "$ask" ]
	then
		echo "Aucune description souhaitée."
	else
		echo -n "Veuillez entrer la description : "
		read desc
fi


echo -n "Sélectionnez l'interface sur laquelle vous souhaitez connecter la machine (0 = WAN, 1 = LAN, 2 = DMZ) : "
read k


echo -n "Voulez-vous démarrer les machines virtuelles après le clonage ? o/n"
read on

for (( i=1; i<=nb; i++ ))
do
	qm clone $idclone $iddebut
	qm config $iddebut -description $desc
	qm set $iddebut --net0 bridge=vmbr$k
	if  [$on="o" || !$on]
		then
			qm start $iddebut
	fi
	((iddebut++))
done
