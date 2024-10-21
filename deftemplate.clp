; Templates

(deftemplate zona
    (slot nombre)
    (slot nivel)
    (slot temperatura)
    (slot humedad)
    (slot ocupacion)
    (slot tipo))

(deftemplate usuario
    (slot nombre)
    (slot nivel-acceso)
    (slot ubicacion))

(deftemplate modulo-aire
    (slot sala)
    (slot temperatura-objetivo)
    (slot estado))

(deftemplate ventilador
    (slot sala)
    (slot potencia)
    (slot humedad-objetivo)
    (slot estado))

(deftemplate calefacción-global
    (slot estado)
    (slot potencia))


(deftemplate desastres
    (slot tipo)
    (slot sala)
    (slot estado))

(deftemplate luz
    (slot sala)
    (slot estado))
    
(deftemplate rack
    (slot id)
    (slot temperatura)
    (slot voltaje)) ; (De 100V a 300 V) (Voltaje Ideal de 210 a 230V)
(deftemplate sensor
    (slot id)
    (slot tipo)
    (slot medicion))

; Reglas 
