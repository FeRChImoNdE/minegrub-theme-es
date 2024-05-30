#!/bin/bash

# N. del T.: He incluído varios mecanismos a prueba de fallos.

SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )" # añade || exit por si falla cd 		# SC2164 – ShellCheck Wiki

cd "$SCRIPT_DIR/background_options/" || exit 1

# El autor original odia los vectores de bash y los bucles for con ls :-P
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
declare -a backgrounds

# shellcheck disable=SC2045 # está implementado más abajo
for f in $(ls -v ./*.png) ; do # el uso de `...` tiende al desaparecer por $(...)								# SC2006 – ShellCheck Wiki
	[[ -e "$f" ]] || break # maneja el caso de que no exista ningún *.png										# SC2045 – ShellCheck Wiki
	backgrounds+=("$f")
done
IFS=$SAVEIFS

echo "¡Escoge el fondo de pantalla que te gustaría poner!":

ind=0
for f in "${backgrounds[@]}"; do 
	echo "[$ind]: $f"
	ind=$($ind + 1) # el uso de `...` tiende al desaparecer por $(...) && expr es anticuado						# SC2006 – ShellCheck Wiki && SC2003 – ShellCheck Wiki
done;

echo -n '>> ' 
read -r chosen_ind # read sin -r se carga las barras invertidas													# SC2162 – ShellCheck Wiki


if ! [[ "$chosen_ind" =~ ^[0-9]+$ ]] ; then 
	echo "Sin cambios en el fondo de pantalla"
	exit 1
fi

chosen_backgound=${backgrounds[$chosen_ind]}
echo "Opción elegida $chosen_ind:  $chosen_backgound"

if [[ "$chosen_backgound" == "" ]]; then
	echo Sin cambios en el fondo de pantalla.
else
	cp "$chosen_backgound" "$SCRIPT_DIR/minegrub/background.png"
fi
