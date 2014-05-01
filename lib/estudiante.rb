
class Estudiante

# Variable de clases con la dirección del archivo plano
  @@filepath = nil
  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end
  
  # Variables del estudiante
  attr_accessor :nombre, :identificador, :fecha_nacimiento
  
  # Verificamos que el archivo exista.
  def self.existe_archivo?
    if @@filepath && File.exists?(@@filepath)
      return true
    else
      return false
    end
  end
  
  # Validamos que el archivo existe, sea legible y modificable
  def self.validar_archivo?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end
  
  # Crea un archivo con permisos de Escritura
  def self.crear_archivo
    File.open(@@filepath, 'w') unless existe_archivo?
    return validar_archivo?
  end
  
  # recorremos el archivo plano y retornamos un arreglo con los 
  # objetos estudiantes que esten en el
  def self.estudiantes_guardados
    estudiantes = []
    if validar_archivo?
      file = File.new(@@filepath, 'r')
      file.each_line do |line|
        estudiantes << Estudiante.new.importar_linea(line.chomp)
      end
      file.close
    end
    return estudiantes
  end

  # Establece la estructura para solicitar los archivos 
  # en la aplicacion (el formulario en pocas palabras)
  def self.build_using_questions
    args = {}
    print "Nombre del estudiante: "
    args[:nombre] = gets.chomp.strip

    print "identificador: "
    args[:identificador] = gets.chomp.strip
    
    print "fecha de nacimiento: "
    args[:fecha_nacimiento] = gets.chomp.strip
    
    return self.new(args)
  end

  # Busca un estudiante por nombre o identificador
  def self.return_estudiante
    estBorrar = {}
    print "Introduce nombre del estudiante que desea eliminar: "
    estBorrar[:nombre] = gets.chomp.strip

    return self.new(estBorrar)     
  end
  
  # constructor de la aplicación, recibe los datos introducidos 
  # desde la aplicacion
  def initialize(args={})
    @nombre           = args[:nombre]    || ""
    @identificador    = args[:identificador] || ""
    @fecha_nacimiento = args[:fecha_nacimiento]   || ""
  end
  
  #convierte una linea del archivo plano a los
  # atrubutos del estudiante nombre, identificador y fecha
  def importar_linea(line)
    line_array = line.split("\t")
    @nombre, @identificador, @fecha_nacimiento = line_array
    return self
  end
  
  # guarda el archivo el estudiante en el archivo plano
  def guardar
    return false unless Estudiante.validar_archivo?
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[@nombre, @identificador, @fecha_nacimiento].join("\t")}\n"
    end
    return true
  end

  # En esta primera version será un método bastante rudimentario en el que 
  # simplemente leeremos el archivo y volveremos a reescribirlo sin insertar 
  # aquel estudiante que coincida con el que queremos borrar
  def borrar
    return false unless Estudiante.validar_archivo?

    estudiantes = Estudiante.estudiantes_guardados

    v_ok = false
    File.open(@@filepath, "w")
    estudiantes.select do |estd|
      unless estd.nombre.downcase.include?(@nombre.downcase)
        args = {}
        args[:nombre] = estd.nombre
        args[:identificador] = estd.identificador
        args[:fecha_nacimiento] = estd.fecha_nacimiento
        estGuardar = Estudiante.new(args)

        if estGuardar.guardar 
          v_ok = true
        else
          v_ok = false
        end
      end 
    end
    return v_ok
  end

end
