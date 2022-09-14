import config
import simulationtype


def make_config(simulation_type: simulationtype.SimulationType) -> config.Config:
    """
    Factory for Config (file paths ...)
    The paths are linked to the simulation folder name

    """
    try:
        new_config = None
        if not isinstance(simulation_type, simulationtype.SimulationType):
            raise TypeError(
                "Could not create config.",
                "This type of simulation: ", simulation_type, " is not handled!")
        if simulation_type == simulationtype.SimulationType.PROD:
            new_config = config.ConfigProd()
        elif simulation_type == simulationtype.SimulationType.TEST:
            new_config = config.ConfigTest()
        else:
            raise TypeError(f"This type of simulation ({simulation_type}) is not handled!")
        return new_config
    except TypeError as e:
        print(e)
        return None
