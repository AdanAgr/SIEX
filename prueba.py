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
        print(f"Usuario: {fact['nombre']}, Nivel: {fact['nivel-acceso']}")

print("----------------------- SIMULACIÓN DE ACCESOS -----------------------")

environment.load("accesos.clp")
environment.reset()
environment.run()

print("----------------------- SIMULACIÓN DE TEMPERATURA -----------------------")

environment.load("temperatura.clp")
environment.reset()
environment.run()

print("----------------------- SIMULACIÓN DE INCENDIO -----------------------")

environment.load("incendio.clp")
environment.reset()
environment.run()

print("----------------------- SIMULACIÓN DE ILUMINACIÓN -----------------------")

environment.load("iluminacion.clp")
environment.reset()
environment.run()

print("----------------------- SIMULACIÓN DE VOLTAJE -----------------------")

environment.load("voltaje.clp")
environment.reset()
environment.run()

print("----------------------- FIN -----------------------")

