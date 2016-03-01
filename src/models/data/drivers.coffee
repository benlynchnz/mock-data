_ = require 'lodash'
moment = require 'moment'
Guid = require 'guid'

status = ['active']
names = ['Ben Lynch', 'John Wang', 'Pushkar Gupte', 'Ted Chen', 'Celso Dolendo', 'Khoa Do', 'Nick Fu', 'Ivan Lyutov', 'Dmitry Nitsa', 'Nitin Prasad']
location = ['NZ', 'AU', 'US', 'CN']

API = ->

API.get = (count, callback) ->
    data = []
    x = 0

    while x < count
        name = _.sample(names)
        driver_id = "AB" + _.random(1000000, 9999999)
        data.push(
            id: Guid.create()
            status: _.sample(status)
            created_at: moment().subtract(_.random(1, 365), 'days').subtract(_.random(1, 60), 'minutes').toISOString()
            first_name: name.split(" ")[0]
            last_name: name.split(" ")[1]
            alias: name.split(" ").join("").toLowerCase()
            mobile_phone: "0" + _.random(21, 29) + _.random(100000, 999999)
            driver_id_type: "license",
            driver_id: driver_id
            driver_pin: _.random(1000, 9999)
            licenses: [
                id: Guid.create()
                license_id: driver_id
                display_name: "NZ Drivers License"
                is_primary: true,
                jurisdiction: _.sample(location)
                expiry: moment().add(_.random(1, 365), 'days').subtract(_.random(1, 60), 'minutes').toISOString()
            ]
        )

        x++

    _.delay () ->
        callback(null, data)
    , 300

module.exports = API
