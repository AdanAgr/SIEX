; Templates

(deftemplate zona
    (slot nombre)
    (slot nivel)
    (slot temperatura)
    (slot ocupacion)
    (slot tipo)
    (slot estado-desastre)
    (slot iluminacion))

(deftemplate usuario
    (slot nombre)
    (slot nivel-acceso))

(deftemplate modulo-aire
    (slot sala)
    (slot temperatura-objetivo)
    (slot estado))


(deftemplate rack
    (slot id)
    (slot voltaje))

(deftemplate intento-acceso
    (slot usuario)
    (slot zona-nueva)
    (slot zona-antigua))



; Rules



; Regla para verificar acceso denegado
(defrule acceso-denegado
    ?intento <- (intento-acceso (usuario ?nombre-usuario) (zona-nueva ?nombre-zona-nueva) (zona-antigua ?nombre-zona-antigua))
    ?usuario <- (usuario (nombre ?nombre-usuario) (nivel-acceso ?nivel-acceso))
    ?zona-nueva <- (zona (nombre ?nombre-zona-nueva) (nivel ?nivel-zona-nueva))
    (test (< ?nivel-acceso ?nivel-zona-nueva))
    =>
    (printout t "Acceso denegado para " ?nombre-usuario " a la zona " ?nombre-zona-nueva ". Nivel de acceso insuficiente." crlf)
    (retract ?intento)  
)

; Regla para verificar acceso permitido
(defrule acceso-permitido
    ?intento <- (intento-acceso (usuario ?nombre-usuario) (zona-nueva ?nombre-zona-nueva) (zona-antigua ?nombre-zona-antigua))
    ?usuario <- (usuario (nombre ?nombre-usuario) (nivel-acceso ?nivel-acceso))
    ?zona-nueva <- (zona (nombre ?nombre-zona-nueva) (ocupacion ?ocupacion-nueva) (nivel ?nivel-zona-nueva))
    ?zona-antigua <- (zona (nombre ?nombre-zona-antigua) (ocupacion ?ocupacion-antigua))
    (test (>= ?nivel-acceso ?nivel-zona-nueva))
    =>
    (printout t "Acceso permitido para " ?nombre-usuario " a la zona " ?nombre-zona-nueva ". Nivel de acceso suficiente." crlf)
    (modify ?zona-nueva (ocupacion (+ ?ocupacion-nueva 1)))
    (modify ?zona-antigua (ocupacion (- ?ocupacion-antigua 1)))
    (retract ?intento)  
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
      (printout t "Incendio detectado en la zona " ?zona ". Zona sensible, sin ocupantes. Usando gas para apagarlo." crlf)
    else
      (printout t "Incendio detectado en la zona " ?zona ". Zona normal, sin ocupantes. Usando agua para apagarlo." crlf))
    (modify ?zona-datos (estado-desastre "normal")) ; Cambiar el estado a normal tras apagar el incendio
  else
    ; Si la zona está ocupada, proceder a la evacuación
    (printout t "Incendio detectado en la zona " ?zona ". Evacuando ocupantes." crlf)
    
    ; Realiza la evacuación
    (modify ?zona-datos (ocupacion 0))
    (printout t "Usuarios evacuados de "?zona". " crlf))
    (if (eq ?tipo-zona "sensible") then
      (printout t "Zona sensible, ocupantes evacuados. Usando gas para apagarlo." crlf)
    else
      (printout t "Zona normal, ocupantes evacuados. Usando agua para apagarlo." crlf))
    (modify ?zona-datos (estado-desastre "normal")) ; Actualiza ocupación a 0
    (printout t "Incendio controlado." crlf)
  )

; Control de Iluminacion

(defrule control-iluminacion
    ?zona <- (zona (nombre ?nombre) (ocupacion ?ocupacion) (iluminacion ?estado-iluminacion))
    (test (or (and (> ?ocupacion 0) (eq ?estado-iluminacion "apagada"))
              (and (= ?ocupacion 0) (eq ?estado-iluminacion "encendida"))))
    =>
    (if (> ?ocupacion 0) then
        (modify ?zona (iluminacion "encendida"))
        (printout t "Alguien ha entrado en "?nombre". Encendiendo luces." crlf)
    else
        (modify ?zona (iluminacion "apagada"))
        (printout t "No queda nadie en "?nombre". Apagando luces." crlf)))

; Control de Alimentacion
(defrule control-voltaje
    ?rack <- (rack (id ?id) (voltaje ?voltaje))
    (test (or(< ?voltaje 210) (> ?voltaje 230)))
    =>
    (printout t "Voltaje inadecuado en el rack con id: " ?id ". Reiniciando rack." crlf)
    (modify ?rack (voltaje 220))
)
