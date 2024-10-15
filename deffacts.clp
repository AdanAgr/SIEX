(deffacts zonas-iniciales
    (zona (nombre "Pasillo") (nivel 1) (temperatura 30) (humedad 50) (ocupacion 1) (tipo "normal"))
    (zona (nombre "Cafeteria") (nivel 1) (temperatura 30) (humedad 50) (ocupacion 1) (tipo "normal"))
    (zona (nombre "Despacho") (nivel 2) (temperatura 30) (humedad 50) (ocupacion 1) (tipo "normal"))
    (zona (nombre "Teleco") (nivel 2) (temperatura 30) (humedad 50) (ocupacion 1) (tipo "sensible"))
    (zona (nombre "Servidores") (nivel 2) (temperatura 30) (humedad 50) (ocupacion 0) (tipo "sensible"))
    (zona (nombre "Zona de control") (nivel 3)  (temperatura 30) (humedad 50) (ocupacion 1) (tipo "sensible"))
    (zona (nombre "Zona de Alimentacion (SAI)") (nivel 3) (temperatura 30) (humedad 50) (ocupacion 0) (tipo "sensible")))

(deffacts control-de-accesos
    (usuario (nombre "Directora María del Carmen") (nivel-acceso 3) (ubicacion "Despacho"))
    (usuario (nombre "Controlador Juan Carlos (JC)") (nivel-acceso 3) (ubicacion "Zona de control"))
    (usuario (nombre "Especialista en redes Martín") (nivel-acceso 2) (ubicacion "Teleco"))
    (usuario (nombre "Limpiadora Estela") (nivel-acceso 1) (ubicacion "Pasillo"))
    (usuario (nombre "Camarero Iván Luis") (nivel-acceso 1) (ubicacion "Cafeteria")))


(deffacts inicial-modulo-climatizacion
    (modulo-aire (sala "Pasillo") (temperatura-objetivo 23) (estado "apagado"))
    (modulo-aire (sala "Cafeteria") (temperatura-objetivo 23) (estado "apagado"))
    (modulo-aire (sala "Despacho") (temperatura-objetivo 23) (estado "apagado"))
    (modulo-aire (sala "Teleco") (temperatura-objetivo 23) (estado "apagado"))
    (modulo-aire (sala "Servidores") (temperatura-objetivo 23) (estado "apagado"))
    (modulo-aire (sala "Zona de control") (temperatura-objetivo 23) (estado "apagado"))
    (modulo-aire (sala "Zona de Alimentacion (SAI)") (temperatura-objetivo 23) (estado "apagado"))

    (ventilador (sala "Pasillo") (potencia 0) (humedad-objetivo 50) (estado "apagado"))
    (ventilador (sala "Cafeteria") (potencia 0) (humedad-objetivo 50) (estado "apagado"))
    (ventilador (sala "Despacho") (potencia 0) (humedad-objetivo 50) (estado "apagado"))
    (ventilador (sala "Teleco") (potencia 0) (humedad-objetivo 50) (estado "apagado"))
    (ventilador (sala "Servidores") (potencia 0) (humedad-objetivo 50) (estado "apagado"))
    (ventilador (sala "Zona de control") (potencia 0) (humedad-objetivo 50) (estado "apagado"))
    (ventilador (sala "Zona de Alimentacion (SAI)") (humedad-objetivo 50) (potencia 0) (estado "apagado"))
    
    (calefacción-global (estado "apagado") (potencia 0))
    )

(deffacts control-de-iluminación
    (luz (sala "Pasillo") (estado "apagado"))
    (luz (sala "Cafeteria") (estado "apagado"))
    (luz (sala "Despacho") (estado "apagado"))
    (luz (sala "Teleco") (estado "apagado"))
    (luz (sala "Servidores") (estado "apagado"))
    (luz (sala "Zona de control") (estado "apagado"))
    (luz (sala "Zona de Alimentacion (SAI)") (estado "apagado"))
    )