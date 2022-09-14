import simulation
import simulationtype


def make_simulation(
    simulation_type: simulationtype.SimulationType = simulationtype.SimulationType.TEST,
) -> simulation.Simulation:

    """ Create a Simulation according to the type """

    try:
        if not isinstance(simulation_type, simulationtype.SimulationType):
            raise TypeError(
                "Could not create Simulation with type:",
                type(simulation)
            )
        if simulation_type == simulationtype.SimulationType.PROD:
            return simulation.SimulationProd(type=simulation_type)
        elif simulation_type == simulationtype.SimulationType.TEST:
            return simulation.SimulationTest(type=simulation_type)
        return None
    except (simulation.SimulationError) as e:
        print(e)
        print(e.args)
        return None
