from configobj import ConfigObj
from os import environ

filename = environ['HOME'] + '/.config/terminator/config'

config = ConfigObj(filename)
config['profiles']['default']['font'] = 'Monospace 10'
config['profiles']['default']['use_system_font'] = 'False'
config.write()
