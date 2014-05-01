require 'estudiante'
require 'support/string_extend'
class Controlador

  # Clase con la configuracion del proyecto
  # lista las acciones que vamos a tener
  class Config
    @@actions = ['listar', 'buscar', 'agregar', 'eliminar', 'salir']
    def self.actions; @@actions; end
  end
  
  # constructor de la clase En esta verificaremos 
  # si existe el archivo plano con los estudiantes 
  # y si no creamos uno nuevo
  def initialize(path=nil)
    # localizamos el archivo de estudiantes
    Estudiante.filepath = path
    if Estudiante.existe_archivo?
      puts "se encontro la base de datos de estudiantes."
    # o creamos un archivo nuevo
    elsif Estudiante.crear_archivo
      puts "Se creo la base de datos de estudiantes."
    
    else
      puts "salir.\n\n"
      exit!
    end
  end

 # launch! este metodo tiene un loop que va a recibir las acciones 
 # que tendrá la aplicación para procesarlas
 # llama al encabezado y pie de aplicacion al principio y al final
  def launch!
    introduction
    
    result = nil
    until result == :quit
      action, args = acciones
      result = hacer_accion(action, args)
    end
		conclusion
  end
  
  # nos da las acciones que que vamos a utilizar en nustro proyecto
  # y nos prepara el sistema para recibir las acciones por el usuario
  def acciones
    action = nil
    
    until Controlador::Config.actions.include?(action)
      puts "Acciones: " + Controlador::Config.actions.join(", ")
      print "> "
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
    end

    return action, args
  end
  
  # Recive la accion que se solicitaron por pantalla y
  # se llaman las funciones que cumplan los requisitos del usuario
  def hacer_accion(action, args=[])
    case action
    when 'listar'
      listar(args)
    when 'buscar'
      palabra_clave = args.shift
      buscar(palabra_clave)
    when 'agregar'
      agregar
    when 'eliminar'
      eliminar
    when 'salir'
      return :quit
    else
      puts "\nel comando no es valido\n"
    end
  end

 # metodo busca a todos los estudiantes y los lista
 # tambien ordena principalmente por nombre o por la accion de su preferencia
  def listar(args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'por'
    sort_order = "nombre" unless ['nombre', 'identificador', 'fecha'].include?(sort_order)
    
    titulo("Listando usuarios")
    
    estudiantes = Estudiante.estudiantes_guardados
    estudiantes.sort! do |r1, r2|
      case sort_order
      when 'nombre'
        r1.nombre.downcase <=> r2.nombre.downcase
      when 'identificador'
        r1.identificador.downcase <=> r2.identificador.downcase
      when 'fecha'
        r1.fecha_nacimiento.to_i <=> r2.fecha_nacimiento.to_i
      end
    end
    prepara_tabla(estudiantes)
    puts "Ordena escribiendo: 'listar nombre' o 'listar por identificador'\n\n"
  end
  
  # primero consulta todos los estudiantes del archivo de texto
  # luego busca que en alguno de sus atributos tenga la palabra clave 
  # que se esta busc ando.
  def buscar(keyword="")
    titulo("Buscar usaurio")
    if keyword
      estudiantes = Estudiante.estudiantes_guardados
      found = estudiantes.select do |estd|
        estd.nombre.downcase.include?(keyword.downcase) || 
        estd.identificador.downcase.include?(keyword.downcase) || 
        estd.fecha_nacimiento.include?(keyword.downcase)
      end
      prepara_tabla(found)
    else
      puts "Examples: 'buscar Ricardo', 'buscar 12345', 'buscar sampayo'\n\n"
    end
  end
  
    # Crea la estructura para recibir los datos en una especie de formulario
  # los recibe crea un objeto Estudiante y lo guarda en el archivo
  def agregar
    titulo("Agregar estudiante")
    estudiante = Estudiante.build_using_questions
    if estudiante.guardar
      puts "\nBien! Se agrego el usuario\n\n"
    else
      puts "\nError: No se agrego el usuario\n\n"
    end
  end

  
  #Elimina el estudiante elegido
  def eliminar
    titulo("Eliminar estudiante")
    estudiante = Estudiante.return_estudiante
    if estudiante.borrar
      puts "Estudiante eliminado correctamente :)\n\n"
    else
      puts "Error al borrar estudiante\n\n"
    end
  end

  # encabezado de la aplicacion
  def introduction
    puts "#" * 60
    puts "\n\n--- Bienvenido a al tutorial de CODEHERO ---\n"
    puts "Este ejemplo pertenece a la serie Ruby desde Cero.\n\n"
  end

  # pie de la aplicacion
	def conclusion
  	puts "\n--- Hasta luego y recuerda visitarnos en www.CodeHero.co! ---\n\n\n"
    puts "#" * 60
	end
	
	private
	
	def titulo(texto)
	  puts "\n#{texto.upcase.center(60)}\n\n"
	end
	
	def prepara_tabla(estudiantes=[])
    print " " + "Identificador".ljust(30)
    print " " + "Nombre".ljust(20)
    print " " + "Fecha".rjust(6) + "\n"
    puts "-" * 60
    estudiantes.each do |rest|
      line =  " " << rest.identificador.ljust(30)
      line << " " + rest.nombre.titleize.ljust(20)
      line << " " + rest.fecha_nacimiento.rjust(6)
      puts line
    end
    puts "No hay estudiantes" if estudiantes.empty?
    puts "-" * 60
  end
  
end
