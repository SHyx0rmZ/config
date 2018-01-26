from configobj import ConfigObj
from os import environ

filename = environ['HOME'] + '/.config/terminator/config'

config = ConfigObj(filename)
config['profiles']['default']['font'] = 'M+ 2m Medium 13'
config['profiles']['default']['use_system_font'] = 'False'
config['profiles']['default']['scrollback_infinite'] = 'True'
config.write()
