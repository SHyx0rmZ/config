from configobj import ConfigObj
from os import environ, makedirs
from os.path import exists

dirname = environ['HOME'] + '/.config/terminator'
filename = dirname + '/config'

if not exists(dirname):
    makedirs(dirname)

config = ConfigObj(filename)
if 'profiles' not in config:
    config['profiles'] = {}
if 'default' not in config['profiles']:
    config['profiles']['default'] = {}
config['profiles']['default']['font'] = 'M+ 2m Medium 13'
config['profiles']['default']['use_system_font'] = 'False'
config['profiles']['default']['scrollback_infinite'] = 'True'
config.write()
