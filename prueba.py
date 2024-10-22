import clips
import time

# Inicializar entorno CLIPS
environment = clips.Environment()

# Cargar templates, reglas y hechos iniciales
environment.load("deftemplate.clp")
environment.load("deffacts.clp")

# Cargar hechos iniciales en memoria activa y emparejar reglas
environment.reset()

# Imprimir hechos iniciales de usuario
for fact in environment.facts():
    if fact.template.name == "usuario":
        print(f"Usuario: {fact['nombre']}, Nivel: {fact['nivel-acceso']}, Ubicación: {fact['ubicacion']}")

print("----------------------- SIMULACIÓN DE TEMPERATURA -----------------------")

environment.load("temperatura.clp")
environment.reset()
environment.run()

print("----------------------- FIN -----------------------")

