# uml: class diagram

Here I will embed PlantUML markup to generate a class diagram.

I can include as many plantuml segments as I want in my Markdown, and the diagrams can be of any type supported by PlantUML.

```plantuml
@startuml
    skinparam backgroundColor #EEEBDC
    skinparam handwritten false
    class Simulation {
        + SimulationType type
        + Config config
        + Path folder
        + Path excel_file_path
        + set scenario_names
    }

    enum SimulationType {
        PROD
        TEST
    }

    class Config {
        +met_root_path()
    }
@enduml
```
