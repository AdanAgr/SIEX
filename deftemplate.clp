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



; Rules


; Reglas de control de accesos
(defrule acceso-zona
    ?usuario <- (usuario (nombre ?nombre) (nivel-acceso ?nivel-usuario) (ubicacion ?ubicacion))
    ?zona <- (zona (nombre ?nueva-zona) (nivel ?nivel-zona))
    (test (>= ?nivel-usuario ?nivel-zona))
    =>
    (retract ?usuario)
    (modify ?zona (ocupacion (+ (fact-slot-value ?zona ocupacion) 1)))
)

(defrule salida-zona
    ?usuario <- (usuario (nombre ?nombre) (ubicacion ?ubicacion))
    ?zona <- (zona (nombre ?ubicacion))
    =>
    (modify ?zona (ocupacion (- (fact-slot-value ?zona ocupacion) 1)))
    (modify ?usuario (ubicacion "Pasillo"))
)

; Control de climatizacion

(defrule control-temperatura
    ?zona <- (zona (nombre ?nombre) (temperatura ?temp))
    ?modulo <- (modulo-aire (sala ?nombre) (temperatura-objetivo 22) (estado "apagado"))
    (or (test (< ?temp 20)) (test (> ?temp 25)))
    =>
    (modify ?modulo (estado "encendido"))
    (printout t crlf "Temperatura en " ?nombre " no ideal, aire encendido" crlf))

(defrule ajustar-temperatura
    ?modulo <- (modulo-aire (sala ?sala) (temperatura-objetivo 22) (estado "encendido"))
    ?zona <- (zona (nombre ?sala) (temperatura ?temp))
    (test (!= ?temp 22))
    =>
    (if (< ?temp 22)
        then (progn
            (modify ?zona (temperatura (+ ?temp 1)))
            (printout t "Ajustando temperatura en " ?sala " de " ?temp " a " (+ ?temp 1) crlf))
        else (progn
            (modify ?zona (temperatura (- ?temp 1)))
            (printout t "Ajustando temperatura en " ?sala " de " ?temp " a " (- ?temp 1) crlf))))

(defrule temperatura-ajustada
    ?modulo <- (modulo-aire (sala ?sala) (temperatura-objetivo 22) (estado "encendido"))
    ?zona <- (zona (nombre ?sala) (temperatura ?temp))
    (test (= ?temp 22))
    =>
    (modify ?modulo (estado "apagado"))
    (printout t "Temperatura en " ?sala " ideal, aire apagado " crlf))

; Detección de desastres
(defrule manejar-incendio
  ?zona-datos <- (zona (nombre ?zona) (tipo ?tipo-zona) (ocupacion ?ocupacion) (estado-desastre "activo"))
  =>
  (if (eq ?ocupacion 0) then
    ; Si la zona está vacía
    (if (eq ?tipo-zona "sensible") then
      (printout t "Incendio detectado en la zona " ?zona ". Zona sensible, sin ocupantes. Se usará gas para apagarlo." crlf)
    else
      (printout t "Incendio detectado en la zona " ?zona ". Zona normal, sin ocupantes. Se usará agua para apagarlo." crlf))
    (modify ?zona-datos (estado-desastre "normal")) ; Cambiar el estado a normal tras apagar el incendio
  else
    ; Si la zona está ocupada, proceder a la evacuación
    (printout t "Incendio detectado en la zona " ?zona ". Evacuando ocupantes." crlf)
    
    ; Realiza la evacuación
    (printout t "Evacuando a todos los usuarios de " ?zona " al Pasillo." crlf)
    (modify ?zona-datos (ocupacion 0)) ; Actualiza ocupación a 0
    (modify ?zona-datos (estado-desastre "normal")) ; Cambia el estado de desastre a normal
    (printout t "Todos los usuarios evacuados de " ?zona ". Incendio controlado." crlf)
  )
)

(defrule mover-usuarios-pasillo
  ?zona <- (zona (nombre ?nombre) (ocupacion 0)) ; Encuentra la zona con ocupación 0
  ?usuario <- (usuario (ubicacion ?nombre)) ; Encuentra usuarios en esa zona
  =>
  (printout t "Moviendo al usuario " (fact-slot-value ?usuario nombre) " al Pasillo desde " ?nombre crlf)
  (modify ?usuario (ubicacion "Pasillo")) ; Mueve el usuario al pasillo
)


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