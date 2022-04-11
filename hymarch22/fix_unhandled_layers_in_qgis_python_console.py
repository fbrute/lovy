for layer in QgsProject.instance().mapLayers().values():
    name = layer.name()
    provider = layer.providerType()
    options = layer.dataProvider().ProviderOptions()
    new_path = '/home/kwabena/trafin/lovy/hymarch22/results/dust_cases'
    new_url = new_path+str(name) +".shp"
    layer.setDataSource(new_url, name, provider, options)
