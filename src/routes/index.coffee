express = require ('express')
router = express.Router()

router.use('/', require('./Celeb')(express,router))

module.exports = router