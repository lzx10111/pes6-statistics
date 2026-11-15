# ⚽ PES 6 Match Data — `shotsOnGoal` JSON Specification

Documentación técnica de los campos extraídos desde la memoria de **Pro Evolution Soccer 6** para la sección de **Disparos a puerta (`shotsOnGoal`)**, incluyendo tablas de equivalencias, sistema de coordenadas del campo y reglas de transformación para visualización en Python.

---

## 📋 Tabla de Contenidos

1. [Estructura Principal del Equipo](#1-estructura-principal-del-equipo)
2. [Objeto Disparo (`shots[i]`)](#2-objeto-disparo-shotsi)
3. [Objeto Paso de Jugada (`steps[j]`)](#3-objeto-paso-de-jugada-stepsj)
   - [A. Identificación y Acción](#a-identificación-y-acción)
   - [B. Coordenadas Espaciales del Campo](#b-coordenadas-espaciales-del-campo)
4. [Ejemplo Completo Comentado](#4-ejemplo-completo-comentado)
5. [Ejemplo de Procesamiento en Python](#5-ejemplo-de-procesamiento-en-python)

---

## 1. Estructura Principal del Equipo

Cada bando (`home` y `away`) contiene el conteo total y la lista cronológica de disparos a puerta.

| Campo | Tipo | Descripción | Ejemplo |
| :--- | :---: | :--- | :---: |
| `totalShots` | `int` | Cantidad total de disparos a puerta realizados por el equipo. | `5` |
| `shots` | `array<object>` | Arreglo ordenado cronológicamente con cada disparo del equipo. | `[ {...}, {...} ]` |

---

## 2. Objeto Disparo (`shots[i]`)

Representa un evento individual de remate a puerta junto con el marcador exacto en ese instante.

| Campo | Tipo | Descripción y Regla de Transformación | Ejemplo |
| :--- | :---: | :--- | :---: |
| `minute` | `int` | Minuto del partido en el que ocurrió el disparo. No requiere transformación. | `27` *(Minuto 27')* |
| `distance` | `int` | Distancia estimada en metros desde el punto del remate hasta la portería. | `6` *(6m)* |
| `homeScore` | `int` | Goles del equipo **Local** inmediatamente después de resolverse este disparo. | `1` |
| `awayScore` | `int` | Goles del equipo **Visitante** inmediatamente después de resolverse este disparo. | `0` |
| `shooterNodeIndex` | `int` | **Índice base-0** dentro de `steps` que señala qué nodo pertenece al rematador.<br>**Uso:** `shooter = shot["steps"][shot["shooterNodeIndex"]]` | `1` |
| `assistNodeIndex` | `int` | **Índice base-0** dentro de `steps` que señala al asistidor del gol.<br>• **`255` (`0xFF`):** Sin asistencia.<br>• **`< 255`:** `assist = shot["steps"][shot["assistNodeIndex"]]` | `0` *(asistió `steps`)*<br>`255` *(sin asistencia)* |
| `stepsCount` | `int` | Cantidad de nodos/acciones que componen la jugada (`len(steps)`). | `3` |
| `steps` | `array<object>` | Secuencia de intervenciones de la jugada (pase previo → remate → desvío/atajada). | `[ {...}, {...} ]` |

> **💡 Tip para detectar si el disparo terminó en GOL:**  
> Compara `(homeScore, awayScore)` del disparo actual contra el disparo anterior del partido (o verifica si el balón cruzó `targetX >= 13464.0` con `targetY` dentro del ancho de los postes `[-626.5, 626.5]` sin desvío posterior afuera).

---

## 3. Objeto Paso de Jugada (`steps[j]`)

Cada disparo se descompone en 2 o 3 pasos (`32 bytes` por nodo en memoria) que permiten reconstruir el diagrama táctico de la repetición.

### A. Identificación y Acción

| Campo | Tipo | Descripción y Equivalencias | Ejemplo |
| :--- | :---: | :--- | :---: |
| `team` | `int` | Equipo al que pertenece el jugador de este nodo:<br>• `0` = Local (`home`)<br>• `1` = Visitante (`away`) | `0` |
| `playerSlot` | `int` | Índice de slot táctico (`0..31`) del jugador en el partido.<br>**Transformación:** Cruzar con `matchPlayers` para resolver `name` y `shirtNumber`. | `3` |
| `playerPosition` | `int` | Posición táctica del jugador durante esa acción:<br>• `0` = **PT** (Portero)<br>• `1` = **DE** (Defensa)<br>• `2` = **ME** (Mediocampista)<br>• `3` = **DL** (Delantero) | `1` *(DE)* |
| `actionType` | `int` | Tipo de golpeo o interacción con el balón:<br>• `0` = Desvío / Bloqueo / Otros (`Otros`)<br>• `1` = Cabezazo (`Cabezazo`)<br>• `2` = Balón suelto / Rebote (`Balón suelto`)<br>• `3` = Disparo con pie derecho (`Disparo (D)`)<br>• `4` = Cabezazo / Pase de cabeza (`Cabezazo`)<br>• `5` = Pase bajo (`Pase bajo`)<br>• `6` = Cabezazo de gol (`Cabezazo`)<br>• `7` = Pase aéreo (`Pase aéreo`)<br>• `8` = Disparo con pie izquierdo (`Disparo (I)`)<br>• `9` = Disparo con pie derecho (`Disparo (D)`)<br>• `10` = Pase bajo (`Pase bajo`) | `7` *(Pase aéreo)*<br>`9` *(Disparo D)* |
| `flag` | `int` | Indicador de conducción/contacto (`0` = toque directo; `1` = conducción/desplazamiento activo). | `1` |

---

### B. Coordenadas Espaciales del Campo

PES 6 normaliza todas las jugadas en el radar de *Disparos a puerta* haciendo que **el equipo atacante siempre avance de izquierda a derecha hacia `+X`**.

| Campo | Tipo | Qué representa en el campo | Ejemplo |
| :--- | :---: | :--- | :---: |
| `startX`, `startY` | `float` | Punto exacto donde el jugador **recibe o inicia** su intervención con el balón. | `(6277.89, 5471.28)` |
| `endX`, `endY` | `float` | Punto exacto desde donde el jugador **ejecuta el pase o disparo**.<br>**Regla de Regate:** Si `(startX, startY) != (endX, endY)`, el jugador condujo el balón y se dibuja la línea de **`Regate`** entre `start` y `end`. | `(12166.12, 5554.81)` |
| `targetX`, `targetY` | `float` | Punto de destino hacia donde va el balón (recepción del compañero o cruce por línea de gol). | `(11906.34, 542.95)` |

#### 📐 Referencia del Sistema de Coordenadas
* **Eje X (Largo del campo):**
  * `0.0` ≈ Línea de medio campo.
  * `13465.0` ≈ **Línea de fondo / Línea de gol** (los remates a puerta apuntan a `targetX ≈ 13465.0`).
* **Eje Y (Ancho del campo):**
  * `0.0` = Centro exacto de la portería.
  * `-626.5` a `+626.5` ≈ Ancho entre los dos postes del arco.
  * `-9000.0` a `+9000.0` ≈ Líneas de banda izquierda y derecha.

---

## 4. Ejemplo Completo Comentado

Ejemplo real correspondiente a un gol de cabeza/remate tras centro aéreo en el minuto `27'`:

```json
{
  "minute": 27,
  "distance": 6,
  "homeScore": 1,
  "awayScore": 0,
  "shooterNodeIndex": 1,
  "assistNodeIndex": 0,
  "stepsCount": 3,
  "steps": [
    {
      "team": 0,
      "playerPosition": 2,
      "actionType": 7,
      "flag": 1,
      "playerSlot": 2,
      "startX": 6277.892578125,
      "startY": 5471.2861328125,
      "endX": 12166.125,
      "endY": 5554.8173828125,
      "targetX": 11906.349609375,
      "targetY": 542.9521484375
    },
    {
      "team": 0,
      "playerPosition": 2,
      "actionType": 9,
      "flag": 0,
      "playerSlot": 3,
      "startX": 11906.349609375,
      "startY": 542.9521484375,
      "endX": 11906.349609375,
      "endY": 542.9521484375,
      "targetX": 12252.716796875,
      "targetY": 208.8271484375
    },
    {
      "team": 1,
      "playerPosition": 0,
      "actionType": 3,
      "flag": 0,
      "playerSlot": 0,
      "startX": 12252.716796875,
      "startY": 208.8271484375,
      "endX": 12252.716796875,
      "endY": 208.8271484375,
      "targetX": 13464.998046875,
      "targetY": -41.765625
    }
  ]
}
```

---

## 5. Ejemplo de Procesamiento en Python

```python
POSITION_MAP = {0: "PT", 1: "DE", 2: "ME", 3: "DL"}

ACTION_MAP = {
    0: "Otros",
    1: "Cabezazo",
    2: "Balón suelto",
    3: "Disparo (D)",
    4: "Cabezazo",
    5: "Pase bajo",
    6: "Cabezazo",
    7: "Pase aéreo",
    8: "Disparo (I)",
    9: "Disparo (D)",
    10: "Pase bajo",
}

def parse_shot(shot: dict) -> dict:
    steps = shot["steps"]
    shooter = steps[shot["shooterNodeIndex"]]
    assist = steps[shot["assistNodeIndex"]] if shot["assistNodeIndex"] != 255 else None

    parsed_steps = []
    for step in steps:
        has_dribble = (step["startX"] != step["endX"]) or (step["startY"] != step["endY"])
        parsed_steps.append({
            "team": "home" if step["team"] == 0 else "away",
            "position": POSITION_MAP.get(step["playerPosition"], "N/A"),
            "action": ACTION_MAP.get(step["actionType"], f"Unknown({step['actionType']})"),
            "hasDribble": has_dribble,
            "coords": {
                "start": (step["startX"], step["startY"]),
                "end": (step["endX"], step["endY"]),
                "target": (step["targetX"], step["targetY"]),
            }
        })

    return {
        "minute": shot["minute"],
        "distance_m": shot["distance"],
        "score": f"{shot['homeScore']} - {shot['awayScore']}",
        "hasAssist": assist is not None,
        "steps": parsed_steps,
    }
```
