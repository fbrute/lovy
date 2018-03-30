import os.path

class Utils:

    """ Share good stuff across python files """

    def __init__(self):
        self.module_name = 'Utils'

def image_name(filename):
    return os.path.splitext(os.path.basename(filename))[0]+'.png'

