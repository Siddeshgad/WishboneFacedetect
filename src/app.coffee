express = require('express')
models = require('./models')
bodyParser = require('body-parser')
db = require('./models/index')
expressValidator = require('express-validator')

app = express()
router = express.Router()
PORT = process.env.PORT || 5000;

app.use bodyParser.urlencoded(extended: false)
app.use(expressValidator())

app.set('view engine', 'hbs')
app.set('views', __dirname + '/views')

app.set 'port', process.env.PORT or PORT

###models.sequelize.sync({ logging: console.log }).then ->
 console.log ('model synced')
 return###

app.use(require('./routes'))

app.get '/', (req, res) ->
  res.send 'Hello World!!';
  return

app.listen PORT, ->
  console.log 'Example app listening on port '+PORT
  return

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
  return

# error handler
# no stacktraces leaked to user unless in development environment
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: if app.get('env') == 'development' then err else {}
  return
