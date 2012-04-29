require './authorization'
require './dashboard'
require './board'

use Authorization
use Dashboard
use Board
run Sinatra::Application
