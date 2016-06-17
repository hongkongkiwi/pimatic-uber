capitalizeFirstLetter = (string) =>
    return string.charAt(0).toUpperCase() + string.slice(1)

module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take
  # a look at the dependencies section in pimatics package.json

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  Uber = require 'node-uber'
  # express = require 'express'
  # url = require 'url'

  class UberPlugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins`
    #     section of the config.json file
    #
    #
    init: (app, @framework, @config) =>
      ##env.logger.info("Hello World")

      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("UberPriceEstimateDevice", {
        configDef: deviceConfigDef.UberPriceEstimateDevice,
        createCallback: (config) => return new UberPriceEstimateDevice(config)
      })

  class UberPriceEstimateDevice extends env.devices.Device

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @longitude = @config.longitude
      @latitude = @config.latitude

      @uber = new Uber {
        client_id: @config.clientId,
        client_secret: @config.clientSecret,
        server_token: @config.serverToken,
        redirect_uri: 'http://localhost:3000/api/callback',
        name: 'Pimatic Uber',
        language: @config.language,
        sandbox: @config.sandbox
      }

      for k in @config.productIds
        @attributes[k] = {
          description: "blah blah"
          acronym: "blah"
          unit: '$'
          type: "number"
        }
        this['get' + capitalizeFirstLetter(k)] = () -> Promise.resolve(1)

      # @uber.products.getAllForLocation @latitude, @longitude, (err, res) ->
      #   if err?
      #     return env.logger.error err
      #
      #   for k in res.products
      #     @attributes[k.product_id] = {
      #       description: "blah blah"
      #       acronym: "blah"
      #       unit: '$'
      #       type: "number"
      #     }
      #     this['get' + capitalizeFirstLetter(k.product_id)] = () -> Promise.resolve(1)


      super()
      #@intervalTimerId = setInterval(@requestPollutionReading, @updateInterval * 1000)
      @refreshProducts()

    destroy: () ->
      #@intervalTimerId = setInterval(@refreshInfo, @updateInterval * 1000)
      super()

    getBlah: () -> Promise.resolve(Number 1)

    refreshProducts: () =>
      console.log this

      # @uber.products.getAllForLocation @latitude, @longitude, (err, res) ->
      #   if err?
      #     return env.logger.error err

        #console.log res.products
        # for k in res.products
        #   if k.price_details?
        #     productId = k.product_id.replace(/-/g,'')
        #
        #     self.attributes[productId] = {
        #       description: k.short_description
        #       acronym: k.display_name
        #       unit: '$'
        #       type: "number"
        #     }
        #
        #     getterName = 'get' + capitalizeFirstLetter(productId)
        #     attributeName = '_' + productId
        #     self[attributeName] = 1
        #
        #     #self[attributeName] = k.price_details.cost_per_minute
        #     #console.log attributeName, self[attributeName]
        #
        #     #emit '_' + k.product_id, @['_' + k.product_id]
        #     # console.log k
        #     # console.log @attributes
        #
        #     # Create a getter for this attribute
        #     #self[getterName] = () =>
        #       # if self['_' + productId]?
        #       #   Promise.resolve(self['_' + productId])
        #     #  Promise.resolve(2)
        #
        # console.log(self)

        # UberPrice:
        #   description: "Current Price for UberBlack"
        #   type: "number"
        #   acronym: 'Uber'
        #   unit: "$"

    # refreshInfo: () =>
    #   console.log('refreshed!')
    #   @uber.products.getAllForLocation @latitude, @longitude, (err, res) ->
    #     if err?
    #       return env.logger.error err
    #
    #     console.log res.products
    #
    #     env.logger.debug "UberRouteDevice refreshInfo()", res.products
    #
    #     @emit "UberXPrice", Number @_uberXPrice
    #     @emit "UberPrice", Number @_uberPrice

    # getUberXPrice: () => Promise.resolve(@_uberXPrice)
    # getUberPrice: () => Promise.resolve(@_uberPrice)

    # downloadState: () ->
    #   return wink_device_id_map()
    #     .then( (result) => wink_shade(result[@name].device_id, undefined) )
    #     .then( (result) => @_setPosition(result) )
    #

  # ###Finally
  # Create a instance of my plugin
  plugin = new UberPlugin
  # and return it to the framework.
  return plugin
