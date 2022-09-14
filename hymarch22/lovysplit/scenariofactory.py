import scenario
import simulationtype


def make_scenario(
    name="Scenario",
    mode=simulationtype.SimulationType.TEST,
    action=scenario.ConfigAction.RUN,
    excel_file_path=None
):
    """ Create a Scenario object """
    try:
        if not isinstance(mode, simulationtype.SimulationType):
            raise scenario.ScenarioError("cannot create scenario with mode:", mode)
        if name.isspace() or len(name) == 0:
            raise scenario.ScenarioError("cannot create scenario with name:", name)
        if excel_file_path is None or not excel_file_path.exists():
            raise scenario.ScenarioError(
                "cannot create scenario with excel_file_path:",
                excel_file_path
            )
        return scenario.Scenario(
            name=name,
            mode=mode,
            action=action,
            excel_file_path=excel_file_path
        )
    except(scenario.ScenarioError) as e:
        print(e.args)
        return None
