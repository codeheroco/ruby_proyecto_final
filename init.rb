#### CodeHero.co ####
#
# Desarrollado por: Ricardo Sampayo 
# Empecemos de una vez
#
#### CodeHero.co ####


## Declaramos la ruta del proyecto 
APP_ROOT = File.dirname(__FILE__)

# agregamos la ruta del directorio lob a nuestro proyecto para despreocuparnos
# al agregarla en todo momento
# File.join(APP_ROOT, 'lib') =>  APP_ROOT/lib
$:.unshift( File.join(APP_ROOT, 'lib') )

# le décimos a Ruby q vamos a utilizar el controlador
require 'controlador'


controlador = Controlador.new('estudiantes.txt')
controlador.launch!
