vlayer = iface.activeLayer()
labeling = vlayer.labeling()
labeling.settings()
# plante propKeys = ddprops.propertyKeys()
pc = QgsPropertyCollection("pos_label")
pc.setProperty(9,"x_at(-1)")
pc.setProperty(10,"y_at(-1)")
vlayer.labeling().setDataDefinedProperties(pc)