; Facts iniciales de zonas
(deffacts zonas-iniciales

    (zona (nombre "Pasillo") (nivel 1) (temperatura 20) (ocupacion 0) (tipo "normal") (estado-desastre "normal") (iluminacion "apagada"))
    (zona (nombre "Cafeteria") (nivel 1) (temperatura 21) (ocupacion 1) (tipo "normal") (estado-desastre "normal") (iluminacion "encendida"))
    (zona (nombre "Despacho") (nivel 2) (temperatura 21) (ocupacion 1) (tipo "normal") (estado-desastre "normal") (iluminacion "encendida"))
    (zona (nombre "Teleco") (nivel 2) (temperatura 23) (ocupacion 1) (tipo "sensible") (estado-desastre "normal") (iluminacion "encendida"))
    (zona (nombre "Servidores") (nivel 3) (temperatura 23) (ocupacion 0) (tipo "sensible") (estado-desastre "normal") (iluminacion "apagada"))
    (zona (nombre "Zona de control") (nivel 3) (temperatura 22) (ocupacion 1) (tipo "sensible") (estado-desastre "normal") (iluminacion "encendida"))
    (zona (nombre "Zona de Alimentacion (SAI)") (nivel 3) (temperatura 22) (ocupacion 0) (tipo "sensible") (estado-desastre "normal") (iluminacion "apagada")))


; Facts iniciales de usuarios
(deffacts control-de-accesos
    (usuario (nombre "Directora María del Carmen") (nivel-acceso 3))
    (usuario (nombre "Controlador Juan Carlos (JC)") (nivel-acceso 3))
    (usuario (nombre "Especialista en redes Martín") (nivel-acceso 2))
    (usuario (nombre "Limpiadora Estela") (nivel-acceso 1))
    (usuario (nombre "Camarero Iván Luis") (nivel-acceso 1)))

; Facts iniciales del módulo de climatización
(deffacts inicial-modulo-climatizacion
    (modulo-aire (sala "Pasillo") (temperatura-objetivo 22) (estado "apagado"))
    (modulo-aire (sala "Cafeteria") (temperatura-objetivo 22) (estado "apagado"))
    (modulo-aire (sala "Despacho") (temperatura-objetivo 22) (estado "apagado"))
    (modulo-aire (sala "Teleco") (temperatura-objetivo 22) (estado "apagado"))
    (modulo-aire (sala "Servidores") (temperatura-objetivo 22) (estado "apagado"))
    (modulo-aire (sala "Zona de control") (temperatura-objetivo 22) (estado "apagado"))
    (modulo-aire (sala "Zona de Alimentacion (SAI)") (temperatura-objetivo 22) (estado "apagado")))


; Facts iniciales de racks
(deffacts racks-iniciales
    (rack (id 1) (voltaje 220))
    (rack (id 2) (voltaje 222)))

