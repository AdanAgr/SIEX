; Templates

(deftemplate zona
    (slot nombre)
    (slot nivel)
    (slot temperatura)
    (slot ocupacion)
    (slot tipo)
    (slot estado-desastre))

(deftemplate usuario
    (slot nombre)
    (slot nivel-acceso)
    (slot ubicacion))

(deftemplate modulo-aire
    (slot sala)
    (slot temperatura-objetivo)
    (slot estado))

(deftemplate desastres
    (slot tipo)
    (slot zona)
    (slot estado)) 

(deftemplate luz
    (slot sala)
    (slot estado))

(deftemplate rack
    (slot id)
    (slot temperatura) 
    (slot voltaje))

(deftemplate sensor
    (slot id)
    (slot zona)
    (slot temperatura))

(deftemplate sensor-desastres
    (slot id)
    (slot tipo)
    (slot zona)
    (slot aviso))



; Rules


; Reglas de control de accesos
(defrule acceso-zona
    ?usuario <- (usuario (nombre ?nombre) (nivel-acceso ?nivel-usuario) (ubicacion ?ubicacion))
    ?zona <- (zona (nombre ?nueva-zona) (nivel ?nivel-zona))
    (test (>= ?nivel-usuario ?nivel-zona))
    =>
    (retract ?usuario)
    (modify ?zona (ocupacion (+ (ocupacion ?zona) 1)))
    (assert (usuario (nombre ?nombre) (nivel-acceso ?nivel-usuario) (ubicacion ?nueva-zona))))

(defrule salida-zona
    ?usuario <- (usuario (nombre ?nombre) (ubicacion ?ubicacion))
    ?zona <- (zona (nombre ?ubicacion))
    =>
    (modify ?zona (ocupacion (- (ocupacion ?zona) 1)))
    (modify ?usuario (ubicacion "Pasillo")))

; Control de climatizacion
(defrule control-temperatura
    ?zona <- (zona (nombre ?nombre) (temperatura ?temp))
    ?modulo <- (modulo-aire (sala ?nombre) (temperatura-objetivo 22) (estado "apagado"))
    (or (test (< ?temp 20)) (test (> ?temp 25)))
    =>
    (modify ?modulo (estado "encendido")))

(defrule ajustar-temperatura
    ?modulo <- (modulo-aire (sala ?sala) (temperatura-objetivo 22) (estado "encendido"))
    ?zona <- (zona (nombre ?sala) (temperatura ?temp))
    (test (<> ?temp 22))
    =>
    (if (< ?temp 22)
        then (modify ?zona (temperatura (+ ?temp 1)))
        else (modify ?zona (temperatura (- ?temp 1))))
    (if (= ?temp 22)
        then (modify ?modulo (estado "apagado"))))

; Detección de desastres
(defrule deteccion-desastre
    ?sensor <- (sensor-desastres (tipo ?tipo) (zona ?zona) (aviso "activo"))
    ?zona <- (zona (nombre ?zona) (estado-desastre "normal"))
    =>
    (printout t "¡Alerta de desastre por " ?tipo " en la zona " ?zona "! Todo el mundo debe evacuar al pasillo." crlf)
    (modify ?zona (estado-desastre "en-desastre"))
    (forall (usuario (ubicacion ?zona))
        (retract ?usuario)
        (assert (usuario (ubicacion "Pasillo")))))

; Control de Alimentacion
(defrule control-luz-encender
    ?zona <- (zona (nombre ?nombre) (ocupacion ?ocup))
    ?luz <- (luz (sala ?nombre) (estado "apagado"))
    (test (> ?ocup 0))
    =>
    (modify ?luz (estado "encendido")))

(defrule control-luz-apagar
    ?zona <- (zona (nombre ?nombre) (ocupacion ?ocup))
    ?luz <- (luz (sala ?nombre) (estado "encendido"))
    (test (= ?ocup 0))
    =>
    (modify ?luz (estado "apagado")))

(defrule alerta-voltaje-rack
    ?rack <- (rack (id ?id) (voltaje ?volt))
    (or (test (< ?volt 210)) (test (> ?volt 230)))
    =>
    (printout t "Alerta: Voltaje fuera de rango en el rack " ?id ". Ajustando a 220V." crlf)
    (modify ?rack (voltaje 220)))