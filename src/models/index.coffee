
fs = require('fs')
path = require('path')
Sequelize = require('sequelize')
env = process.env.NODE_ENV || "development"
config = require("../config/config.json")[env]

console.log("ENV: ", process.env.NODE_ENV)

db = {}
console.log( "PASSWORD", (env.DB_PASSWORD || config.password) )

sequelize = new Sequelize((env.DB_NAME || config.database), (env.DB_USERNAME || config.username), (env.DB_PASSWORD || config.password) , {
  dialect: config.dialect,
  host: (env.DB_HOST || config.host),
  pool: config.pool,
  dialectOptions: {
    multipleStatements: true
  }
})

excludeFiles = [
  "index.js",
  "index.coffee",
  "index.js.map"
]

fs.readdirSync(__dirname).filter((file) ->
  file.indexOf('.') != 0 and excludeFiles.indexOf(file) < 0
).forEach (file) ->
  model = sequelize.import(path.join(__dirname, file))
  db[model.name] = model
  return

Object.keys(db).forEach (modelName) ->
  if 'associate' of db[modelName]
    db[modelName].associate db
  return

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;
