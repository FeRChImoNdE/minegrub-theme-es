**El trío de temas de Minecraft para Grub:**

| *> Menú Principal de Minecraft (Traducido) <* | [Minecraft World Selection Menu](https://github.com/Lxtharia/minegrub-world-sel-theme) | [Using both themes together](https://github.com/Lxtharia/double-minegrub-menu) |
| --- | --- | --- |

Enlace al Tema orginal: [Minegrub Theme](https://github.com/Lxtharia/minegrub-theme)

**Acerca de la traducción**: *Por el momento sólo está completada la primera de las opciones (Menú principal). Iré completando el resto a mi ritmo :-) Gracias por vuestra comprensión.*

# Minegrub
¡Un tema para Grub al estilo de Minecraft!


![Minegrub Preview "Screenshot"](resources/preview_minegrub.png)

# Instalación
> ### Nota: grub vs grub2 <a name="grub"></a>
> - Independientemente de cuál sea tu distribución, lo más probable es que venga con una **versión > 2 de grub.**
> - Algunas distribuciones han mantenido el nombre original de la herramienta de configuración por razones de compatibilidad, mientras que otras añadieron un "2" como muestra del avance entre versiones.
> - Como norma general, las derivadas de **Debian** y **Ubuntu**, así como también **Arch** trabajan con el ejecutable **`grub-mkconfig`** (y por tanto la configuración irá a `/boot/grub/`), mientras que las derivadas de **Red Hat** y **Fedora** lo hacen con **`grub2-mkconfig`** (y por ende la configuración irá en `/boot/grub2/`). No obstante, ante la duda y las cientos de posibilidades existentes, lo mejor será que intentes ejecutar los comandos (para ver cuál es el que funciona en tu caso) y comprobar la ruta con la que trabaja tu equipo.
> - Todo esto quiere decir que si tienes la carpeta `/boot/grub2` en lugar de `/boot/grub` tendrás que hacer unos pequeños ajustes a las rutas mencionadas en ésta guía, así como modificar una línea del archivo `minegrub-update.service` (si quieres hacer uso de ésta herramienta, hablaremos sobre esto más adelante).

### Manualmente

- Clona éste repositorio y entra en la carpeta que se creará:
```
git clone https://github.com/FeRChImoNdE/minegrub-theme-es.git && cd minegrub-theme-es
```
- (Opcional) Elige un fondo de pantalla con: (O copia la imagen que prefieras como `minegrub/background.png`)
```
./choose-background.sh
```
  - Si vas a hacer uso del script de actualización, puedes poner el número de imágenes que quieras en la carpeta `minegrub/backgrounds/`. Encontrarás algunos ejemplos en `background_options/` pero puedes usar cualquier otra imagen que te apetezca.
  - Si no vas a hacer uso del script, o si prefieres que se muestre siempre el mismo fondo, puedes usar `./choose-background.sh` para escoger una de las que vienen predefinidas o directamente hacer una copia de una de ellas como `minegrub/background.png`

- Copia la carpeta a la partición de arranque: (info: `-ruv` = recursive, update, verbose)
```
cd ./minegrub-theme-es
sudo cp -ruv ./minegrub /boot/grub/themes/
```
- Cambia o añade esta línea en `/etc/default/grub`: [*(¡Elige la que utilice tu distro!)*](#grub)
```
GRUB_THEME=/boot/grub/themes/minegrub/theme.txt     # Debian, Ubuntu, Arch Linux... y sus derivados (normalmente)

GRUB_THEME=/boot/grub2/themes/minegrub/theme.txt    # Red Hat, Fedora... y sus derivados (normalmente)
```
- **NOTA**: Antes de guardar y pasar al siguiente paso [mira esto](#style).

- Actualiza la configuración mediante: [*(¡Elige la que utilice tu distro!)*](#grub)
```
sudo grub-mkconfig -o /boot/grub/grub.cfg           # Debian, Ubuntu, Arch Linux... y sus derivados (normalmente)

sudo grub2-mkconfig -o /boot/grub2/grub.cfg         # Red Hat, Fedora... y sus derivados (normalmente)
```
- **¡Estamos listos!**

### Módulo para NixOS (flake)

<details><summary>Aquí tienes un ejemplo muy escueto</summary>

```nix
# flake.nix
{
  inputs.minegrub-theme.url = "github:Lxtharia/minegrub-theme";
  # ...

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        inputs.minegrub.nixosModules.default
      ];
    };
  }
}

# configuration.nix
{ pkgs, ... }: {

  boot.loader.grub = {
    minegrub-theme = {
      enable = true;
      splash = "100% Flakes!";
      boot-options-count = 4;
    };
    # ...
  };
}
```
</details>

# Configuración

## Ajuste según el número de opciones de arranque
- El menú por defecto está diseñado para 4 botones (opciones de arranque, configuraciones, etc...)
- En caso de tener un número mayor o menor, es necesario realizar un pequeño ajuste a la barra inferior, en la que aparecen los botones `"E para Opciones"` y `"C para Consola"`
- Dentro del archivo `theme.txt` encontrarás una fórmula explicando a fondo cómo funciona, pero para no complicarte demasiado también se ha incluído una tabla con valores precalculados **entre 2 y 8 opciones**, más que suficiente para cubrir la mayoría de casos, por lo que podrás ajustarlo fácilmente aplicando el valor correcto.

## Mensajes de bienvenida aleatorios "*à la*" Minecraft y número <u>real</u> de paquetes instalados
El script `update_theme.py` escoge una línea aleatoria del archivo `assets/splashes.txt`, generando y reemplazando el `logo.png` con una nueva frase de bienvenida (¡al más puro estilo de Minecraft!), y además es capaz de actualizar la cantidad real de paquetes instalados en tu sistema. Por si esto fuera poco también escoge aleatoriamente un archivo de la carpeta `backgrounds/` y lo establece como fondo de pantalla. Aquí la particularidad es que ignora todos los archivos ocultos (en UNIX, todo lo que empieza por `"."` un punto). Para ello necesitaremos lo siguiente:

- Tener `neofetch` instalado.
- Tener `python3` (o equivalente) con el paquete Pillow instalado.
  - Se puede instalar de varias formas, como el paquete `python-pillow` de AUR para Arch, o mediante pip3, p.ej.:
    `sudo -H pip3 install pillow`
  - Es importante el uso de `sudo -H`, ya que tiene que estar disponible para el usuario root.
- Para añadir nuevos mensajes, simplemente edita `./minegrub/assets/splashes.txt` y añade (o quita) líneas a tu gusto.
- Puedes poner todos los fondos que quieras en la carpeta `./minegrub/backgrounds/`. Los *Archivos Ocultos* se ignoran. También puedes añadir tus propias imágenes.
- Si quieres un mensaje y/o fondo específico para el siguiente arranque, el escript admite dos parámetros: 
`python update_theme.py ['ARCHIVO_DE_FONDO' ['MENSAJE']]`, p.ej.: `python update_theme.py 'backgrounds/1.15 - [Buzzy Bees].png' '¡Saludos!'`
  - Los parámetros "en blanco" (dos comillas simples) se reemplazan por uno aleatorio de entre los disponibles, p.ej.:
  `python update_theme.py '' '¡Bienvenidos!'` escogerá un fondo aleatorio y la frase de saludo será `¡Bienvenidos!`

### Actualizando los mensajes de bienvenida y los paquetes instalados...
#### ...manualmente
- Simplemente ejecuta `python /boot/grub/themes/minegrub/update_theme.py` (desde cualquier lugar) tras comprobar que ha funcionado (y tras haber reiniciado) con cualquiera de los métodos antes mencionados.

#### ...con init-d (SysVinit)
- Copia `./minegrub-SysVinit.sh` a la carpeta `/etc/init.d` como `minecraft-grub`. Una vez hecho ejecuta  `update-rc.d minecraft-grub defaults` con privilegios de root:
```bash
sudo cp -v "./minegrub-SysVinit.sh" "/etc/init.d/minecraft-grub"
sudo chmod u+x "/etc/init.d/minecraft-grub" # Aseguramos los permisos por precaución
sudo update-rc.d minecraft-grub defaults
```

#### ...con systemd
- Si tu sistema usa `grub2` [(Ver la sección de grub más arriba)](#grub) es el momento de editar la **línea número 6** de `./minegrub-update.service` para que use la carpeta correcta `/boot/grub2/`. Debería de quedar así:
  - `ExecStart=/usr/bin/python3 /boot/grub2/themes/minegrub/update_theme.py`
- Copia `./minegrub-update.service` a `/etc/systemd/system` (hará falta *sudo*)
- Activa e inicia el servicio: `sudo systemctl enable --now minegrub-update.service`
- Es posible que durante el primer reincio no veamos ningún cambio (aunque con el parámetro --now debería haberlo disparado). Si a partir de un segundo reinicio y posteriores seguimos sin ver cambios, comprobaremos si hay errores mediante `systemctl status minegrub-update.service` (p.ej.: si pillow no se ha instalado en el ámbito correcto).

# Notas:
- <a name=style></a>El parámetro `GRUB_TIMEOUT_STYLE` del archivo `/etc/default/grub` debería indicar `menu` para que lo muestre inmediatamente (si no tendremos que pulsar ESC y no queremos eso)
- No soy ningún experto en Linux, de ahí que las explicacines sean tan exhaustivas, para facilitárselo a otros novatos :>
- Por cierto, uso Arch. 
  - *Nota del Traductor:* **¡Y yo también! xD**
- Espero que os guste, porque a mí sí (*juas*)

### Gracias a
- https://github.com/toboot por darme esta maravillosa idea!
- A internet por darme sabiduría (juas!) (Principalmente http://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial)
- A los que contribuyen por aportar y darme motivación para mejorar cosillas aquí y allá
- [Vanilla Tweaks](https://vanillatweaks.net) por algunos de los fondos


Fuente descargada de https://www.fontspace.com/minecraft-font-f28180 para un uso no comercial.
